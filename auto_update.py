#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
Stata Journal 自动更新脚本
使用方法：
1. 访问 https://www.stata-journal.com/sjsearch.html?choice=keyword&q=
2. 查看网页源代码 (Ctrl+U)，保存为 HTML 文件到当前目录
3. 运行：python auto_update.py
"""

import pandas as pd
import requests
from bs4 import BeautifulSoup
import re
from datetime import datetime
import time
import shutil
from difflib import SequenceMatcher

# ==================== 配置 ====================
DTA_FILE = 'sj_with_artid.dta'
HTML_FILE = 'view-source_https___www.stata-journal.com_sjsearch.html_choice=keyword&q=.html'

# ==================== 工具函数 ====================

def fetch_article_info(artid):
    """从网页获取文章信息"""
    url = f"https://www.stata-journal.com/article.html?article={artid}"
    headers = {'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36'}
    
    try:
        response = requests.get(url, headers=headers, timeout=10)
        if response.status_code != 200:
            return None
        
        soup = BeautifulSoup(response.content, 'html.parser')
        info = {}
        
        # 获取标题
        h2_tag = soup.find('h2')
        if h2_tag:
            info['title'] = h2_tag.get_text(strip=True)
        
        # 获取DOI
        sage_link = soup.find('a', href=re.compile(r'journals\.sagepub\.com/doi/'))
        if sage_link:
            href = sage_link.get('href', '')
            doi_match = re.search(r'doi/(pdf/)?(10\.\d+/[^?&#]+)', href)
            if doi_match:
                info['DOI'] = doi_match.group(2).lower()
        
        # 获取卷期
        volume_info = soup.find('h4')
        if volume_info:
            text = volume_info.get_text()
            volume_match = re.search(r'Volume\s+(\d+)', text)
            number_match = re.search(r'Number\s+(\d+)', text)
            if volume_match:
                info['volume'] = int(volume_match.group(1))
            if number_match:
                info['number'] = int(number_match.group(1))
        
        return info
    except:
        return None

def parse_html(html_file):
    """解析HTML文件获取文章列表"""
    print(f"解析 {html_file}...")
    
    with open(html_file, 'r', encoding='utf-8') as f:
        html_content = f.read()
    
    soup = BeautifulSoup(html_content, 'html.parser')
    table = soup.find('table')
    
    if not table:
        print("警告: 未找到表格")
        return pd.DataFrame()
    
    articles = []
    for row in table.find_all('tr'):
        cells = row.find_all('td')
        if len(cells) >= 6:
            try:
                artid_link = cells[0].find('a')
                if not artid_link:
                    continue
                
                artid = artid_link.text.strip()
                if artid.lower() in ['artid', 'article']:
                    continue
                
                articles.append({
                    'artid': artid,
                    'title': cells[1].get_text(strip=True),
                    'author': cells[2].get_text(strip=True),
                    'year': int(cells[3].get_text(strip=True)) if cells[3].get_text(strip=True) else None,
                    'volume': int(cells[4].get_text(strip=True)) if cells[4].get_text(strip=True) else None,
                    'number': int(cells[5].get_text(strip=True)) if cells[5].get_text(strip=True) else None,
                    'DOI': None
                })
            except:
                continue
    
    print(f"解析到 {len(articles)} 篇文章")
    return pd.DataFrame(articles)

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
    
    # 2. 解析HTML
    print(f"\n[2] 解析HTML源文件...")
    html_df = parse_html(HTML_FILE)
    
    if len(html_df) == 0:
        print("    警告: HTML解析失败或无数据")
        return
    
    # 3. 查找新文章
    print(f"\n[3] 查找新增文章...")
    existing_artids = set(dta_df['artid'].dropna().unique())
    html_artids = set(html_df['artid'].unique())
    new_artids = html_artids - existing_artids
    
    print(f"    HTML中的文章: {len(html_artids)}")
    print(f"    现有文章: {len(existing_artids)}")
    print(f"    新增文章: {len(new_artids)}")
    
    if len(new_artids) == 0:
        print("\n✅ 没有新文章，数据已是最新！")
        return
    
    # 4. 显示新文章
    print(f"\n[4] 新增文章列表:")
    new_df = html_df[html_df['artid'].isin(new_artids)].copy()
    for idx, row in new_df.iterrows():
        print(f"    • {row['artid']}: {row['title'][:60]}...")
    
    # 5. 获取详细信息
    print(f"\n[5] 获取新文章详细信息...")
    for idx, row in new_df.iterrows():
        artid = row['artid']
        print(f"    [{idx+1}/{len(new_df)}] {artid}...", end=' ')
        
        info = fetch_article_info(artid)
        if info:
            for key in ['title', 'DOI', 'volume', 'number']:
                if key in info and info[key]:
                    new_df.at[idx, key] = info[key]
            print("✓")
        else:
            print("×")
        
        time.sleep(1)  # 避免请求过快
    
    # 6. 备份
    print(f"\n[6] 备份原文件...")
    backup_file = f"sj_with_artid_backup_{datetime.now().strftime('%Y%m%d_%H%M%S')}.dta"
    try:
        shutil.copy(DTA_FILE, backup_file)
        print(f"    备份: {backup_file}")
    except Exception as e:
        print(f"    警告: 备份失败 - {e}")
    
    # 7. 合并数据
    print(f"\n[7] 合并数据...")
    common_cols = list(set(dta_df.columns) & set(new_df.columns))
    updated_df = pd.concat([dta_df, new_df[common_cols]], ignore_index=True)
    updated_df = updated_df.drop_duplicates(subset=['artid'], keep='last')
    
    # 8. 保存
    print(f"\n[8] 保存更新...")
    try:
        updated_df.to_stata(DTA_FILE, write_index=False, version=117)
        print(f"    成功保存: {DTA_FILE}")
    except Exception as e:
        print(f"    错误: {e}")
        return
    
    # 9. 总结
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
        print(f"    作者: {row['author']}")
        if pd.notna(row.get('volume')) and pd.notna(row.get('number')):
            print(f"    卷期: Vol.{row['volume']} No.{row['number']}")
        if pd.notna(row.get('DOI')):
            print(f"    DOI:  {row['DOI']}")
    
    print("\n" + "=" * 70)

if __name__ == '__main__':
    main()
