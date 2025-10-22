# findsj - Stata Journal 文献搜索与引用工具# findsj 使用说明与问题解决方案



搜索并引用 Stata Journal 文献## 问题分析



[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)根据您提供的截图，主要存在以下问题：

[![Stata](https://img.shields.io/badge/Stata-14%2B-blue)](https://www.stata.com/)

[![Version](https://img.shields.io/badge/version-1.0.3-brightgreen)](https://github.com/BlueDayDreeaming/findsj)### 1. 数据文件缺失导致的显示问题



[English](README.md) | [中文文档](README_CN.md)**现象：**

- 年份显示为 `(.)`

## 简介- 期刊信息显示为 `Stata Journal ()` （缺少卷号、期号和页码）

- 引文格式不完整

`findsj` 是一个 Stata 命令，用于搜索 **Stata Journal (SJ)** 和 **Stata Technical Bulletin (STB)** 的文献。它可以按关键词、作者姓名或文章标题搜索，显示详细的文献信息，提供官方 BibTeX/RIS 引文下载链接,并支持批量导出多种格式的引文。

**原因：**

## 核心功能程序提示 "Note: Data file not available"，这表明缺少 `sjget_data_sj.dta` 数据文件。没有这个文件，程序只能显示从网页直接抓取的基本信息（文章ID、标题、作者），而无法显示详细的期刊信息（卷号、期号、页码、DOI等）。



- 🔍 **智能搜索**: 支持关键词、作者姓名或文章标题搜索**解决方案：**

- 📚 **官方引文**: 直接链接到 Stata Journal 的 BibTeX 和 RIS 下载

- 📋 **批量导出**: 将多篇文献引文批量导出到剪贴板(纯文本/Markdown/LaTeX格式)#### 方法1：自动下载数据文件（推荐）

- 🔗 **丰富链接**: 提供文章页面、PDF下载、Google Scholar、相关软件包等链接```stata

- 🎯 **DOI支持**: 可选的 DOI 实时获取功能findsj_download_data

- ⚡ **快速简便**: 语法简单,默认设置智能```



## 安装方法这个命令会从 GitHub 自动下载数据文件到正确的位置。



### 方法1: 从 SSC 安装(待上架)#### 方法2：手动安装数据文件

```stata1. 从 GitHub 下载 `sjget_data_sj.dta` 文件：

ssc install findsj, replace   https://github.com/BlueDayDreeaming/findsj

```

2. 将文件放置到 Stata 的 ado-path 目录：

### 方法2: 从 GitHub 安装   - **Windows**: `C:\ado\plus\s\sjget_data_sj.dta`

```stata   - **Mac/Linux**: `~/ado/plus/s/sjget_data_sj.dta`

net install findsj, from(https://raw.githubusercontent.com/BlueDayDreeaming/findsj/main/)

```3. 或者查看您的 Stata ado-path：

   ```stata

### 方法3: 手动安装   adopath

1. 下载所有文件到本地目录   ```

2. 在 Stata 中运行:   将数据文件放到任何一个 PLUS 目录下的 `s` 文件夹中。

```stata

net install findsj, from("本地目录路径")### 2. 引文格式问题

```

**现象：**

## 快速开始从命令窗口复制的引文格式不规范，链接和页码信息显示不正确。



### 基本搜索**解决方案：**

```stata使用导出格式选项，程序会自动格式化引文并复制到剪贴板：

findsj panel data

``````stata

* 导出为 Markdown 格式

此命令显示前5篇匹配"panel data"的文章,包括:findsj "dynamic panel", markdown n(5)

- 文章标题、作者和期刊信息

- 文章页面和 PDF 的可点击链接* 导出为 LaTeX 格式

- **BibTeX 和 RIS 下载链接** (📚 Citation: BibTeX | RIS)findsj "dynamic panel", latex n(5)

- 相关 Stata 软件包链接

- Google Scholar 搜索链接* 导出为纯文本格式

findsj "dynamic panel", plain n(5)

### 按作者搜索```

```stata

findsj Baum, author### 3. 命令窗口显示优化

```

**建议：**

### 仅在标题中搜索使用 Jupyter Notebook 展示结果，而不是传统的 .log 文件。

```stata

findsj panel data, title## 使用 Jupyter Notebook 展示 findsj 结果

```

### 优势

### 显示更多结果1. **更好的格式化**：支持 Markdown、HTML 格式

```stata2. **交互性**：可以逐步运行和查看结果

findsj panel data, n(10)3. **易于分享**：可以导出为 HTML 文件，在浏览器中查看

```4. **可视化**：支持图表和富文本



### 导出引文到剪贴板### 步骤

```stata

* 以纯文本格式导出前5条结果#### 1. 安装 nbstata（推荐）

findsj panel data, n(5) plain```bash

pip install nbstata

* 以 Markdown 格式导出前5条结果```

findsj panel data, n(5) markdown

**nbstata** 是一个 Python 包，允许在 Jupyter Notebook 中运行 Stata 代码。它比 stata_kernel 更简单易用。

* 以 LaTeX 格式导出前5条结果

findsj panel data, n(5) latex详细说明参见：https://hugetim.github.io/nbstata/

```

#### 2. 使用提供的 Notebook 示例

运行这些命令后,引文会自动复制到剪贴板,您可以直接粘贴到文档中!项目中已经包含了一个完整的示例文件：`findsj_examples.ipynb`



## 语法打开方式：

```bash

```statajupyter notebook findsj_examples.ipynb

findsj 关键词 [, 选项]```

```

在第一个代码单元格中运行：

### 选项说明```python

import nbstata

| 选项 | 说明 |```

|------|------|

| **搜索范围** | |然后在每个 Stata 代码单元格开头使用 `%%stata` magic 命令：

| `author` | 按作者姓名搜索 |```stata

| `title` | 仅在文章标题中搜索 |%%stata

| `keyword` | 在全文中按关键词搜索(默认) |findsj dynamic panel, n(3)

| **导出格式** | |```

| `plain` | 以纯文本格式导出引文到剪贴板 |

| `markdown` | 以 Markdown 格式导出引文到剪贴板 |#### 3. 导出为 HTML

| `latex` (或 `tex`) | 以 LaTeX 格式导出引文到剪贴板 |```bash

| **显示选项** | |jupyter nbconvert --to html findsj_examples.ipynb

| `n(#)` | 显示/导出的结果数量(默认: 5) |```

| `allresults` | 显示并导出所有搜索结果 |

| `getdoi` | 实时获取 DOI 信息(较慢) |生成的 HTML 文件可以在任何浏览器中打开，效果比 .log 文件好得多。



**注意**: 使用导出选项(`plain`、`markdown` 或 `latex`)时,会自动获取 DOI 信息。## 测试示例



## 理解输出结果### 基础搜索

```stata

### 输出示例* 搜索包含 "dynamic panel" 的文章

findsj dynamic panel, n(5)

```

[1] N. J. Cox. (2007).* 查看返回值

    Speaking Stata: Identifying spellsreturn list

    _Stata Journal_ 7(2)```

    Article page | [PDF] | [Google]

    ### 按作者搜索

    📚 Citation: BibTeX | RIS```stata

    * 搜索 Roodman 的文章

    Search for package | Browse SJ softwarefindsj Roodman, author n(3)

``````



### 引文下载链接### 导出引文

```stata

每条结果都包含 **📚 Citation: BibTeX | RIS** 链接:* 导出为 Markdown 格式（自动复制到剪贴板）

- **BibTeX**: 下载 BibTeX 格式引文,用于 LaTeX 文档findsj panel data, markdown n(5)

- **RIS**: 下载 RIS 格式引文,用于 Zotero、Mendeley、EndNote 等文献管理软件

* 导出为 LaTeX 格式

这些链接直接指向 Stata Journal 官方引文下载服务。点击链接即可下载引文文件。findsj regression, latex n(3)

```

### 期刊信息

### 查看所有结果

``````stata

_Stata Journal_ 7(2)* 默认只显示前5条，使用 allresults 查看全部

                ↑ ↑findsj instrumental variable, allresults

                │ └── 期号(1-4,按季度)```

                └──── 卷号

```## 返回值



**卷号和期号:**`findsj` 执行后会返回以下值：

- 卷号 7 ≈ 2007年出版

- 期号 2 = 6月(第二季度)```stata

  - 期号 1: 3月findsj fixed effects, n(3)

  - 期号 2: 6月return list

  - 期号 3: 9月```

  - 期号 4: 12月

返回值包括：

### DOI 信息- `r(keywords)`: 搜索关键词

- `r(scope)`: 搜索范围（keyword/author/title）

使用 `getdoi` 选项或导出格式时,会显示 DOI:- `r(n_results)`: 结果数量

- `r(title_1)`: 第一篇文章标题

```- `r(author_1)`: 第一篇文章作者

[1] N. J. Cox. (2007).- `r(art_id_1)`: 第一篇文章ID

    Speaking Stata: Identifying spells- `r(url_1)`: 第一篇文章链接

    _Stata Journal_ 7(2)

    Article page | [PDF] | [Google]## 常见问题解答

    DOI: 10.1177/1536867X0700700209    ← 添加了 DOI

    ### Q1: 为什么显示 "Data file not available"？

    📚 Citation: BibTeX | RIS**A**: 需要安装数据文件。运行 `findsj_download_data` 或手动下载并放置数据文件。

```

### Q2: 如何导出完整的引文信息？

## 导出格式示例**A**: 使用导出选项：`findsj keywords, markdown` 或 `latex` 或 `plain`



### 纯文本格式### Q3: 如何查看更多搜索结果？

```stata**A**: 使用 `n(#)` 指定数量，或使用 `allresults` 查看全部

findsj panel data, n(3) plain

```### Q4: 搜索包含连字符的关键词出错？

输出(复制到剪贴板):**A**: 将关键词用引号括起来：`findsj "difference-in-differences", n(5)`

```

[1] N. J. Cox. (2007). Speaking Stata: Identifying spells. Stata Journal 7(2). DOI: 10.1177/1536867X0700700209### Q5: 如何在论文中引用 findsj？

**A**: 

[2] P. W. Jeanty. (2010). Using the world development indicators database for statistical analysis in Stata. Stata Journal 10(1). DOI: 10.1177/1536867X1001000105```

Lian, Yujun, and Chucheng Wan (2025). findsj: Search and cite articles 

[3] P. W. Jeanty. (2011). Managing the U.S. Census 2000 and World Development Indicators databases for statistical analysis in Stata. Stata Journal 11(4). DOI: 10.1177/1536867X1201100406from Stata Journal. Stata software package. 

```Available at: https://github.com/BlueDayDreeaming/findsj

```

### Markdown 格式

```stata## 文件清单

findsj panel data, n(3) markdown

```项目包含以下文件：

输出(复制到剪贴板):

```markdown- `findsj.ado` - 主程序文件

1. N. J. Cox. (2007). [Speaking Stata: Identifying spells](https://www.stata-journal.com/article.html?article=st0123). *Stata Journal* 7(2). DOI: [10.1177/1536867X0700700209](https://doi.org/10.1177/1536867X0700700209)- `findsj.sthlp` - 帮助文档

- `findsj_examples.do` - 传统 .do 文件示例

2. P. W. Jeanty. (2010). [Using the world development indicators database for statistical analysis in Stata](https://www.stata-journal.com/article.html?article=st0178). *Stata Journal* 10(1). DOI: [10.1177/1536867X1001000105](https://doi.org/10.1177/1536867X1001000105)- `findsj_examples.ipynb` - **Jupyter Notebook 示例（推荐）**

- `findsj_examples.log` - 传统日志文件

3. P. W. Jeanty. (2011). [Managing the U.S. Census 2000 and World Development Indicators databases for statistical analysis in Stata](https://www.stata-journal.com/article.html?article=st0247). *Stata Journal* 11(4). DOI: [10.1177/1536867X1201100406](https://doi.org/10.1177/1536867X1201100406)- `README.md` - 英文说明文档

```- `README_CN.md` - 本文档（中文说明）

- `LICENSE` - MIT 许可证

### LaTeX 格式- `findsj.pkg` - 包定义文件

```stata- `stata.toc` - 目录文件

findsj panel data, n(3) latex

```## 联系方式

输出(复制到剪贴板):

```latex如有问题或建议，请联系：

\begin{enumerate}

\item N. J. Cox. (2007). \href{https://www.stata-journal.com/article.html?article=st0123}{Speaking Stata: Identifying spells}. \textit{Stata Journal} 7(2). DOI: \href{https://doi.org/10.1177/1536867X0700700209}{10.1177/1536867X0700700209}- **Yujun Lian**: arlionn@163.com

- **Chucheng Wan**: chucheng.wan@outlook.com

\item P. W. Jeanty. (2010). \href{https://www.stata-journal.com/article.html?article=st0178}{Using the world development indicators database for statistical analysis in Stata}. \textit{Stata Journal} 10(1). DOI: \href{https://doi.org/10.1177/1536867X1001000105}{10.1177/1536867X1001000105}- **GitHub Issues**: https://github.com/BlueDayDreeaming/findsj/issues



\item P. W. Jeanty. (2011). \href{https://www.stata-journal.com/article.html?article=st0247}{Managing the U.S. Census 2000 and World Development Indicators databases for statistical analysis in Stata}. \textit{Stata Journal} 11(4). DOI: \href{https://doi.org/10.1177/1536867X1201100406}{10.1177/1536867X1201100406}## 更新日志

\end{enumerate}

```### 2025-10-20

- 添加数据文件下载功能 `findsj_download_data`

## 使用示例- 创建 Jupyter Notebook 示例

- 更新文档，添加中文说明

详见 `findsj_examples.do` 文件,包含所有功能的完整示例。

### 2025-10-18

### 示例1: 基本关键词搜索- 简化代码（从1141行减少到744行）

```stata- 添加跨平台剪贴板支持

findsj panel data- 改进错误提示信息

```

显示前5篇匹配"panel data"的文章### 2025-10-15

- 首次发布

### 示例2: 限制结果数量
```stata
findsj panel data, n(10)
```
显示前10条结果

### 示例3: 按作者搜索
```stata
findsj Baum, author
findsj "David Roodman", author n(3)
```

### 示例4: 仅在标题中搜索
```stata
findsj panel data, title
```

### 示例5: 获取 DOI 信息
```stata
findsj panel data, n(5) getdoi
```
从 Stata Journal 网站获取 DOI(较慢但在显示中包含 DOI)

### 示例6: 导出为纯文本格式
```stata
findsj panel data, n(5) plain
```
将5条引文以纯文本格式复制到剪贴板

### 示例7: 导出为 Markdown 格式
```stata
findsj panel data, n(5) markdown
```
将5条引文以 Markdown 格式复制到剪贴板

### 示例8: 导出为 LaTeX 格式
```stata
findsj panel data, n(5) latex
```
将5条引文以 LaTeX 格式复制到剪贴板

### 示例9: 导出所有结果
```stata
findsj boottest, author allresults markdown
```
将作者"boottest"的所有结果以 Markdown 格式导出

## 返回值

运行 `findsj` 后,以下值存储在 `r()` 中:

**标量:**
- `r(n_results)` - 找到的文章数量

**宏:**
- `r(keywords)` - 搜索关键词
- `r(scope)` - 搜索范围(author/title/keyword)
- `r(url)` - 搜索 URL
- `r(format)` - 导出格式(plain/markdown/latex),如果使用

**对于每个结果 i (i=1,2,3,...):**
- `r(art_id_i)` - 文章 ID
- `r(title_i)` - 文章标题
- `r(author_i)` - 作者姓名
- `r(issue_i)` - 期刊卷号和期号
- `r(doi_i)` - DOI(使用 getdoi 或指定导出格式时)
- `r(url_i)` - 文章 URL

**示例:**
```stata
findsj panel data, n(3)
return list

display r(n_results)      // 显示: 69
display r(keywords)       // 显示: panel data
display r(title_1)        // 显示第一篇文章标题
display r(author_1)       // 显示第一篇文章作者
```

## 系统要求

- **Stata 版本**: 14.0 或更高
- **网络连接**: 搜索和获取 DOI 需要联网
- **剪贴板支持**: Windows 和 macOS(Linux 用户仍可查看结果,但剪贴板导出可能无法工作)

## 文件清单

- `findsj.ado` - 主程序文件
- `findsj.sthlp` - 帮助文档
- `findsj.pkg` - 包定义文件
- `findsj_examples.do` - 完整示例脚本
- `stata.toc` - 目录文件
- `README.md` - 英文文档
- `README_CN.md` - 本文件(中文文档)
- `README.txt` - 纯文本说明
- `LICENSE` - MIT 许可证

## 版本 1.0.3 新特性 (2025-10-22)

### 主要变更
- ✅ **用官方引文下载替换复制按钮**: 每条结果现在显示可点击的 **BibTeX** 和 **RIS** 下载链接(来自 Stata Journal)
- ✅ **移除 `findsj_copy` 子命令**: 不再需要单独复制引文
- ✅ **精简代码**: 文件大小从 30,907 字节减少到 27,130 字节(删除了160多行代码)
- ✅ **保留批量导出**: `plain`、`markdown` 和 `latex` 导出选项仍然完全可用

### 移除的功能
- ❌ 每条结果的单独复制按钮(📋 Copy: plain | markdown | latex)
- ❌ `findsj_copy` 子命令
- ❌ 单个引文的全局宏保存

### 新增功能
- ✅ 官方 BibTeX/RIS 下载链接: **📚 Citation: BibTeX | RIS**
- ✅ 使用导出格式时自动获取 DOI
- ✅ 改进的文档和版本历史

### 迁移指南
**如果您之前使用:**
```stata
* 旧版(不再有效):
findsj panel data
findsj_copy 1 markdown
```

**请改为:**
```stata
* 新版(批量导出):
findsj panel data, n(5) markdown
* 或点击输出中的 BibTeX/RIS 链接
```

## 技术支持

如有问题、错误报告或功能建议:
- **邮箱**: arlionn@163.com
- **GitHub Issues**: [https://github.com/BlueDayDreeaming/findsj/issues](https://github.com/BlueDayDreeaming/findsj/issues)

## 引用本程序

如果您在研究中使用了 `findsj`,请引用:

```
连玉君 (2025). findsj: Stata Journal 文献搜索与引用工具.
Stata 软件包. 版本 1.0.3.
可从以下网址获取: https://github.com/BlueDayDreeaming/findsj
```

英文引用:
```
Lian, Yujun (2025). findsj: Search and cite articles from Stata Journal.
Stata software package. Version 1.0.3.
Available at: https://github.com/BlueDayDreeaming/findsj
```

## 许可证

MIT 许可证 - 详见 [LICENSE](LICENSE) 文件

Copyright (c) 2025 Yujun Lian (连玉君)

## 作者

**连玉君**  
中山大学,中国广州  
邮箱: arlionn@163.com  
GitHub: [BlueDayDreeaming](https://github.com/BlueDayDreeaming)

## 常见问题

### Q1: 如何下载引文文件?
**A**: 每条搜索结果都包含 **📚 Citation: BibTeX | RIS** 链接。点击这些链接即可从 Stata Journal 官方网站下载引文文件。下载的文件可以导入到 Zotero、Mendeley、EndNote 等文献管理软件。

### Q2: 批量导出和单个下载有什么区别?
**A**: 
- **批量导出** (`plain`/`markdown`/`latex` 选项): 将多篇文献的引文一次性复制到剪贴板,方便粘贴到文档中
- **单个下载** (点击 BibTeX/RIS 链接): 下载单篇文献的引文文件,可导入文献管理软件

两种方式可以根据需要选择使用。

### Q3: 为什么使用导出选项时速度较慢?
**A**: 使用 `plain`、`markdown` 或 `latex` 选项时,程序会自动从 Stata Journal 网站获取每篇文献的 DOI 信息,这需要额外的网络请求时间。如果只是浏览搜索结果而不需要导出,可以不使用这些选项。

### Q4: 如何搜索包含连字符的关键词?
**A**: 将关键词用引号括起来:
```stata
findsj "difference-in-differences", n(5)
findsj "synthetic control", title
```

### Q5: 可以搜索 STB 的文章吗?
**A**: 可以! `findsj` 支持搜索 Stata Journal 和 Stata Technical Bulletin (STB) 的所有文章。

### Q6: 如何查看所有搜索结果?
**A**: 使用 `allresults` 选项:
```stata
findsj panel data, allresults
```
注意:如果结果很多,显示可能需要一些时间。

### Q7: 导出的引文可以直接用于论文吗?
**A**: 可以! 导出的引文格式规范,可以直接用于:
- **plain**: 纯文本文档、邮件
- **markdown**: Markdown 文档、GitHub README、Obsidian 笔记
- **latex**: LaTeX 文档、学术论文

---

*用 ❤️ 为 Stata 社区制作*
