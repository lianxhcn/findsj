# findsj# findsj



Search and cite articles from Stata JournalSearch and cite articles from Stata Journal



[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

[![Stata](https://img.shields.io/badge/Stata-14%2B-blue)](https://www.stata.com/)[![Stata](https://img.shields.io/badge/Stata-14%2B-blue)](https://www.stata.com/)

[![Version](https://img.shields.io/badge/version-1.0.3-brightgreen)](https://github.com/BlueDayDreeaming/findsj)[![Version](https://img.shields.io/badge/version-1.0.3-brightgreen)](https://github.com/BlueDayDreeaming/findsj)



[English](README.md) | [中文文档](README_CN.md)[English](README.md) | [中文文档](README_CN.md)



## Overview## Overview



`findsj` is a Stata command that searches articles from the **Stata Journal (SJ)** and **Stata Technical Bulletin (STB)** by keywords, author names, or article titles. It displays comprehensive article information with clickable links to official citation downloads (BibTeX/RIS) and supports batch exporting citations in multiple formats.`findsj` is a Stata command that searches articles from the **Stata Journal (SJ)** and **Stata Technical Bulletin (STB)** by keywords, author names, or article titles. It displays comprehensive article information with clickable links to official citation downloads (BibTeX/RIS) and supports batch exporting citations in multiple formats.



## Key Features## Key Features



- 🔍 **Smart Search**: Search by keyword, author name, or article title-  **Smart Search**: Search by keyword, author name, or article title

- 📚 **Official Citations**: Direct links to BibTeX and RIS downloads from Stata Journal-  **Official Citations**: Direct links to BibTeX and RIS downloads from Stata Journal

- 📋 **Batch Export**: Export multiple citations to clipboard in plain text, Markdown, or LaTeX format-  **Batch Export**: Export multiple citations to clipboard in plain text, Markdown, or LaTeX format

- 🔗 **Rich Links**: Access to article pages, PDF downloads, Google Scholar, and related packages-  **Rich Links**: Access to article pages, PDF downloads, Google Scholar, and related packages

- 🎯 **DOI Support**: Optional DOI retrieval from official sources-  **DOI Support**: Optional DOI retrieval from official sources

- ⚡ **Fast & Easy**: Simple syntax with smart defaults-  **Fast & Easy**: Simple syntax with smart defaults



## Installation## Installation



### Method 1: From SSC (when available)### Method 1: From SSC (when available)



```stata```stata

ssc install findsj, replacessc install findsj, replace

``````



### Method 2: From GitHub### Method 2: From GitHub



```stata```stata

net install findsj, from(https://raw.githubusercontent.com/BlueDayDreeaming/findsj/main/)net install findsj, from(https://raw.githubusercontent.com/BlueDayDreeaming/findsj/main/)

``````



### Method 3: From Gitee (China mirror)### Method 3: From Gitee (China mirror)



```stata```stata

net install findsj, from(https://gitee.com/jack2342022/findsj/raw/main/)net install findsj, from(https://gitee.com/jack2342022/findsj/raw/main/)

``````



### Method 4: Manual Installation### Method 4: Manual Installation



1. Download all files to a local directory1. Download all files to a local directory

2. Run in Stata:2. Run in Stata:



```stata```stata

net install findsj, from("path/to/directory")net install findsj, from("path/to/directory")

``````



## Quick Start## Quick Start



### Basic Search### Basic Search



```stata```stata

findsj panel datafindsj panel data

``````



This displays the first 5 articles matching "panel data" with:This displays the first 5 articles matching "panel data" with:

- Article title, authors, and journal information

- Article title, authors, and journal information- Clickable links to article page and PDF

- Clickable links to article page and PDF- **BibTeX and RIS download links** ( Citation: BibTeX | RIS)

- **BibTeX and RIS download links** (📚 Citation: BibTeX | RIS)- Links to related Stata packages

- Links to related Stata packages- Google Scholar search link

- Google Scholar search link

### Search by Author

### Search by Author

```stata

```statafindsj Baum, author

findsj Baum, author```

```

### Search in Title Only

### Search in Title Only

```stata

```statafindsj panel data, title

findsj panel data, title```

```

### Show More Results

### Show More Results

```stata

```statafindsj panel data, n(10)

findsj panel data, n(10)```

```

### Export Citations to Clipboard

### Export Citations to Clipboard

```stata

```stata* Export first 5 results in plain text format

* Export first 5 results in plain text formatfindsj panel data, n(5) plain

findsj panel data, n(5) plain

* Export first 5 results in Markdown format

* Export first 5 results in Markdown formatfindsj panel data, n(5) markdown

findsj panel data, n(5) markdown

* Export first 5 results in LaTeX format

* Export first 5 results in LaTeX formatfindsj panel data, n(5) latex

findsj panel data, n(5) latex```

```

After running these commands, citations are automatically copied to your clipboard. You can paste them directly into your documents!

After running these commands, citations are automatically copied to your clipboard. You can paste them directly into your documents!

## Syntax

## Syntax

```stata

```statafindsj keywords [, options]

findsj keywords [, options]```

```

### Options

### Options

| Option | Description |

| Option | Description ||--------|-------------|

|--------|-------------|| **Search Scope** | |

| **Search Scope** | || `author` | Search by author name |

| `author` | Search by author name || `title` | Search by article title only |

| `title` | Search by article title only || `keyword` | Search by keywords in full text (default) |

| `keyword` | Search by keywords in full text (default) || **Export Format** | |

| **Export Format** | || `plain` | Export citations in plain text format to clipboard |

| `plain` | Export citations in plain text format to clipboard || `markdown` | Export citations in Markdown format to clipboard |

| `markdown` | Export citations in Markdown format to clipboard || `latex` (or `tex`) | Export citations in LaTeX format to clipboard |

| `latex` (or `tex`) | Export citations in LaTeX format to clipboard || **Display Options** | |

| **Display Options** | || `n(#)` | Number of results to display/export (default: 5) |

| `n(#)` | Number of results to display/export (default: 5) || `allresults` | Display and export all search results |

| `allresults` | Display and export all search results || `getdoi` | Retrieve DOI information in real-time (slower) |

| `getdoi` | Retrieve DOI information in real-time (slower) |

**Note**: When using export options (`plain`, `markdown`, or `latex`), DOI information is automatically retrieved.

**Note**: When using export options (`plain`, `markdown`, or `latex`), DOI information is automatically retrieved.

## Understanding the Output

### Example Output

```
[1] N. J. Cox. (2007).
    Speaking Stata: Identifying spells
    _Stata Journal_ 7(2)
    Article page | [PDF] | [Google]
    
    📚 Citation: BibTeX | RIS
    
    Search for package | Browse SJ software
```

### Citation Download Links

Each result includes **📚 Citation: BibTeX | RIS** links:

- **BibTeX**: Download citation in BibTeX format for LaTeX documents
- **RIS**: Download citation in RIS format for Zotero, Mendeley, EndNote, etc.

These links direct to the official Stata Journal citation service. Click the links to download citation files.

### Journal Information

```
_Stata Journal_ 7(2)
                ↑ ↑
                │ └── Issue Number (1-4, quarterly)
                └──── Volume Number
```

**Volume and Issue:**

- Volume 7 ≈ Published in 2007
- Issue 2 = June (Q2)
  - Issue 1: March
  - Issue 2: June
  - Issue 3: September
  - Issue 4: December

### DOI Information

When using `getdoi` option or export formats, DOI is displayed:

```
[1] N. J. Cox. (2007).
    Speaking Stata: Identifying spells
    _Stata Journal_ 7(2)
    Article page | [PDF] | [Google]
    DOI: 10.1177/1536867X0700700209    ← DOI added
    
    📚 Citation: BibTeX | RIS
```

## Export Formats

### Plain Text Format

```stata
findsj panel data, n(3) plain
```

Output (copied to clipboard):

```
[1] N. J. Cox. (2007). Speaking Stata: Identifying spells. Stata Journal 7(2). DOI: 10.1177/1536867X0700700209

[2] P. W. Jeanty. (2010). Using the world development indicators database for statistical analysis in Stata. Stata Journal 10(1). DOI: 10.1177/1536867X1001000105

[3] P. W. Jeanty. (2011). Managing the U.S. Census 2000 and World Development Indicators databases for statistical analysis in Stata. Stata Journal 11(4). DOI: 10.1177/1536867X1201100406
```

### Markdown Format

```stata
findsj panel data, n(3) markdown
```

Output (copied to clipboard):

```markdown
1. N. J. Cox. (2007). [Speaking Stata: Identifying spells](https://www.stata-journal.com/article.html?article=st0123). *Stata Journal* 7(2). DOI: [10.1177/1536867X0700700209](https://doi.org/10.1177/1536867X0700700209)

2. P. W. Jeanty. (2010). [Using the world development indicators database for statistical analysis in Stata](https://www.stata-journal.com/article.html?article=st0178). *Stata Journal* 10(1). DOI: [10.1177/1536867X1001000105](https://doi.org/10.1177/1536867X1001000105)

3. P. W. Jeanty. (2011). [Managing the U.S. Census 2000 and World Development Indicators databases for statistical analysis in Stata](https://www.stata-journal.com/article.html?article=st0247). *Stata Journal* 11(4). DOI: [10.1177/1536867X1201100406](https://doi.org/10.1177/1536867X1201100406)
```

### LaTeX Format

```stata
findsj panel data, n(3) latex
```

Output (copied to clipboard):

```latex
\begin{enumerate}
\item N. J. Cox. (2007). \href{https://www.stata-journal.com/article.html?article=st0123}{Speaking Stata: Identifying spells}. \textit{Stata Journal} 7(2). DOI: \href{https://doi.org/10.1177/1536867X0700700209}{10.1177/1536867X0700700209}

\item P. W. Jeanty. (2010). \href{https://www.stata-journal.com/article.html?article=st0178}{Using the world development indicators database for statistical analysis in Stata}. \textit{Stata Journal} 10(1). DOI: \href{https://doi.org/10.1177/1536867X1001000105}{10.1177/1536867X1001000105}

\item P. W. Jeanty. (2011). \href{https://www.stata-journal.com/article.html?article=st0247}{Managing the U.S. Census 2000 and World Development Indicators databases for statistical analysis in Stata}. \textit{Stata Journal} 11(4). DOI: \href{https://doi.org/10.1177/1536867X1201100406}{10.1177/1536867X1201100406}
\end{enumerate}
```

## Examples

See `findsj_examples.do` for comprehensive examples covering all features.

### Example 1: Basic Keyword Search

```stata
findsj panel data
```

Shows first 5 articles matching "panel data"

### Example 2: Limit Results

```stata
findsj panel data, n(10)
```

Shows first 10 results

### Example 3: Search by Author

```stata
findsj Baum, author
findsj "David Roodman", author n(3)
```

### Example 4: Search in Title Only

```stata
findsj panel data, title
```

### Example 5: Get DOI Information

```stata
findsj panel data, n(5) getdoi
```

Retrieves DOI from Stata Journal website (slower but includes DOI in display)

### Example 6: Export in Plain Text

```stata
findsj panel data, n(5) plain
```

Copies 5 citations in plain text to clipboard

### Example 7: Export in Markdown

```stata
findsj panel data, n(5) markdown
```

Copies 5 citations in Markdown format to clipboard

### Example 8: Export in LaTeX

```stata
findsj panel data, n(5) latex
```

Copies 5 citations in LaTeX format to clipboard

### Example 9: Export All Results

```stata
findsj boottest, author allresults markdown
```

Exports all results by author "boottest" in Markdown format

## Stored Results

After running `findsj`, the following values are stored in `r()`:

**Scalars:**

- `r(n_results)` - Number of articles found

**Macros:**

- `r(keywords)` - Search keywords
- `r(scope)` - Search scope (author/title/keyword)
- `r(url)` - Search URL
- `r(format)` - Export format (plain/markdown/latex), if used

**For each result i (i=1,2,3,...):**

- `r(art_id_i)` - Article ID
- `r(title_i)` - Article title
- `r(author_i)` - Author names
- `r(issue_i)` - Journal volume and issue
- `r(doi_i)` - DOI (when getdoi is used or export format specified)
- `r(url_i)` - Article URL

**Example:**

```stata
findsj panel data, n(3)
return list

display r(n_results)      // Shows: 69
display r(keywords)       // Shows: panel data
display r(title_1)        // Shows first article title
display r(author_1)       // Shows first article authors
```

## System Requirements

- **Stata Version**: 14.0 or higher
- **Internet Connection**: Required for searching and retrieving DOI
- **Clipboard Support**: Windows and macOS (Linux users can still view results, but clipboard export may not work)

## Files Included

- `findsj.ado` - Main program file
- `findsj.sthlp` - Help documentation
- `findsj.pkg` - Package definition
- `findsj_examples.do` - Comprehensive example script
- `stata.toc` - Table of contents
- `README.md` - This file (English)
- `README_CN.md` - Chinese documentation
- `README.txt` - Plain text readme
- `LICENSE` - MIT License

## What's New in Version 1.0.3 (2025-10-22)

### Major Changes

- ✅ **Replaced copy buttons with official citation downloads**: Each result now shows clickable **BibTeX** and **RIS** download links from Stata Journal
- ✅ **Removed `findsj_copy` subcommand**: Individual citation copying is no longer needed
- ✅ **Streamlined code**: Reduced file size from 30,907 to 27,130 bytes (160+ lines removed)
- ✅ **Retained batch export**: The `plain`, `markdown`, and `latex` export options remain fully functional

### What Was Removed

- ❌ Individual copy buttons (📋 Copy: plain | markdown | latex) per result
- ❌ `findsj_copy` subcommand
- ❌ Global macro saving for individual citations

### What Was Added

- ✅ Official BibTeX/RIS download links: **📚 Citation: BibTeX | RIS**
- ✅ Automatic DOI retrieval when using export formats
- ✅ Improved documentation with version history

### Migration Guide

**If you were using:**

```stata
* OLD (no longer works):
findsj panel data
findsj_copy 1 markdown
```

**Switch to:**

```stata
* NEW (batch export):
findsj panel data, n(5) markdown
* Or click the BibTeX/RIS links in the output
```

## Support

For questions, bug reports, or feature requests:

- **Email**: arlionn@163.com
- **GitHub Issues**: https://github.com/BlueDayDreeaming/findsj/issues
- **Gitee Issues**: https://gitee.com/jack2342022/findsj/issues

## Citation

If you use `findsj` in your research, please cite:

```
Lian, Yujun (2025). findsj: Search and cite articles from Stata Journal.
Stata software package. Version 1.0.3.
Available at: https://github.com/BlueDayDreeaming/findsj
```

## License

MIT License - see [LICENSE](LICENSE) file for details

Copyright (c) 2025 Yujun Lian

## Author

**Yujun Lian**  
Sun Yat-sen University, Guangzhou, China  
Email: arlionn@163.com  
GitHub: [BlueDayDreeaming](https://github.com/BlueDayDreeaming)

---

*Made with ❤️ for the Stata community*
