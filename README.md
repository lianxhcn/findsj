# findsj

Search and cite articles from Stata Journal

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Stata](https://img.shields.io/badge/Stata-14%2B-blue)](https://www.stata.com/)
[![Version](https://img.shields.io/badge/version-1.1.0-brightgreen)](https://github.com/BlueDayDreeaming/findsj)

[English](README.md) | [中文文档](README_CN.md)

## Overview

`findsj` is a Stata command that searches articles from the **Stata Journal (SJ)** and **Stata Technical Bulletin (STB)** by keywords, author names, or article titles. All article information is **fetched directly from the Stata Journal website in real-time**, ensuring the most up-to-date results without requiring local data files.

## Key Features

- 🔍 **Real-Time Search**: All data fetched directly from Stata Journal website
- � **Citation Downloads**: Download BibTeX and RIS files with cross-platform support
- 🖥️ **Cross-Platform**: Native support for Windows, Mac, and Linux
- 📋 **Batch Export**: Export citations in Markdown, LaTeX, or plain text format
- 🔗 **Rich Links**: Access article pages, PDFs, Google Scholar, and related packages
- 🎯 **Optional DOI**: Real-time DOI retrieval when needed
- 📁 **Path Management**: Configurable download path (persistent across sessions)
- ⚡ **Fast & Easy**: Simple syntax with smart defaults

## Installation

### Method 1: From GitHub

```stata
net install findsj, from(https://raw.githubusercontent.com/BlueDayDreeaming/findsj/main/) replace
```

### Method 2: From Gitee (China mirror)

```stata
net install findsj, from(https://gitee.com/ChuChengWan/findsj/raw/main/) replace
```

### Method 3: Manual Installation

1. Download all files to a local directory
2. Run in Stata:

```stata
net install findsj, from("path/to/directory") replace
```

## System Requirements

- **Stata**: Version 14.0 or later
- **Internet**: Active connection required for real-time search
- **Mac/Linux**: curl command-line tool (pre-installed on most systems)
- **Windows**: PowerShell (built-in)

## Quick Start

### 1. Basic Search

Search by keyword (shows 10 results by default):

```stata
findsj machine learning
```

Search by author:

```stata
findsj Baum, author
```

Search by title:

```stata
findsj treatment effects, title
```

### 2. Download Citations

Click the **Download BibTeX** or **Download RIS** buttons in the results to download citation files. Files are saved to your current directory by default.

**Configure download path:**

```stata
findsj, setpath(/your/custom/path)    // Set custom path
findsj, querypath                      // Check current path
findsj, resetpath                      // Reset to default
```

### 3. Export Citations to Clipboard

Export in Markdown format:

```stata
findsj propensity score, markdown
```

Export in LaTeX format:

```stata
findsj difference-in-differences, latex
```

Export in plain text:

```stata
findsj panel data, plain
```

## Syntax

```stata
findsj [keyword(s)] [, options]
```

### Options

#### Search Options
- `author` - Search by author name
- `title` - Search by article title
- `keyword` - Search by keyword (default)

#### Display Options
- `n(#)` - Number of results to display (default: 10)
- `allresults` - Show all results
- `nobrowser` - Hide clickable links in results
- `nopdf` - Hide PDF links
- `nopkg` - Hide package search links

#### Export Options
- `markdown` - Export citations in Markdown format
- `latex` (or `tex`) - Export citations in LaTeX format
- `plain` - Export citations in plain text format
- `noclip` - Don't copy to clipboard

#### Path Management Options
- `setpath(path)` - Set custom download path
- `querypath` - Display current download path
- `resetpath` - Reset to default path (current directory)

#### Advanced Options
- `getdoi` - Fetch real-time DOI from Stata Journal (slower but more complete)
- `debug` - Show debugging information

## Examples

### Example 1: Basic Keyword Search

```stata
findsj regression
```

### Example 2: Search by Author

```stata
findsj Baum, author
```

### Example 3: Limit Number of Results

```stata
findsj machine learning, n(5)
```

### Example 4: Search by Title

```stata
findsj treatment effects, title
```

### Example 5: Export in Markdown

```stata
findsj matching, markdown
```

### Example 6: Show All Results

```stata
findsj panel data, allresults
```

### Example 7: Get DOI Information

```stata
findsj propensity score, getdoi n(3)
```

### Example 8: Configure Download Path

```stata
findsj, setpath(D:\Citations)     // Windows
findsj, setpath(/Users/name/Documents/Citations)  // Mac
findsj, querypath                  // Check current path
```

### Example 9: Export in LaTeX Format

```stata
findsj causal inference, latex n(5)
```

### Example 10: Show All Results with DOI

```stata
findsj difference-in-differences, allresults getdoi
```

## Features in Detail

### 1. Real-Time Search

All article information is fetched directly from the Stata Journal website in real-time:

- **No Local Data**: No need to download or update data files
- **Always Current**: Get the latest articles immediately
- **Fast Performance**: Efficient web scraping with smart parsing
- **Reliable**: Direct from official Stata Journal source

### 2. Cross-Platform Citation Downloads

Download BibTeX and RIS files with native support for all platforms:

**Windows**: Uses PowerShell to download with proper headers
**Mac/Linux**: Uses curl with proper headers  
**Automatic**: Files open automatically after download  
**Custom Path**: Configure persistent download location

The download includes proper Referer headers to bypass anti-scraping protections.

### 3. Path Management

Configure where citation files are saved:

```stata
findsj, setpath(/path/to/citations)   // Set custom path
findsj, querypath                      // Check current setting
findsj, resetpath                      // Reset to default
```

Settings are persistent across Stata sessions.

### 4. Batch Citation Export

Export multiple citations to clipboard at once:

- **Markdown**: Formatted with links for documentation
- **LaTeX**: Ready for bibliographies with \href links
- **Plain Text**: Simple list format

Paste directly into documents with Ctrl+V (Windows) or Cmd+V (Mac).

### 5. Rich Information Display

Each result shows:

- Article title (displayed first for better readability)
- Author(s) and publication year
- Journal information (volume, number, pages)
- Clickable links to:
  - Article page
  - PDF download
  - Google Scholar search
  - Package search and software
- Download buttons for BibTeX and RIS

### 6. Optional DOI Fetching

Use the `getdoi` option to fetch DOI and page numbers in real-time:

```stata
findsj causal inference, getdoi n(3)
```

This is slower but provides complete citation information.

## Data Source

`findsj` fetches data in real-time from the official Stata Journal website:

- **Real-Time**: All searches query the live website
- **No Local Files**: No data files to download or update
- **Comprehensive**: All Stata Journal (SJ) and Stata Technical Bulletin (STB) articles
- **Always Current**: Includes the latest publications automatically

## Version History

### Version 1.1.0 (2025-11-05)
- **Major Update**: Removed dependency on local data files
- All article information now fetched online in real-time
- Improved Mac/Unix download support with proper shell scripts
- Added download path configuration (setpath, querypath, resetpath)
- Fixed BibTeX/RIS download with Referer header spoofing
- Enhanced display format (title displayed first)
- Changed default display from 5 to 10 results
- Removed findsj_finddata and findsj_download_data subcommands
- Cross-platform support for Windows, Mac, and Linux

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
- Check your download path with `findsj, querypath`
- On Mac: verify curl is installed (usually pre-installed)
- On Windows: verify PowerShell is available (built-in)
- Try setting a different download path: `findsj, setpath(path)`

### Search returns no results?

- Check your internet connection
- Try different keywords or search terms
- Use broader search terms
- Try searching by author or title instead

### DOI information missing?

- Use the `getdoi` option for real-time DOI fetching
- Note: This is slower but provides complete information
- Example: `findsj keywords, getdoi n(5)`

### Download path issues?

- Use `findsj, querypath` to check current path
- Use `findsj, resetpath` to reset to default
- Ensure the path exists and is writable
- Use absolute paths (e.g., D:\Citations or /Users/name/Documents)

### Mac-specific issues?

- Ensure curl is installed: `which curl` in Terminal
- Check file permissions in download directory
- Downloaded files should open automatically in default application

## Comparison with findit

| Feature | findsj | findit |
|---------|--------|--------|
| Source | Stata Journal only | All Stata resources |
| Real-time Data | Yes | N/A |
| Citation Downloads | Yes (BibTeX/RIS) | No |
| Cross-platform | Yes | Yes |
| Batch Export | Yes (Markdown/LaTeX) | No |
| Author Search | Yes | Limited |
| Path Configuration | Yes | No |
| DOI Links | Yes (optional) | No |
| Clickable Links | Yes | Limited |

## What's New in v1.1.0

### Major Changes

1. **No Local Data Files**: Removed all local data file dependencies. Everything is now fetched in real-time from the Stata Journal website.

2. **Cross-Platform Downloads**: Native support for Windows (PowerShell), Mac (curl), and Linux (curl) with proper header handling.

3. **Path Management**: Configure and save your preferred download location across sessions.

4. **Improved Display**: Title shown first for better readability, default increased to 10 results.

5. **Simplified Architecture**: Removed `findsj_finddata` and `findsj_download_data` subcommands - no longer needed.

### Migration from v1.0.x

If you're upgrading from v1.0.x:

- No local data files to manage or update
- Download paths can now be configured and saved
- All searches are now real-time (no local cache)
- BibTeX/RIS downloads work identically but with better cross-platform support

## Contributing

Contributions are welcome! Please feel free to submit issues or pull requests on GitHub.

## Support

For questions, bug reports, or feature requests:

- **Email**: arlionn@163.com
- **GitHub Issues**: https://github.com/BlueDayDreeaming/findsj/issues
- **Gitee Issues**: https://gitee.com/ChuChengWan/findsj/issues

## Automated Database Updates

This repository uses GitHub Actions for **automated database updates**:

- 🤖 **Scheduled Updates**: Automatically fetch latest articles from Stata Journal on the 1st of each month
- 📦 **Auto Commit**: New articles are automatically added to `findsj.dta` and committed
- 🔄 **Manual Trigger**: Can also manually trigger updates from GitHub Actions page

For details, see: [Auto Update Documentation](.github/AUTO_UPDATE.md)

## Citation

If you use `findsj` in your research, please cite:

```
Lian, Yujun and Wan, Chucheng (2025). findsj: Search and cite articles from Stata Journal.
Stata software package. Version 1.1.0.
Available at: https://github.com/BlueDayDreeaming/findsj
```

## License

MIT License - see [LICENSE](LICENSE) file for details

Copyright (c) 2025 Yujun Lian, Chucheng Wan

## Author

**Yujun Lian**  
Sun Yat-sen University, Guangzhou, China  
Email: arlionn@163.com

**Chucheng Wan**  
Sun Yat-sen University, Guangzhou, China  
Email: chucheng.wan@outlook.com  
GitHub: [BlueDayDreeaming](https://github.com/BlueDayDreeaming)  
Gitee: [ChuChengWan](https://gitee.com/ChuChengWan)

---

*Made with ❤️ for the Stata community*
