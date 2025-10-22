# findsj

Search and cite articles from Stata Journal

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Stata](https://img.shields.io/badge/Stata-14%2B-blue)](https://www.stata.com/)
[![Version](https://img.shields.io/badge/version-1.0.3-brightgreen)](https://github.com/BlueDayDreeaming/findsj)

[English](README.md) | [中文文档](README_CN.md)

## Overview

`findsj` is a Stata command that searches articles from the **Stata Journal (SJ)** and **Stata Technical Bulletin (STB)** by keywords, author names, or article titles. It displays comprehensive article information with clickable links to official citation downloads (BibTeX/RIS) and supports batch exporting citations in multiple formats.

## Key Features

- 🔍 **Smart Search**: Search by keyword, author name, or article title
- 📚 **Official Citations**: Direct links to BibTeX and RIS downloads from Stata Journal
- 📋 **Batch Export**: Export multiple citations to clipboard in plain text, Markdown, or LaTeX format
- 🔗 **Rich Links**: Access to article pages, PDF downloads, Google Scholar, and related packages
- 🎯 **DOI Support**: Optional DOI retrieval from official sources
- ⚡ **Fast & Easy**: Simple syntax with smart defaults

## Installation

### Method 1: From SSC (when available)

```stata
ssc install findsj, replace
```

### Method 2: From GitHub

```stata
net install findsj, from(https://raw.githubusercontent.com/BlueDayDreeaming/findsj/main/)
```

### Method 3: From Gitee (China mirror)

```stata
net install findsj, from(https://gitee.com/ChuChengWan/findsj/raw/main/)
```

### Method 4: Manual Installation

1. Download all files to a local directory
2. Run in Stata:

```stata
net install findsj, from("path/to/directory")
```

## Quick Start

### 1. Basic Search

Search by keyword:

```stata
findsj machine learning
```

Search by author:

```stata
findsj, author(Mitchell)
```

### 2. Get Citations

Use the clickable **BibTeX** or **RIS** buttons in the results table to download citations directly from the Stata Journal website.

### 3. Batch Export

Export all citations to clipboard:

```stata
findsj machine learning, export
```

Export in Markdown format:

```stata
findsj propensity score, export markdown
```

Export in LaTeX format:

```stata
findsj difference-in-differences, export latex
```

## Syntax

```stata
findsj [keyword(s)] [, options]
```

### Options

#### Search Options
- `author(name)` - Search by author name
- `title(text)` - Search by article title
- `issue(volno)` - Limit to specific issue (e.g., "20(4)")
- `from(year)` - Earliest publication year
- `to(year)` - Latest publication year

#### Display Options
- `detail` - Show detailed article information
- `nolink` - Hide clickable links in results
- `max(#)` - Maximum results to display (default: 20, 0 = all)

#### Export Options
- `export` - Export all results to clipboard in plain text
- `markdown` - Export in Markdown format
- `latex` - Export in LaTeX format

#### Advanced Options
- `verbose` - Show detailed operation information
- `getdoi` - Fetch real-time DOI from Stata Journal (slower)

## Examples

### Example 1: Keyword Search

```stata
findsj regression
```

### Example 2: Author Search with Details

```stata
findsj, author(Nichols) detail
```

### Example 3: Specific Issue

```stata
findsj, issue(20(4))
```

### Example 4: Year Range

```stata
findsj panel data, from(2015) to(2020)
```

### Example 5: Export Citations

```stata
findsj matching, export markdown
```

### Example 6: Title Search

```stata
findsj, title(treatment effects)
```

### Example 7: Full Information with DOI

```stata
findsj propensity score, detail getdoi
```

### Example 8: Combined Conditions

```stata
findsj causal inference, author(Angrist) from(2000) detail
```

## Features in Detail

### 1. Search Capabilities

- **Flexible Search**: Combine keywords with options for precise results
- **Smart Matching**: Case-insensitive search with partial matching
- **Multiple Fields**: Search across title, author, abstract, and keywords
- **Date Filtering**: Restrict results by publication year range

### 2. Official Citation Downloads

The results table includes clickable buttons for each article:

- **BibTeX**: Download BibTeX citation directly from Stata Journal
- **RIS**: Download RIS citation for reference managers

These links connect to the official Stata Journal citation service at:
`https://www.stata-journal.com/ris.php?doi={article_doi}`

### 3. Batch Citation Export

Export multiple citations at once to your clipboard:

- **Plain Text**: Simple citation list
- **Markdown**: Formatted for Markdown documents
- **LaTeX**: Ready for LaTeX bibliographies

After export, paste directly into your document with `Ctrl+V` (Windows) or `Cmd+V` (Mac).

### 4. Rich Information Display

Each result includes:

- Article title and authors
- Publication details (journal, year, volume, issue, pages)
- DOI and links
- Abstract and keywords
- Related Stata package information

### 5. Clickable Links

Direct access to:

- Article PDF on Stata Journal website
- Article page with full details
- Google Scholar search for the article
- Related Stata package download

## Data Source

`findsj` uses the official Stata Journal article database, which includes:

- All **Stata Journal (SJ)** articles
- All **Stata Technical Bulletin (STB)** articles
- Regular updates with new publications
- Complete citation information and DOIs

## Requirements

- Stata 14.0 or later
- Active internet connection (for DOI retrieval and citation downloads)

## Version History

### Version 1.0.3 (2025-10-22)
- Replaced copy buttons with official BibTeX/RIS download links
- Removed `findsj_copy` subcommand
- Added `getdoi` option for real-time DOI fetching
- Improved performance by removing clipboard dependencies
- Updated documentation and examples

### Version 1.0.2 (2025-10-20)
- Added three-button citation copy functionality
- Improved error handling

### Version 1.0.1 (2025-10-18)
- Initial release with basic search and export features

## Troubleshooting

### Citations not downloading?

- Ensure you have an active internet connection
- Check that the DOI exists for the article
- Try clicking the link again or use a different browser

### DOI retrieval slow?

- Use the `getdoi` option only when needed
- The default DOI from the database is usually sufficient

### Export not working?

- Make sure you have at least one search result
- Check that clipboard access is available
- Try a different export format

## Comparison with findit

| Feature | findsj | findit |
|---------|--------|--------|
| Source | Stata Journal only | All Stata resources |
| Citations | Yes (BibTeX/RIS) | No |
| Batch Export | Yes | No |
| Author Search | Yes | Limited |
| Year Filter | Yes | No |
| DOI Links | Yes | No |
| Detailed Info | Yes | Basic |

## Future Plans

- [ ] Add abstract search functionality
- [ ] Support for other citation formats (e.g., APA, Chicago)
- [ ] Integration with reference managers
- [ ] Offline mode with local database
- [ ] Article recommendation based on keywords

## Contributing

Contributions are welcome! Please feel free to submit issues or pull requests on GitHub.

## Support

For questions, bug reports, or feature requests:

- **Email**: arlionn@163.com
- **GitHub Issues**: https://github.com/BlueDayDreeaming/findsj/issues
- **Gitee Issues**: https://gitee.com/ChuChengWan/findsj/issues

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
