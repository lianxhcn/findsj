#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
Stata Journal 自动更新脚本
从搜索页面按HTML顺序（从前往后）检查artid，找出新文章
"""

import pandas as pd
import requests
from bs4 import BeautifulSoup
import re
from datetime import datetime
import time
import shutil

# ==================== 配置 ====================
DTA_FILE = 'findsj.dta'
SEARCH_URL = 'https://www.stata-journal.com/sjsearch.html?choice=keyword&q='  # 搜索所有文章
SLEEP_TIME = 0.5  # 请求间隔（秒）

# ==================== 工具函数 ====================

def clean_unicode_for_stata(text):
    """清理文本中无法用 latin-1 编码的 Unicode 字符"""
    if pd.isna(text) or not isinstance(text, str):
        return text
    
    # 替换常见的 Unicode 字符为 ASCII 等效字符
    replacements = {
        '\u2013': '-',      # en dash
        '\u2014': '--',     # em dash
        '\u2018': "'",      # left single quotation mark
        '\u2019': "'",      # right single quotation mark
        '\u201c': '"',      # left double quotation mark
        '\u201d': '"',      # right double quotation mark
        '\u2026': '...',    # horizontal ellipsis
        '\u00a0': ' ',      # non-breaking space
        '\u2022': '*',      # bullet
        '\u00b7': '·',      # middle dot
        '\u2212': '-',      # minus sign
        '\u00d7': 'x',      # multiplication sign
        '\u00f7': '/',      # division sign
        '\u2264': '<=',     # less than or equal to
        '\u2265': '>=',     # greater than or equal to
        '\u2260': '!=',     # not equal to
        '\u00b1': '+/-',    # plus-minus sign
    }
    
    for unicode_char, ascii_char in replacements.items():
        text = text.replace(unicode_char, ascii_char)
    
    # 如果还有无法编码的字符，使用 ASCII 近似
    try:
        text.encode('latin-1')
    except UnicodeEncodeError:
        # 使用 unidecode 或简单替换
        text = text.encode('ascii', errors='ignore').decode('ascii')
    
    return text

def fetch_all_articles_from_search():
    """从搜索页面获取所有文章的artid（按HTML顺序，从新到旧）"""
    print("    从搜索页面获取文章列表...")
    print(f"    URL: {SEARCH_URL}")
    
    headers = {'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36'}
    
    try:
        response = requests.get(SEARCH_URL, headers=headers, timeout=30)
        if response.status_code != 200:
            print(f"    错误: HTTP {response.status_code}")
            return []
        
        soup = BeautifulSoup(response.content, 'html.parser')
        
        # 查找所有包含 article= 的链接
        article_links = soup.find_all('a', href=re.compile(r'article\.html\?article='))
        
        artids = []
        seen_clean_ids = set()
        skipped_up = 0
        
        for link in article_links:
            href = link.get('href', '')
            match = re.search(r'article=([^"&]+)', href)
            if match:
                artid_raw = match.group(1)
                # 保留原始 artid（包括可能的 BOM），用于访问网页
                # 同时记录清理后的版本用于去重
                artid_clean = artid_raw.replace('\ufeff', '').replace('%EF%BB%BF', '').strip()
                
                # 跳过以 "up" 开头的 artid（updates 类文章）
                if artid_clean.lower().startswith('up'):
                    skipped_up += 1
                    continue
                
                if artid_clean not in seen_clean_ids:
                    artids.append(artid_raw)  # 保存原始版本
                    seen_clean_ids.add(artid_clean)
        
        print(f"    找到 {len(artids)} 个唯一的 artid")
        if skipped_up > 0:
            print(f"    跳过 {skipped_up} 个 'up' 开头的文章（updates）")
        return artids
        
    except Exception as e:
        print(f"    错误: {e}")
        return []

def fetch_article_full_info(artid):
    """获取单篇文章的完整信息"""
    # 清理 artid：移除 BOM 和其他不可见字符
    artid_clean = artid.replace('\ufeff', '').replace('\u200b', '').strip()
    
    # 对于包含 BOM 的 artid，需要使用 URL 编码的版本
    # BOM 字符 \ufeff 的 URL 编码是 %EF%BB%BF
    if '\ufeff' in artid:
        artid_url = artid.replace('\ufeff', '%EF%BB%BF')
    else:
        artid_url = artid_clean
    
    url = f"https://www.stata-journal.com/article.html?article={artid_url}"
    headers = {'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36'}
    
    try:
        response = requests.get(url, headers=headers, timeout=10)
        if response.status_code != 200:
            return None
        
        soup = BeautifulSoup(response.content, 'html.parser')
        info = {'artid': artid_clean}  # 存储时使用清理后的 artid
        
        # 获取标题
        h2_tag = soup.find('h2')
        if h2_tag:
            info['title'] = h2_tag.get_text(strip=True)
        else:
            return None
        
        # 获取作者
        author_div = soup.find('div', class_='authorlist')
        if author_div:
            info['author'] = author_div.get_text(strip=True)
        
        # 获取DOI
        sage_link = soup.find('a', href=re.compile(r'journals\.sagepub\.com/doi/'))
        if sage_link:
            href = sage_link.get('href', '')
            doi_match = re.search(r'doi/(pdf/)?(10\.\d+/[^?&#]+)', href)
            if doi_match:
                info['DOI'] = doi_match.group(2).lower()
        
        # 获取卷期年份
        volume_info = soup.find('h4')
        if volume_info:
            text = volume_info.get_text()
            volume_match = re.search(r'Volume\s+(\d+)', text)
            number_match = re.search(r'Number\s+(\d+)', text)
            
            if volume_match:
                info['volume'] = int(volume_match.group(1))
                info['year'] = 2000 + info['volume']
            if number_match:
                info['number'] = int(number_match.group(1))
        
        # 获取页码
        page_span = soup.find('span', class_='pages')
        if page_span:
            page_text = page_span.get_text(strip=True)
            page_match = re.search(r'pp\.\s*(.+)', page_text)
            if page_match:
                info['page'] = page_match.group(1).strip()
        
        return info
    except Exception as e:
        print(f"      异常: {e}")
        return None

def find_new_articles(existing_df):
    """查找新文章：从搜索页面按HTML顺序检查artid"""
    # 获取现有的所有artid
    existing_artids = set(existing_df['artid'].dropna().astype(str).str.replace('\ufeff', '').unique())
    print(f"    本地数据库: {len(existing_artids)} 篇文章")
    
    # 从搜索页面获取所有artid（按HTML顺序）
    all_artids = fetch_all_articles_from_search()
    
    if not all_artids:
        print("    无法获取文章列表")
        return pd.DataFrame()
    
    # 从前往后检查，找出新文章
    print(f"\n    从前往后检查 artid...")
    new_articles = []
    
    for i, artid in enumerate(all_artids, 1):
        artid_clean = artid.replace('\ufeff', '')
        
        if artid_clean in existing_artids:
            # 已存在，跳过
            continue
        else:
            # 新文章，获取完整信息
            print(f"    [{i}/{len(all_artids)}] {artid}... ", end='', flush=True)
            info = fetch_article_full_info(artid)
            
            if info:
                print("✓ 新文章")
                new_articles.append(info)
            else:
                print("× 获取失败")
            
            time.sleep(SLEEP_TIME)
    
    print(f"\n    发现 {len(new_articles)} 篇新文章")
    return pd.DataFrame(new_articles) if new_articles else pd.DataFrame()

# ==================== 主程序 ====================

def main():
    print("=" * 70)
    print("Stata Journal 自动更新程序")
    print(f"时间: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}")
    print("=" * 70)
    
    # 1. 读取现有数据
    print(f"\n[1] 读取现有数据文件...")
    try:
        dta_df = pd.read_stata(DTA_FILE)
        print(f"    现有记录: {len(dta_df)} 条")
    except Exception as e:
        print(f"    错误: {e}")
        return
    
    # 2. 查找新文章
    print(f"\n[2] 查找新文章...")
    new_df = find_new_articles(dta_df)
    
    if len(new_df) == 0:
        print("\n✅ 没有新文章，数据已是最新！")
        return
    
    print(f"\n    发现 {len(new_df)} 篇新文章")
    
    # 3. 备份
    print(f"\n[3] 备份原文件...")
    backup_file = f"findsj_backup_{datetime.now().strftime('%Y%m%d_%H%M%S')}.dta"
    try:
        shutil.copy(DTA_FILE, backup_file)
        print(f"    备份: {backup_file}")
    except Exception as e:
        print(f"    警告: 备份失败 - {e}")
    
    # 4. 合并数据
    print(f"\n[4] 合并数据...")
    common_cols = list(set(dta_df.columns) & set(new_df.columns))
    updated_df = pd.concat([dta_df, new_df[common_cols]], ignore_index=True)
    updated_df = updated_df.drop_duplicates(subset=['artid'], keep='last')
    
    # 清理 Unicode 字符（用于 Stata latin-1 编码）
    print(f"    清理 Unicode 字符...")
    text_columns = ['artid', 'title', 'author', 'DOI', 'page']
    for col in text_columns:
        if col in updated_df.columns:
            updated_df[col] = updated_df[col].apply(clean_unicode_for_stata)
    
    # 5. 保存
    print(f"\n[5] 保存更新...")
    try:
        updated_df.to_stata(DTA_FILE, write_index=False, version=117)
        print(f"    成功保存: {DTA_FILE}")
    except Exception as e:
        print(f"    错误: {e}")
        return
    
    # 6. 总结
    print("\n" + "=" * 70)
    print("更新完成！")
    print("=" * 70)
    print(f"更新前: {len(dta_df)} 条")
    print(f"新增:   {len(new_df)} 条")
    print(f"更新后: {len(updated_df)} 条")
    print(f"备份:   {backup_file}")
    
    print("\n新增文章:")
    for idx, row in new_df.iterrows():
        print(f"\n  {row['artid']}:")
        print(f"    标题: {row['title']}")
        print(f"    作者: {row.get('author', 'N/A')}")
        if pd.notna(row.get('volume')) and pd.notna(row.get('number')):
            print(f"    卷期: Vol.{int(row['volume'])} No.{int(row['number'])}")
        if pd.notna(row.get('year')):
            print(f"    年份: {int(row['year'])}")
        if pd.notna(row.get('DOI')):
            print(f"    DOI:  {row['DOI']}")
    
    print("\n" + "=" * 70)

if __name__ == '__main__':
    main()
