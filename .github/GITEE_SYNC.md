# Gitee 自动更新方案

由于 Gitee 免费版不支持类似 GitHub Actions 的自动化功能，我们提供以下替代方案：

## 方案对比

| 方案 | 优点 | 缺点 | 适用场景 |
|------|------|------|----------|
| **GitHub Actions + Gitee 同步** | 全自动，无需本地运行 | 需要配置 SSH 密钥 | 推荐 ⭐⭐⭐⭐⭐ |
| **本地定时任务** | 简单直接 | 需要电脑保持开机 | 备用方案 |
| **手动运行** | 最简单 | 需要记得运行 | 临时使用 |

---

## 方案 1: GitHub Actions + Gitee 自动同步 (推荐)

### 工作原理
1. GitHub Actions 每月自动更新数据库
2. 更新后自动同步到 Gitee
3. 两个平台保持同步

### 配置步骤

#### 1. 生成 SSH 密钥对
```bash
ssh-keygen -t rsa -C "your_email@example.com" -f gitee_deploy_key
```

#### 2. 在 Gitee 添加公钥
1. 访问：https://gitee.com/ChuChengWan/findsj/settings/deploy_keys
2. 点击 "添加部署公钥"
3. 标题：`GitHub Actions Sync`
4. 复制 `gitee_deploy_key.pub` 的内容粘贴
5. ✅ 勾选 "允许推送"
6. 点击 "确定"

#### 3. 在 GitHub 添加私钥
1. 访问：https://github.com/BlueDayDreeaming/findsj/settings/secrets/actions
2. 点击 "New repository secret"
3. Name: `GITEE_PRIVATE_KEY`
4. Value: 复制 `gitee_deploy_key` (私钥) 的全部内容
5. 点击 "Add secret"

#### 4. 测试同步
1. 推送代码到 GitHub
2. 访问：https://github.com/BlueDayDreeaming/findsj/actions
3. 应该会自动触发 "Sync to Gitee" 工作流
4. 检查 Gitee 仓库是否已同步

---

## 方案 2: 本地定时任务

### Windows 任务计划程序设置

#### 1. 创建批处理脚本
创建文件 `auto_update.bat`:
```batch
@echo off
cd /d "d:\User\private\Desktop\stata\findsj_v3"
python auto_update_and_push.py >> update_log.txt 2>&1
```

#### 2. 设置任务计划
1. 按 `Win+R`，输入 `taskschd.msc`，回车
2. 右侧点击 "创建基本任务"
3. 填写信息：
   - 名称: `Stata Journal Auto Update`
   - 描述: `每月自动更新 Stata Journal 数据库`
4. 触发器: 选择 "每月"
   - 日期: 每月 1 号
   - 时间: 08:00 (或您希望的时间)
5. 操作: "启动程序"
   - 程序: `d:\User\private\Desktop\stata\findsj_v3\auto_update.bat`
6. 完成

#### 3. 测试运行
```powershell
# 手动测试一次
python auto_update_and_push.py
```

### Linux/Mac cron 设置

编辑 crontab:
```bash
crontab -e
```

添加以下行（每月1号 8:00 运行）:
```cron
0 8 1 * * cd /path/to/findsj_v3 && python3 auto_update_and_push.py >> update_log.txt 2>&1
```

---

## 方案 3: 手动运行

最简单的方式，每月手动运行一次：

```powershell
cd d:\User\private\Desktop\stata\findsj_v3
python auto_update_and_push.py
```

---

## 当前状态

✅ **GitHub**: 已配置 GitHub Actions，每月1号自动更新  
⚠️  **Gitee**: 需要选择上述方案之一来实现同步

## 推荐配置

**最佳方案**: 方案 1 (GitHub Actions + Gitee 同步)
- GitHub 自动更新数据库
- 自动同步到 Gitee
- 完全无需人工干预

**备用方案**: 方案 3 (手动运行)
- 每月记得运行一次 `auto_update_and_push.py`
- 简单可靠

## 文件说明

- `.github/workflows/auto-update.yml` - GitHub 自动更新
- `.github/workflows/sync-to-gitee.yml` - Gitee 同步
- `auto_update.py` - 数据更新脚本
- `auto_update_and_push.py` - 本地自动更新+推送脚本
