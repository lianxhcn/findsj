#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
Gitee 自动更新和推送脚本
由于 Gitee 免费版不支持 CI/CD，此脚本可以在本地定时运行
使用 Windows 任务计划程序 或 Linux cron 来定期执行
"""

import subprocess
import os
from datetime import datetime

def run_command(cmd, description):
    """运行命令并打印输出"""
    print(f"\n{'='*70}")
    print(f"[{datetime.now().strftime('%Y-%m-%d %H:%M:%S')}] {description}")
    print(f"{'='*70}")
    
    try:
        result = subprocess.run(
            cmd, 
            shell=True, 
            check=True, 
            capture_output=True, 
            text=True,
            encoding='utf-8'
        )
        if result.stdout:
            print(result.stdout)
        return True
    except subprocess.CalledProcessError as e:
        print(f"错误: {e}")
        if e.stderr:
            print(e.stderr)
        return False

def main():
    """主函数：更新数据并推送到 GitHub 和 Gitee"""
    
    print(f"\n{'#'*70}")
    print(f"# Stata Journal 数据库自动更新脚本")
    print(f"# 开始时间: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}")
    print(f"{'#'*70}")
    
    # 1. 下载最新的搜索页面
    if not run_command(
        'curl -A "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36" '
        '-o "view-source_https___www.stata-journal.com_sjsearch.html_choice=keyword&q=.html" '
        '"https://www.stata-journal.com/sjsearch.html?choice=keyword&q="',
        "步骤 1: 下载 Stata Journal 搜索页面"
    ):
        print("\n❌ 下载失败，终止执行")
        return False
    
    # 2. 运行更新脚本
    if not run_command(
        'python auto_update.py',
        "步骤 2: 运行数据更新脚本"
    ):
        print("\n❌ 更新脚本执行失败")
        return False
    
    # 3. 检查是否有变化
    result = subprocess.run(
        'git diff --quiet findsj.dta',
        shell=True
    )
    
    if result.returncode == 0:
        print("\n✓ 数据库无更新，无需提交")
        return True
    
    print("\n✓ 检测到数据库更新，准备提交...")
    
    # 4. 提交更改
    commit_msg = f"Auto update: Stata Journal database updated on {datetime.now().strftime('%Y-%m-%d')}"
    
    commands = [
        ('git add findsj.dta sj_with_artid.dta', "添加更新的文件"),
        (f'git commit -m "{commit_msg}"', "提交更改"),
        ('git push origin main', "推送到 GitHub"),
        ('git push gitee main', "推送到 Gitee"),
    ]
    
    for cmd, desc in commands:
        if not run_command(cmd, desc):
            print(f"\n⚠️  {desc} 失败，但继续执行...")
    
    print(f"\n{'#'*70}")
    print(f"# ✅ 自动更新完成")
    print(f"# 结束时间: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}")
    print(f"{'#'*70}\n")
    
    return True

if __name__ == '__main__':
    try:
        success = main()
        exit(0 if success else 1)
    except Exception as e:
        print(f"\n❌ 发生未预期的错误: {e}")
        exit(1)
