# GitHub Actions 自动更新说明

## 功能说明

本仓库配置了 GitHub Actions，可以**每月自动更新** Stata Journal 数据库文件 (`findsj.dta`)。

## 更新原理

脚本通过以下方式检测新文章：
1. 读取现有数据库中最大的 artid 编号（如 st0787）
2. 依次检查后续编号的文章是否存在（st0788, st0789, ...）
3. 从 Stata Journal 网站抓取新文章的详细信息
4. 自动添加到数据库并提交

## 工作流程

1. **定时触发**：每月1号的 00:00 UTC（北京时间上午8点）自动运行
2. **检查新文章**：从最新artid开始，检查后续50个编号
3. **抓取信息**：获取标题、作者、DOI、卷期等信息
4. **更新数据库**：将新文章添加到 `findsj.dta`
5. **自动提交**：如果有新文章，自动提交更新

## 手动触发更新

如果需要立即更新数据库（不等待定时任务），可以手动触发：

1. 进入仓库页面：https://github.com/BlueDayDreeaming/findsj
2. 点击 **Actions** 标签
3. 选择左侧的 **Auto Update Stata Journal Database** 工作流
4. 点击右侧的 **Run workflow** 按钮
5. 点击绿色的 **Run workflow** 确认

## 查看更新历史

- **Commits**：查看提交历史，标题为 "Auto update: Stata Journal database updated on YYYY-MM-DD"
- **Actions**：查看每次运行的详细日志和结果

## 配置修改

如果需要修改更新频率，编辑文件：`.github/workflows/auto-update.yml`

```yaml
on:
  schedule:
    - cron: '0 0 1 * *'  # 每月1号运行
```

Cron 语法说明：
- `'0 0 1 * *'` - 每月1号 00:00
- `'0 0 * * 0'` - 每周日 00:00
- `'0 0 * * *'` - 每天 00:00

## 依赖项

工作流会自动安装以下 Python 包：
- pandas
- requests
- beautifulsoup4
- pyreadstat (用于读写 Stata 文件)

## 注意事项

1. **权限**：GitHub Actions 需要有 write 权限才能提交更新
2. **网络访问**：需要能够访问 https://www.stata-journal.com/
3. **文件格式**：确保 `findsj.dta` 和 `sj_with_artid.dta` 兼容

## 故障排查

如果更新失败，检查：
1. Actions 页面的错误日志
2. 网络连接是否正常
3. Python 脚本是否有语法错误
4. 数据文件格式是否正确
