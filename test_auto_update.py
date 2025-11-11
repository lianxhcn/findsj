#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
Test Script for Stata Journal Auto-Update
This script tests the update functionality using findsj_test.dta
"""

import pandas as pd
import requests
from bs4 import BeautifulSoup
import re
from datetime import datetime
import time
import shutil
import sys

# Set output encoding
if sys.platform == 'win32':
    try:
        sys.stdout.reconfigure(encoding='utf-8')
    except:
        pass

# ==================== Configuration ====================
DTA_FILE = 'findsj_test.dta'  # Test database
SEARCH_URL = 'https://www.stata-journal.com/sjsearch.html?choice=keyword&q='
SLEEP_TIME = 0.5  # Sleep time between requests (seconds)

# ==================== Utility Functions ====================

def fetch_all_artids():
    """Fetch all article IDs from search page (sorted newest to oldest)"""
    print(f"\n[1] Fetching article list from search page...")
    headers = {'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36'}
    
    try:
        response = requests.get(SEARCH_URL, headers=headers, timeout=30)
        if response.status_code != 200:
            print(f"    Error: HTTP {response.status_code}")
            return []
        
        # Extract all article IDs
        artid_pattern = r'(st\d{4}(?:_\d+)?|dm\d{4}|gn\d{4}|pr\d{4}|gr\d{4}|si\d{4}|tt\d{4})'
        artids = re.findall(artid_pattern, response.text)
        
        # Remove duplicates while preserving order (newest to oldest)
        unique_artids = list(dict.fromkeys(artids))
        
        print(f"    Found {len(unique_artids)} unique article IDs")
        print(f"    Newest: {unique_artids[0] if unique_artids else 'N/A'}")
        print(f"    Oldest: {unique_artids[-1] if unique_artids else 'N/A'}")
        
        return unique_artids
    except Exception as e:
        print(f"    Exception: {e}")
        return []

def fetch_article_info(artid):
    """Fetch article details from webpage"""
    # Try normal URL first
    url = f"https://www.stata-journal.com/article.html?article={artid}"
    headers = {'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36'}
    
    try:
        response = requests.get(url, headers=headers, timeout=10)
        
        # If 404, try with BOM encoding
        if response.status_code == 404:
            url = f"https://www.stata-journal.com/article.html?article=%EF%BB%BF{artid}"
            response = requests.get(url, headers=headers, timeout=10)
        
        if response.status_code == 404:
            return None
        if response.status_code != 200:
            return None
        
        soup = BeautifulSoup(response.content, 'html.parser')
        info = {'artid': artid}
        
        # Get title
        h2_tag = soup.find('h2')
        if h2_tag:
            info['title'] = h2_tag.get_text(strip=True)
        else:
            return None
        
        # Get author
        author_div = soup.find('div', class_='authorlist')
        if author_div:
            info['author'] = author_div.get_text(strip=True)
        
        # Get DOI
        sage_link = soup.find('a', href=re.compile(r'journals\.sagepub\.com/doi/'))
        if sage_link:
            href = sage_link.get('href', '')
            doi_match = re.search(r'doi/(pdf/)?(10\.\d+/[^?&#]+)', href)
            if doi_match:
                info['DOI'] = doi_match.group(2).lower()
        
        # Get volume and issue
        volume_info = soup.find('h4')
        if volume_info:
            text = volume_info.get_text()
            volume_match = re.search(r'Volume\s+(\d+)', text)
            number_match = re.search(r'Number\s+(\d+)', text)
            
            if volume_match:
                info['volume'] = int(volume_match.group(1))
                # year = 2000 + volume
                info['year'] = 2000 + info['volume']
            if number_match:
                info['number'] = int(number_match.group(1))
        
        return info
    except Exception as e:
        return None

def find_new_articles(all_artids, existing_df):
    """Find new articles not in existing database"""
    existing_artids = set(existing_df['artid'].dropna().astype(str).unique())
    
    # Find artids not in existing database
    new_artids = [aid for aid in all_artids if aid not in existing_artids]
    
    print(f"\n[3] Analyzing new articles...")
    print(f"    Search page articles: {len(all_artids)}")
    print(f"    Existing database: {len(existing_artids)}")
    print(f"    New articles: {len(new_artids)}")
    
    if not new_artids:
        return pd.DataFrame()
    
    print(f"\n    New article list: {', '.join(new_artids[:20])}")
    if len(new_artids) > 20:
        print(f"    ... and {len(new_artids) - 20} more")
    
    # Fetch details for new articles
    print(f"\n[4] Fetching details for new articles...")
    new_articles = []
    
    for i, artid in enumerate(new_artids):
        print(f"    [{i+1}/{len(new_artids)}] {artid}...", end=' ', flush=True)
        
        info = fetch_article_info(artid)
        if info:
            new_articles.append(info)
            print("[OK]")
        else:
            print("[SKIP]")
        
        if i < len(new_artids) - 1:
            time.sleep(SLEEP_TIME)
    
    return pd.DataFrame(new_articles) if new_articles else pd.DataFrame()

# ==================== Main Program ====================

def main():
    print("=" * 70)
    print("Stata Journal Auto-Update Program - TEST VERSION")
    print(f"Time: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}")
    print(f"Database: {DTA_FILE}")
    print("Strategy: Fetch all artids from search page and check for new articles")
    print("=" * 70)
    
    # 1. Fetch all article IDs from search page
    all_artids = fetch_all_artids()
    if not all_artids:
        print("\nError: Cannot fetch article list")
        return
    
    # 2. Read existing database
    print(f"\n[2] Reading existing database...")
    try:
        dta_df = pd.read_stata(DTA_FILE)
        print(f"    Existing records: {len(dta_df)}")
    except Exception as e:
        print(f"    Error: {e}")
        return
    
    # 3-4. Find and fetch new articles
    new_df = find_new_articles(all_artids, dta_df)
    
    if len(new_df) == 0:
        print("\n[OK] No new articles, database is up to date!")
        return
    
    # 5. Backup original file
    print(f"\n[5] Backing up original file...")
    backup_file = f"findsj_test_backup_{datetime.now().strftime('%Y%m%d_%H%M%S')}.dta"
    try:
        shutil.copy(DTA_FILE, backup_file)
        print(f"    Backup: {backup_file}")
    except Exception as e:
        print(f"    Warning: Backup failed - {e}")
    
    # 6. Merge data
    print(f"\n[6] Merging data...")
    common_cols = list(set(dta_df.columns) & set(new_df.columns))
    updated_df = pd.concat([dta_df, new_df[common_cols]], ignore_index=True)
    updated_df = updated_df.drop_duplicates(subset=['artid'], keep='last')
    
    # 7. Save updated database
    print(f"\n[7] Saving updates...")
    try:
        # Clean fields that may contain special characters
        for col in ['title', 'author']:
            if col in updated_df.columns:
                updated_df[col] = updated_df[col].apply(
                    lambda x: x.encode('latin-1', errors='ignore').decode('latin-1') 
                    if isinstance(x, str) else x
                )
        
        updated_df.to_stata(DTA_FILE, write_index=False, version=117)
        print(f"    Saved successfully: {DTA_FILE}")
    except Exception as e:
        print(f"    Error: {e}")
        print(f"    Trying alternative encoding...")
        try:
            updated_df.to_stata(DTA_FILE, write_index=False, version=117, convert_strl=['title', 'author'])
            print(f"    Saved successfully with strl: {DTA_FILE}")
        except Exception as e2:
            print(f"    Still failed: {e2}")
            return
    
    # 8. Summary
    print("\n" + "=" * 70)
    print("TEST COMPLETED SUCCESSFULLY!")
    print("=" * 70)
    print(f"Before: {len(dta_df)} records")
    print(f"Added:  {len(new_df)} records")
    print(f"After:  {len(updated_df)} records")
    print(f"Backup: {backup_file}")
    
    print("\nSample of new articles (showing first 5):")
    for idx, row in new_df.head(5).iterrows():
        print(f"\n  {row['artid']}:")
        print(f"    Title: {row['title'][:60]}..." if len(row['title']) > 60 else f"    Title: {row['title']}")
        if pd.notna(row.get('volume')) and pd.notna(row.get('number')):
            print(f"    Issue: Vol.{int(row['volume'])} No.{int(row['number'])} ({int(row['year'])})")
    
    if len(new_df) > 5:
        print(f"\n  ... and {len(new_df) - 5} more articles")
    
    print("\n" + "=" * 70)
    print("✓ Test script executed successfully!")
    print("✓ The update mechanism is working correctly.")
    print("=" * 70)

if __name__ == '__main__':
    main()
