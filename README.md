# findsj# findsj



Search and cite articles from Stata JournalSearch and cite articles from Stata Journal



[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

[![Stata](https://img.shields.io/badge/Stata-14%2B-blue)](https://www.stata.com/)[![Stata](https://img.shields.io/badge/Stata-14%2B-blue)](https://www.stata.com/)

[![Version](https://img.shields.io/badge/version-1.0.3-brightgreen)](https://github.com/BlueDayDreeaming/findsj)

## Overview

[English](README.md) | [中文文档](README_CN.md)

`findsj` is a Stata command that searches for articles from the **Stata Journal (SJ)** and **Stata Technical Bulletin (STB)** by keywords, author names, or article titles. It displays article information including DOI, PDF links, and related Stata packages. Citations can be exported in various formats (Markdown, LaTeX, or plain text).

## Overview

## Key Features

`findsj` is a Stata command that searches articles from the **Stata Journal (SJ)** and **Stata Technical Bulletin (STB)** by keywords, author names, or article titles. It displays comprehensive article information with clickable links to official citation downloads (BibTeX/RIS) and supports batch exporting citations in multiple formats.

- 🔍 Search by keyword, author name, or article title

## Key Features- 📄 Display article information with clickable links

- 📋 Export citations in Markdown, LaTeX, or plain text format

- 🔍 **Smart Search**: Search by keyword, author name, or article title- 📎 Automatic clipboard support (Windows and Mac)

- 📚 **Official Citations**: Direct links to BibTeX and RIS downloads from Stata Journal- 🔗 Access to DOI, PDF links, and related packages

- 📋 **Batch Export**: Export multiple citations to clipboard in plain text, Markdown, or LaTeX format- ⚡ Easy-to-use interface

- 🔗 **Rich Links**: Access to article pages, PDF downloads, Google Scholar, and related packages

- 🎯 **DOI Support**: Optional DOI retrieval from official sources## Installation

- ⚡ **Fast & Easy**: Simple syntax with smart defaults

### Method 1: From SSC (when available)

## Installation```stata

ssc install findsj, replace

### Method 1: From SSC (when available)```

```stata

ssc install findsj, replace### Method 2: From GitHub

``````stata

net install findsj, from(https://raw.githubusercontent.com/BlueDayDreeaming/findsj/main/)

### Method 2: From GitHub```

```stata

net install findsj, from(https://raw.githubusercontent.com/BlueDayDreeaming/findsj/main/)### Method 3: Manual installation

```1. Download all files to a local directory

2. Run in Stata:

### Method 3: Manual Installation```stata

1. Download all files to a local directorynet install findsj, from("path/to/directory")

2. Run in Stata:```

```stata

net install findsj, from("path/to/directory")### Installing the Data File (Optional)

```

**Note**: The data file is **optional**. `findsj` now extracts all essential information (author, year, title, volume, issue) directly from the web.

## Quick Start

The data file provides **supplementary information**:

### Basic Search- DOI (Digital Object Identifier)

```stata- Page numbers

findsj panel data

```**If you want DOI and page numbers**, you have two options:



This displays the first 5 articles matching "panel data" with:**Option 1: Generate the data file yourself**

- Article title, authors, and journal information```stata

- Clickable links to article page and PDFfindsj_data_id, filename(sjget_data_sj)

- **BibTeX and RIS download links** (📚 Citation: BibTeX | RIS)```

- Links to related Stata packages

- Google Scholar search link**Option 2: Use `findsj_doi` for specific articles**

```stata

### Search by Author* Get DOI and page numbers for a specific article

```statafindsj_doi st0001

findsj Baum, authorreturn list

``````



### Search in Title Only**What you get without the data file:**

```stata```

findsj panel data, title[1] Author Name. (2025).

```    Article Title...

    _Stata Journal_ 25(1)  ← Full citation info!

### Show More Results```

```stata

findsj panel data, n(10)**What you get with the data file:**

``````

[1] Author Name. (2025).

### Export Citations to Clipboard    Article Title...

```stata    _Stata Journal_ 25(1): 1-30  ← Adds page numbers

* Export first 5 results in plain text format    DOI: 10.1177/...             ← Adds DOI

findsj panel data, n(5) plain```



* Export first 5 results in Markdown format## ✅ 使用 Jupyter Notebook（推荐！）

findsj panel data, n(5) markdown

`findsj` 现在支持在 Jupyter Notebook 中使用！使用 Stata 官方的 **pystata** 接口。

* Export first 5 results in LaTeX format

findsj panel data, n(5) latex### 快速开始

```

#### 方法 1: 使用测试脚本（最简单）

After running these commands, citations are automatically copied to your clipboard. You can paste them directly into your documents!

```bash

## Syntaxpython quick_start.py

```

```stata

findsj keywords [, options]如果显示 "✓✓✓ 所有测试通过！配置成功！✓✓✓"，说明一切正常！

```

#### 方法 2: 打开示例 Notebook

### Options

```bash

| Option | Description |jupyter notebook findsj_pystata_examples.ipynb

|--------|-------------|```

| **Search Scope** | |

| `author` | Search by author name |运行第一个单元格初始化，然后尝试其他示例！

| `title` | Search by article title only |

| `keyword` | Search by keywords in full text (default) |### 配置步骤（在 Notebook 第一个单元格）

| **Export Format** | |

| `plain` | Export citations in plain text format to clipboard |```python

| `markdown` | Export citations in Markdown format to clipboard |import sys, os

| `latex` (or `tex`) | Export citations in LaTeX format to clipboard |

| **Display Options** | |# 添加 pystata 路径（修改为您的 Stata 安装路径）

| `n(#)` | Number of results to display/export (default: 5) |sys.path.append('D:/STATA18/utilities')  # Windows

| `allresults` | Display and export all search results |# sys.path.append('/Applications/Stata/utilities')  # macOS

| `getdoi` | Retrieve DOI information in real-time (slower) |

# 添加 Stata 到 PATH

**Note**: When using export options (`plain`, `markdown`, or `latex`), DOI information is automatically retrieved.os.environ['PATH'] = 'D:/STATA18;' + os.environ.get('PATH', '')  # Windows

# os.environ['PATH'] = '/Applications/Stata;' + os.environ.get('PATH', '')  # macOS

## Understanding the Output

# 初始化 Stata

### Example Outputfrom pystata import config

config.init('mp')  # 'mp' for MP, 'se' for SE, 'be' for Basic

```

[1] N. J. Cox. (2007).# 导入 stata 并加载 findsj

    Speaking Stata: Identifying spellsfrom pystata import stata

    _Stata Journal_ 7(2)stata.run('run "path/to/findsj.ado"')

    Article page | [PDF] | [Google]```

    

    📚 Citation: BibTeX | RIS### 使用示例

    

    Search for package | Browse SJ software```python

```# 基础搜索

stata.run('''

### Citation Download Linksfindsj dynamic panel, n(5)

''')

Each result includes **📚 Citation: BibTeX | RIS** links:```

- **BibTeX**: Download citation in BibTeX format for LaTeX documents

- **RIS**: Download citation in RIS format for Zotero, Mendeley, EndNote, etc.```python

# 按作者搜索

These links direct to the official Stata Journal citation service. Click the links to download citation files.stata.run('''

findsj Roodman, author n(2)

### Journal Information''')

```

```

_Stata Journal_ 7(2)```python

                ↑ ↑# 导出引文

                │ └── Issue Number (1-4, quarterly)stata.run('''

                └──── Volume Numberfindsj regression, markdown n(3)

```''')

```

**Volume and Issue:**

- Volume 7 ≈ Published in 2007### 📖 详细文档

- Issue 2 = June (Q2)

  - Issue 1: March- **SOLUTION.md** - 完整配置说明和常见问题解答

  - Issue 2: June- **findsj_pystata_examples.ipynb** - 完整工作示例

  - Issue 3: September- **quick_start.py** - 一键测试配置脚本

  - Issue 4: December



### DOI Information

#### Step 4: Export to HTML (optional)

When using `getdoi` option or export formats, DOI is displayed:

```bash

```jupyter nbconvert --to html findsj_examples.ipynb

[1] N. J. Cox. (2007).```

    Speaking Stata: Identifying spells

    _Stata Journal_ 7(2)The generated HTML provides much better presentation than traditional `.log` files!

    Article page | [PDF] | [Google]

    DOI: 10.1177/1536867X0700700209    ← DOI added**See also:** [NBSTATA_GUIDE.md](NBSTATA_GUIDE.md) for detailed nbstata usage instructions.

    

    📚 Citation: BibTeX | RIS## Quick Start

```

### Basic search

## Export Formats```stata

findsj panel data

### Plain Text Format```

```stata

findsj panel data, n(3) plain### Search by author

``````stata

Output (copied to clipboard):findsj Roodman, author

``````

[1] N. J. Cox. (2007). Speaking Stata: Identifying spells. Stata Journal 7(2). DOI: 10.1177/1536867X0700700209

### Search by title

[2] P. W. Jeanty. (2010). Using the world development indicators database for statistical analysis in Stata. Stata Journal 10(1). DOI: 10.1177/1536867X1001000105```stata

findsj synth, title

[3] P. W. Jeanty. (2011). Managing the U.S. Census 2000 and World Development Indicators databases for statistical analysis in Stata. Stata Journal 11(4). DOI: 10.1177/1536867X1201100406```

```

### Export in Markdown

### Markdown Format```stata

```statafindsj regression, markdown

findsj panel data, n(3) markdown```

```

Output (copied to clipboard):### Export in LaTeX

```markdown```stata

1. N. J. Cox. (2007). [Speaking Stata: Identifying spells](https://www.stata-journal.com/article.html?article=st0123). *Stata Journal* 7(2). DOI: [10.1177/1536867X0700700209](https://doi.org/10.1177/1536867X0700700209)findsj instrumental variables, latex

```

2. P. W. Jeanty. (2010). [Using the world development indicators database for statistical analysis in Stata](https://www.stata-journal.com/article.html?article=st0178). *Stata Journal* 10(1). DOI: [10.1177/1536867X1001000105](https://doi.org/10.1177/1536867X1001000105)

## Syntax

3. P. W. Jeanty. (2011). [Managing the U.S. Census 2000 and World Development Indicators databases for statistical analysis in Stata](https://www.stata-journal.com/article.html?article=st0247). *Stata Journal* 11(4). DOI: [10.1177/1536867X1201100406](https://doi.org/10.1177/1536867X1201100406)

``````stata

findsj keywords [, options]

### LaTeX Format```

```stata

findsj panel data, n(3) latex### Options

```

Output (copied to clipboard):**Search scope:**

```latex- `author` - Search by author name

\begin{enumerate}- `title` - Search by article title

\item N. J. Cox. (2007). \href{https://www.stata-journal.com/article.html?article=st0123}{Speaking Stata: Identifying spells}. \textit{Stata Journal} 7(2). DOI: \href{https://doi.org/10.1177/1536867X0700700209}{10.1177/1536867X0700700209}- `keyword` - Search by keywords (default)



\item P. W. Jeanty. (2010). \href{https://www.stata-journal.com/article.html?article=st0178}{Using the world development indicators database for statistical analysis in Stata}. \textit{Stata Journal} 10(1). DOI: \href{https://doi.org/10.1177/1536867X1001000105}{10.1177/1536867X1001000105}**Export format:**

- `markdown` - Export in Markdown format

\item P. W. Jeanty. (2011). \href{https://www.stata-journal.com/article.html?article=st0247}{Managing the U.S. Census 2000 and World Development Indicators databases for statistical analysis in Stata}. \textit{Stata Journal} 11(4). DOI: \href{https://doi.org/10.1177/1536867X1201100406}{10.1177/1536867X1201100406}- `latex` (or `tex`) - Export in LaTeX format

\end{enumerate}- `plain` - Export in plain text format

```

**Output control:**

## Examples- `noclip` - Do not copy results to clipboard

- `nobrowser` - Do not display browser links

See `findsj_examples.do` for comprehensive examples covering all features.- `nodoi` - Do not display DOI information

- `nopdf` - Do not display PDF links

### Example 1: Basic Keyword Search- `nopkg` - Do not display package information

```stata

findsj panel data**Display:**

```- `n(#)` - Number of results to display (default: 5)

Shows first 5 articles matching "panel data"- `allresults` - Display all search results



### Example 2: Limit Results**Other:**

```stata- `clear` - Clear existing search results

findsj panel data, n(10)- `debug` - Enable debug mode

```

Shows first 10 results## Examples



### Example 3: Search by AuthorSee `findsj_examples.do` for comprehensive examples, or run:

```stata```stata

findsj Baum, authorhelp findsj

findsj "David Roodman", author n(3)```

```

### Example 1: Search for panel data articles

### Example 4: Search in Title Only```stata

```statafindsj panel

findsj panel data, title```

```

### Example 2: Find articles by David Roodman

### Example 5: Get DOI Information```stata

```statafindsj Roodman, author

findsj panel data, n(5) getdoi```

```

Retrieves DOI from Stata Journal website (slower but includes DOI in display)### Example 3: Search for synthetic control articles

```stata

### Example 6: Export in Plain Textfindsj synth, title

```stata```

findsj panel data, n(5) plain

```### Example 4: Export citations in Markdown

Copies 5 citations in plain text to clipboard```stata

findsj treatment, markdown n(3)

### Example 7: Export in Markdown```

```stata

findsj panel data, n(5) markdown### Example 5: Export citations in LaTeX

``````stata

Copies 5 citations in Markdown format to clipboardfindsj regression, latex n(3)

```

### Example 8: Export in LaTeX

```stata### Example 6: Display 10 results

findsj panel data, n(5) latex```stata

```findsj instrumental, n(10)

Copies 5 citations in LaTeX format to clipboard```



### Example 9: Export All Results### Example 7: Display all results

```stata```stata

findsj boottest, author allresults markdownfindsj boottest, allresults

``````

Exports all results by author "boottest" in Markdown format

## Understanding the Output

## Stored Results

### Citation Format Explained

After running `findsj`, the following values are stored in `r()`:

```

**Scalars:**[1] P. Asnani, A. Chudik, and B. Strackman. (2025).

- `r(n_results)` - Number of articles found    xtpb: The pooled Bewley estimator of long-run relationships...

    _Stata Journal_ 25(1)

**Macros:**                    ↑  ↑

- `r(keywords)` - Search keywords                    │  └─── Issue Number (1-4, quarterly)

- `r(scope)` - Search scope (author/title/keyword)                    └────── Volume Number (corresponds to year)

- `r(url)` - Search URL```

- `r(format)` - Export format (plain/markdown/latex), if used

**Volume and Issue Numbers:**

**For each result i (i=1,2,3,...):**- **Volume 25** = Published in 2025 (Volume = Year - 2000 for recent issues)

- `r(art_id_i)` - Article ID- **Issue (1)** = First quarter of the year

- `r(title_i)` - Article title  - Issue 1: March

- `r(author_i)` - Author names  - Issue 2: June  

- `r(issue_i)` - Journal volume and issue  - Issue 3: September

- `r(doi_i)` - DOI (when getdoi is used or export format specified)  - Issue 4: December

- `r(url_i)` - Article URL

**Example:** `_Stata Journal_ 25(1)` means Volume 25, Issue 1, published in March 2025.

**Example:**

```stata### Data File Impact

findsj panel data, n(3)

return list**With data file installed:**

```

display r(n_results)      // Shows: 69_Stata Journal_ 25(1), pp. 1-30

display r(keywords)       // Shows: panel dataDOI: 10.1177/1536867X251234567

display r(title_1)        // Shows first article titlePDF: https://journals.sagepub.com/doi/pdf/...

display r(author_1)       // Shows first article authors```

```

**Without data file (web-scraped information):**

## System Requirements```

_Stata Journal_ 25(1)

- **Stata Version**: 14.0 or higherArticle page: https://www.stata-journal.com/article.html?article=st0768

- **Internet Connection**: Required for searching and retrieving DOI```

- **Clipboard Support**: Windows and macOS (Linux users can still view results, but clipboard export may not work)

Even without the data file, `findsj` extracts author, year, volume, and issue from the Stata Journal website.

## Files Included

## System Requirements

- `findsj.ado` - Main program file

- `findsj.sthlp` - Help documentation- Stata 14.0 or higher

- `findsj.pkg` - Package definition- Internet connection required for searching

- `findsj_examples.do` - Comprehensive example script- Clipboard support: Windows and Mac only

- `stata.toc` - Table of contents

- `README.md` - This file (English)## Files Included

- `README_CN.md` - Chinese documentation

- `README.txt` - Plain text readme- `findsj.ado` - Main program file

- `LICENSE` - MIT License- `findsj.sthlp` - Help file

- `findsj.pkg` - Package file

## What's New in Version 1.0.3 (2025-10-22)- `findsj_examples.do` - Example do-file

- `findsj_examples.ipynb` - **Jupyter Notebook examples (recommended!)**

### Major Changes- `findsj_examples.log` - Example log file

- ✅ **Replaced copy buttons with official citation downloads**: Each result now shows clickable **BibTeX** and **RIS** download links from Stata Journal- `README.md` - This file

- ✅ **Removed `findsj_copy` subcommand**: Individual citation copying is no longer needed- `README_CN.md` - Chinese documentation

- ✅ **Streamlined code**: Reduced file size from 30,907 to 27,130 bytes (160+ lines removed)- `NBSTATA_GUIDE.md` - Detailed nbstata usage guide

- ✅ **Retained batch export**: The `plain`, `markdown`, and `latex` export options remain fully functional- `CHANGELOG.md` - Version history and bug fixes



### What Was Removed## Stored Results

- ❌ Individual copy buttons (📋 Copy: plain | markdown | latex) per result

- ❌ `findsj_copy` subcommand`findsj` stores the following in `r()`:

- ❌ Global macro saving for individual citations

**Scalars:**

### What Was Added- `r(n_results)` - Number of articles found

- ✅ Official BibTeX/RIS download links: **📚 Citation: BibTeX | RIS**

- ✅ Automatic DOI retrieval when using export formats**Macros:**

- ✅ Improved documentation with version history- `r(keywords)` - Search keywords

- `r(scope)` - Search scope (author/title/keyword)

### Migration Guide- `r(url)` - Search URL

**If you were using:**- `r(art_id_1)` - Article ID of first result

```stata- `r(title_1)` - Title of first result

* OLD (no longer works):- `r(author_1)` - Author of first result

findsj panel data- `r(doi_1)` - DOI of first result

findsj_copy 1 markdown- `r(url_1)` - URL of first result

```

## Examples

**Switch to:**

```stata### Interactive Jupyter Notebook

* NEW (batch export):

findsj panel data, n(5) markdownFor a comprehensive demonstration of `findsj`, see the [Jupyter Notebook examples](findsj_examples.ipynb). The notebook includes:

* Or click the BibTeX/RIS links in the output

```- Basic keyword search

- Search by author name

## Support- Search by article title

- Exporting in different formats (Markdown, LaTeX)

For questions, bug reports, or feature requests:- Working with returned values

- **Email**: arlionn@163.com- Advanced options

- **GitHub Issues**: [https://github.com/BlueDayDreeaming/findsj/issues](https://github.com/BlueDayDreeaming/findsj/issues)

**To view the notebook:**

## Citation1. Install nbstata for Jupyter:

   ```bash

If you use `findsj` in your research, please cite:   pip install nbstata

   ```

```   See [nbstata documentation](https://hugetim.github.io/nbstata/) for details.

Lian, Yujun (2025). findsj: Search and cite articles from Stata Journal.

Stata software package. Version 1.0.3.2. Run: `jupyter notebook findsj_examples.ipynb`

Available at: https://github.com/BlueDayDreeaming/findsj

```**To export to HTML:**

```bash

## Licensejupyter nbconvert --to html findsj_examples.ipynb

```

MIT License - see [LICENSE](LICENSE) file for details

The HTML version provides a better viewing experience than traditional `.log` files and can be easily shared.

Copyright (c) 2025 Yujun Lian

## Support

## Author

For questions, bug reports, or feature requests:

**Yujun Lian**  - Email: arlionn@163.com

Sun Yat-sen University, Guangzhou, China  - Email: chucheng.wan@outlook.com

Email: arlionn@163.com  - GitHub Issues: [https://github.com/BlueDayDreeaming/findsj/issues](https://github.com/BlueDayDreeaming/findsj/issues)

GitHub: [BlueDayDreeaming](https://github.com/BlueDayDreeaming)

## Citation

---

If you use `findsj` in your research, please cite:

*Made with ❤️ for the Stata community*

```
Lian, Yujun (2025). findsj: Search and cite articles from Stata Journal.
Stata software package. Available at: https://github.com/BlueDayDreeaming/findsj
```

## License

MIT License - see [LICENSE](LICENSE) file for details

Copyright (c) 2025 Yujun Lian, CHUCHENG WAN

## Version History

### Version 1.0.1 (2025-10-18)
- Streamlined code (reduced from 1141 to 642 lines)
- Added cross-platform clipboard support (Windows and Mac)
- Improved error messages
- Enhanced documentation

### Version 1.0.0 (2025-10-15)
- Initial release
- Search by keyword, author, or title
- Export in Markdown, LaTeX, and plain text formats
- Integrated 13 sub-programs

## Authors

**Yujun Lian**
- Affiliation: Sun Yat-sen University, Guangzhou, China
- Email: arlionn@163.com

**Chucheng Wan**
- Affiliation: Sun Yat-sen University, Guangzhou, China
- Email: chucheng.wan@outlook.com

---

*Made with ❤️ for the Stata community*
