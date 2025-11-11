# GitHub Actions 工作流测试清单

## 推送前检查

在推送到 GitHub 之前，请确认以下内容：

### 1. 文件结构
```
findsj_v3/
├── .github/
│   ├── workflows/
│   │   └── auto-update.yml      ✓ GitHub Actions 工作流
│   └── AUTO_UPDATE.md           ✓ 自动更新说明文档
├── auto_update.py               ✓ 更新脚本
├── findsj.dta                   ✓ 数据库文件
└── README.md / README_CN.md     ✓ 已添加自动更新说明
```

### 2. 工作流配置验证

**定时任务**:
- Cron 表达式: `0 0 1 * *` (每月1号 00:00 UTC)
- 北京时间相当于: 每月1号上午8点

**手动触发**:
- 已启用 `workflow_dispatch`

**依赖项**:
- [x] pandas
- [x] requests
- [x] beautifulsoup4
- [x] pyreadstat

### 3. 权限要求

GitHub Actions 需要以下权限：
- **Read**: 读取仓库代码
- **Write**: 提交更新后的文件

默认的 `GITHUB_TOKEN` 已包含这些权限。

### 4. 本地测试（可选）

在推送前，可以本地测试 Python 脚本：

```bash
# 1. 下载搜索页面
curl -A "Mozilla/5.0" -o "view-source_https___www.stata-journal.com_sjsearch.html_choice=keyword&q=.html" "https://www.stata-journal.com/sjsearch.html?choice=keyword&q="

# 2. 运行更新脚本
python auto_update.py
```

### 5. 推送后验证

推送到 GitHub 后，检查：

1. **Actions 标签页**: 
   - URL: https://github.com/BlueDayDreeaming/findsj/actions
   - 应该能看到 "Auto Update Stata Journal Database" 工作流

2. **手动触发测试**:
   - 点击工作流名称
   - 点击 "Run workflow"
   - 等待运行完成，查看日志

3. **检查定时任务**:
   - 在工作流页面可以看到下次运行时间

## 常见问题

### Q1: 工作流没有出现在 Actions 页面
**A**: 确保 `.github/workflows/auto-update.yml` 文件已推送到 main 分支

### Q2: 工作流运行失败
**A**: 
1. 查看 Actions 页面的错误日志
2. 检查 Python 脚本语法
3. 确认网络可以访问 Stata Journal 网站

### Q3: 定时任务没有按时运行
**A**: 
- GitHub Actions 的定时任务可能有5-15分钟延迟
- 可以先用手动触发测试功能是否正常

### Q4: 提交失败 (Permission denied)
**A**: 
- 检查仓库设置中 Actions 的权限
- Settings → Actions → General → Workflow permissions
- 选择 "Read and write permissions"

## 推送命令

确认无误后，执行以下命令推送：

```bash
git add .github/
git add README.md README_CN.md
git commit -m "Add GitHub Actions for automated monthly database updates"
git push
```

## 后续维护

- 每月1号检查 Actions 页面，确认自动更新成功
- 如果需要更改频率，修改 `.github/workflows/auto-update.yml` 中的 cron 表达式
- 查看提交历史，了解数据库更新情况
