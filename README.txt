NOTE:  readme.txt template -- do not remove empty entries, but you may
                              add entries for additional authors
------------------------------------------------------------------------------

Package name:   findsj

DOI:  

Title: findsj - Search and cite articles from Stata Journal

Version: 1.1.0 (2025/11/05)

Author 1 name: Yujun Lian
Author 1 from: Sun Yat-sen University, Guangzhou, China
Author 1 email: arlionn@163.com

Author 2 name: Chucheng Wan
Author 2 from: Sun Yat-sen University, Guangzhou, China
Author 2 email: chucheng.wan@outlook.com

Author 3 name:  
Author 3 from:  
Author 3 email: 

Author 4 name:  
Author 4 from:  
Author 4 email: 

Author 5 name:  
Author 5 from:  
Author 5 email: 

Help keywords: findsj, Stata Journal, search, citation, bibliography, BibTeX, RIS

File list: findsj.ado findsj.sthlp findsj_examples.do stata.toc

Notes: 

findsj searches for articles from the Stata Journal (SJ) and Stata 
Technical Bulletin (STB) by keywords, author names, or article titles. 
All article information is fetched directly from the Stata Journal website
in real-time, ensuring the most up-to-date results without requiring local
data files.

Key Features:
- Real-time search directly from Stata Journal website
- Display article information with clickable links (HTML, PDF, Google Scholar)
- Download citations in BibTeX and RIS formats with proper Referer headers
- Cross-platform support (Windows, Mac, Linux) with native download scripts
- Export citations in Markdown, LaTeX, or plain text formats
- Automatic clipboard support on Windows and Mac
- Search by keyword, author, or title
- Configurable download path (persistent across sessions)
- Optional real-time DOI fetching with getdoi option

Version 1.1.0 Changes:
- Removed dependency on local data files (findsj_finddata, findsj_download_data)
- All article information now fetched online in real-time
- Improved Mac/Unix download support with proper shell script generation
- Added download path configuration (setpath, querypath, resetpath)
- Fixed BibTeX/RIS download with Referer header spoofing
- Enhanced display format (title first, configurable number of results)

System Requirements:
- Stata 14.0 or higher
- Internet connection required
- Mac users: curl command-line tool (pre-installed on macOS)
- Windows users: PowerShell (built-in)

Installation: 
net install findsj, from(https://raw.githubusercontent.com/BlueDayDreeaming/findsj/main/) replace
net install findsj, from(https://gitee.com/ChuChengWan/findsj/raw/main/) replace

Quick Start:
findsj regression                          // Basic search
findsj panel data, n(10)                   // Show 10 results
findsj Baum, author                        // Search by author
findsj propensity score, markdown          // Export in Markdown
findsj, setpath(/your/path)                // Set download path
findsj, querypath                          // Check current path

GitHub: https://github.com/BlueDayDreeaming/findsj
Gitee: https://gitee.com/ChuChengWan/findsj

Contact: arlionn@163.com, chucheng.wan@outlook.com

