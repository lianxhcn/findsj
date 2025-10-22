# findsj

搜索并引用 Stata Journal 文章

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Stata](https://img.shields.io/badge/Stata-14%2B-blue)](https://www.stata.com/)
[![Version](https://img.shields.io/badge/version-1.0.3-brightgreen)](https://github.com/BlueDayDreeaming/findsj)

[English](README.md) | [中文文档](README_CN.md)

## 概述

`findsj` 是一个 Stata 命令,用于通过关键词、作者姓名或文章标题搜索 **Stata Journal (SJ)** 和 **Stata Technical Bulletin (STB)** 的文章。它显示完整的文章信息,提供官方引文下载链接(BibTeX/RIS),并支持多种格式的批量导出功能。

## 核心功能

- 🔍 **智能搜索**: 支持关键词、作者姓名或文章标题搜索
- 📚 **官方引文**: 直接链接到 Stata Journal 的 BibTeX 和 RIS 下载
- 📋 **批量导出**: 支持纯文本、Markdown 或 LaTeX 格式的批量导出
- 🔗 **丰富链接**: 提供文章页面、PDF 下载、Google Scholar 和相关程序包链接
- 🎯 **DOI 支持**: 可选的实时 DOI 获取功能
- ⚡ **快速易用**: 简洁的语法和智能默认设置

## 安装方法

### 方法 1: 从 SSC 安装 (即将支持)

```stata
ssc install findsj, replace
```

### 方法 2: 从 GitHub 安装

```stata
net install findsj, from(https://raw.githubusercontent.com/BlueDayDreeaming/findsj/main/)
```

### 方法 3: 从 Gitee 安装 (国内镜像)

```stata
net install findsj, from(https://gitee.com/ChuChengWan/findsj/raw/main/)
```

### 方法 4: 手动安装

1. 下载所有文件到本地目录
2. 在 Stata 中运行:

```stata
net install findsj, from("本地路径")
```

## 快速开始

### 1. 基本搜索

关键词搜索:

```stata
findsj machine learning
```

作者搜索:

```stata
findsj, author(Mitchell)
```

### 2. 获取引文

点击结果表格中的 **BibTeX** 或 **RIS** 按钮,直接从 Stata Journal 网站下载引文。

### 3. 批量导出

导出所有引文到剪贴板:

```stata
findsj machine learning, export
```

导出为 Markdown 格式:

```stata
findsj propensity score, export markdown
```

导出为 LaTeX 格式:

```stata
findsj difference-in-differences, export latex
```

## 语法

```stata
findsj [关键词] [, 选项]
```

### 选项说明

#### 搜索选项
- `author(姓名)` - 按作者姓名搜索
- `title(文本)` - 按文章标题搜索
- `issue(期号)` - 限定特定期号 (例如 "20(4)")
- `from(年份)` - 最早发表年份
- `to(年份)` - 最晚发表年份

#### 显示选项
- `detail` - 显示详细文章信息
- `nolink` - 隐藏结果中的可点击链接
- `max(数字)` - 最大显示结果数 (默认: 20, 0 = 全部)

#### 导出选项
- `export` - 导出所有结果到剪贴板(纯文本格式)
- `markdown` - 导出为 Markdown 格式
- `latex` - 导出为 LaTeX 格式

#### 高级选项
- `verbose` - 显示详细操作信息
- `getdoi` - 从 Stata Journal 实时获取 DOI (较慢)

## 使用示例

### 示例 1: 关键词搜索

```stata
findsj regression
```

### 示例 2: 作者搜索及详细信息

```stata
findsj, author(Nichols) detail
```

### 示例 3: 特定期号搜索

```stata
findsj, issue(20(4))
```

### 示例 4: 年份范围搜索

```stata
findsj panel data, from(2015) to(2020)
```

### 示例 5: 导出引文

```stata
findsj matching, export markdown
```

### 示例 6: 标题搜索

```stata
findsj, title(treatment effects)
```

### 示例 7: 完整信息含 DOI

```stata
findsj propensity score, detail getdoi
```

### 示例 8: 组合条件搜索

```stata
findsj causal inference, author(Angrist) from(2000) detail
```

## 功能详解

### 1. 搜索功能

- **灵活搜索**: 组合关键词和选项实现精确搜索
- **智能匹配**: 不区分大小写的部分匹配
- **多字段搜索**: 在标题、作者、摘要和关键词中搜索
- **日期筛选**: 按发表年份范围限定结果

### 2. 官方引文下载

结果表格为每篇文章提供可点击按钮:

- **BibTeX**: 直接从 Stata Journal 下载 BibTeX 引文
- **RIS**: 下载 RIS 格式引文(供参考文献管理软件使用)

这些链接连接到 Stata Journal 官方引文服务:
`https://www.stata-journal.com/ris.php?doi={文章doi}`

### 3. 批量引文导出

一次性导出多个引文到剪贴板:

- **纯文本**: 简单的引文列表
- **Markdown**: 适用于 Markdown 文档的格式
- **LaTeX**: 可直接用于 LaTeX 参考文献

导出后,使用 `Ctrl+V` (Windows) 或 `Cmd+V` (Mac) 直接粘贴到文档中。

### 4. 丰富的信息展示

每个搜索结果包含:

- 文章标题和作者
- 发表信息(期刊、年份、卷期、页码)
- DOI 和相关链接
- 摘要和关键词
- 相关 Stata 程序包信息

### 5. 可点击链接

直接访问:

- Stata Journal 网站上的文章 PDF
- 包含完整详情的文章页面
- Google Scholar 上的文章搜索
- 相关 Stata 程序包下载

## 数据来源

`findsj` 使用 Stata Journal 官方文章数据库,包括:

- 所有 **Stata Journal (SJ)** 文章
- 所有 **Stata Technical Bulletin (STB)** 文章
- 定期更新最新发表的文章
- 完整的引文信息和 DOI

## 系统要求

- Stata 14.0 或更高版本
- 活动的互联网连接(用于 DOI 获取和引文下载)

## 版本历史

### 版本 1.0.3 (2025-10-22)
- 将复制按钮替换为官方 BibTeX/RIS 下载链接
- 移除 `findsj_copy` 子命令
- 添加 `getdoi` 选项用于实时 DOI 获取
- 移除剪贴板依赖以提升性能
- 更新文档和示例

### 版本 1.0.2 (2025-10-20)
- 添加三按钮引文复制功能
- 改进错误处理

### 版本 1.0.1 (2025-10-18)
- 初始版本,包含基本搜索和导出功能

## 故障排除

### 引文无法下载?

- 确保有活动的互联网连接
- 检查文章是否存在 DOI
- 尝试重新点击链接或使用不同浏览器

### DOI 获取速度慢?

- 仅在需要时使用 `getdoi` 选项
- 数据库中的默认 DOI 通常已足够

### 导出不工作?

- 确保至少有一个搜索结果
- 检查剪贴板访问权限是否可用
- 尝试不同的导出格式

## 与 findit 的比较

| 功能 | findsj | findit |
|------|--------|--------|
| 数据源 | 仅 Stata Journal | 所有 Stata 资源 |
| 引文 | 是 (BibTeX/RIS) | 否 |
| 批量导出 | 是 | 否 |
| 作者搜索 | 是 | 有限 |
| 年份筛选 | 是 | 否 |
| DOI 链接 | 是 | 否 |
| 详细信息 | 是 | 基本 |

## 未来计划

- [ ] 添加摘要搜索功能
- [ ] 支持其他引文格式(如 APA、Chicago)
- [ ] 与参考文献管理软件集成
- [ ] 支持本地数据库的离线模式
- [ ] 基于关键词的文章推荐

## 贡献

欢迎贡献!请随时在 GitHub 上提交问题或拉取请求。

## 支持

如有问题、错误报告或功能请求:

- **邮箱**: arlionn@163.com
- **GitHub Issues**: https://github.com/BlueDayDreeaming/findsj/issues
- **Gitee Issues**: https://gitee.com/ChuChengWan/findsj/issues

## 引用

如果您在研究中使用 `findsj`,请引用:

```
连玉君 (2025). findsj: 搜索并引用 Stata Journal 文章.
Stata 软件包. 版本 1.0.3.
可从以下网址获取: https://github.com/BlueDayDreeaming/findsj
```

## 许可证

MIT 许可证 - 详见 [LICENSE](LICENSE) 文件

版权所有 (c) 2025 连玉君

## 作者

**连玉君**  
中山大学,广州,中国  
邮箱: arlionn@163.com  
GitHub: [BlueDayDreeaming](https://github.com/BlueDayDreeaming)

---

*用 ❤️ 为 Stata 社区打造*
