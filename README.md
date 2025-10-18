# findsj

Search and cite articles from Stata Journal

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Stata](https://img.shields.io/badge/Stata-14%2B-blue)](https://www.stata.com/)

## Overview

`findsj` is a Stata command that searches for articles from the **Stata Journal (SJ)** and **Stata Technical Bulletin (STB)** by keywords, author names, or article titles. It displays article information including DOI, PDF links, and related Stata packages. Citations can be exported in various formats (Markdown, LaTeX, or plain text).

## Key Features

- 🔍 Search by keyword, author name, or article title
- 📄 Display article information with clickable links
- 📋 Export citations in Markdown, LaTeX, or plain text format
- 📎 Automatic clipboard support (Windows and Mac)
- 🔗 Access to DOI, PDF links, and related packages
- ⚡ Easy-to-use interface

## Installation

### Method 1: From SSC (when available)
```stata
ssc install findsj, replace
```

### Method 2: From GitHub
```stata
net install findsj, from(https://raw.githubusercontent.com/BlueDayDreeaming/findsj/main/)
```

### Method 3: Manual installation
1. Download all files to a local directory
2. Run in Stata:
```stata
net install findsj, from("path/to/directory")
```

## Quick Start

### Basic search
```stata
findsj panel data
```

### Search by author
```stata
findsj Roodman, author
```

### Search by title
```stata
findsj synth, title
```

### Export in Markdown
```stata
findsj regression, markdown
```

### Export in LaTeX
```stata
findsj instrumental variables, latex
```

## Syntax

```stata
findsj keywords [, options]
```

### Options

**Search scope:**
- `author` - Search by author name
- `title` - Search by article title
- `keyword` - Search by keywords (default)

**Export format:**
- `markdown` - Export in Markdown format
- `latex` (or `tex`) - Export in LaTeX format
- `plain` - Export in plain text format

**Output control:**
- `noclip` - Do not copy results to clipboard
- `nobrowser` - Do not display browser links
- `nodoi` - Do not display DOI information
- `nopdf` - Do not display PDF links
- `nopkg` - Do not display package information

**Display:**
- `n(#)` - Number of results to display (default: 5)
- `allresults` - Display all search results

**Other:**
- `clear` - Clear existing search results
- `debug` - Enable debug mode

## Examples

See `findsj_examples.do` for comprehensive examples, or run:
```stata
help findsj
```

### Example 1: Search for panel data articles
```stata
findsj panel
```

### Example 2: Find articles by David Roodman
```stata
findsj Roodman, author
```

### Example 3: Search for synthetic control articles
```stata
findsj synth, title
```

### Example 4: Export citations in Markdown
```stata
findsj treatment, markdown n(3)
```

### Example 5: Export citations in LaTeX
```stata
findsj regression, latex n(3)
```

### Example 6: Display 10 results
```stata
findsj instrumental, n(10)
```

### Example 7: Display all results
```stata
findsj boottest, allresults
```

## System Requirements

- Stata 14.0 or higher
- Internet connection required for searching
- Clipboard support: Windows and Mac only

## Files Included

- `findsj.ado` - Main program file
- `findsj.sthlp` - Help file
- `findsj.pkg` - Package file
- `findsj_examples.do` - Example do-file
- `findsj_examples.log` - Example log file
- `README.txt` - Documentation in plain text
- `README.md` - This file

## Stored Results

`findsj` stores the following in `r()`:

**Scalars:**
- `r(n_results)` - Number of articles found

**Macros:**
- `r(keywords)` - Search keywords
- `r(scope)` - Search scope (author/title/keyword)
- `r(url)` - Search URL
- `r(art_id_1)` - Article ID of first result
- `r(title_1)` - Title of first result
- `r(author_1)` - Author of first result
- `r(doi_1)` - DOI of first result
- `r(url_1)` - URL of first result

## Support

For questions, bug reports, or feature requests:
- Email: arlionn@163.com
- GitHub Issues: [https://github.com/BlueDayDreeaming/findsj/issues](https://github.com/BlueDayDreeaming/findsj/issues)

## Citation

If you use `findsj` in your research, please cite:

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
