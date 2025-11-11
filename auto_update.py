#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
Stata Journal 自动更新脚本
通过检查最新的artid编号来发现新文章
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
MAX_ARTID_TO_CHECK = 50  # 检查最近N个artid编号
SLEEP_TIME = 0.5  # 请求间隔（秒）

# ==================== 工具函数 ====================

def fetch_article_info(artid):
    """从网页获取文章信息"""
    url = f"https://www.stata-journal.com/article.html?article={artid}"
    headers = {'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36'}
    
    try:
        response = requests.get(url, headers=headers, timeout=10)
        if response.status_code == 404:
            return None  # 文章不存在
        if response.status_code != 200:
            return None
        
        soup = BeautifulSoup(response.content, 'html.parser')
        info = {'artid': artid}
        
        # 获取标题
        h2_tag = soup.find('h2')
        if h2_tag:
            info['title'] = h2_tag.get_text(strip=True)
        else:
            return None  # 没有标题说明这不是有效的文章页面
        
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
                # year = volume (从2001年第1卷开始，所以 year = 2000 + volume)
                info['year'] = 2000 + info['volume']
            if number_match:
                info['number'] = int(number_match.group(1))
        
        return info
    except Exception as e:
        print(f"      异常: {e}")
        return None

def find_new_articles(existing_df):
    """查找新文章"""
    # 获取现有的所有artid
    existing_artids = set(existing_df['artid'].dropna().astype(str).unique())
    
    # 提取数字最大的artid
    st_artids = [aid for aid in existing_artids if aid.startswith('st')]
    if not st_artids:
        return pd.DataFrame()
    
    # 提取数字部分
    nums = [int(re.search(r'\d+', aid).group()) for aid in st_artids if re.search(r'\d+', aid)]
    if not nums:
        return pd.DataFrame()
    
    max_num = max(nums)
    print(f"    现有最大artid编号: st{max_num:04d}")
    
    # 检查后续编号
    new_articles = []
    consecutive_failures = 0
    
    for num in range(max_num + 1, max_num + MAX_ARTID_TO_CHECK + 1):
        artid = f"st{num:04d}"
        if artid in existing_artids:
            continue
        
        print(f"    检查 {artid}...", end=' ', flush=True)
        info = fetch_article_info(artid)
        
        if info:
            print(f"✓")
            new_articles.append(info)
            consecutive_failures = 0
        else:
            print(f"×")
            consecutive_failures += 1
            # 如果连续10个不存在，停止检查
            if consecutive_failures >= 10:
                print(f"    (连续{consecutive_failures}个artid不存在，停止检查)")
                break
        
        time.sleep(SLEEP_TIME)
    
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
