--------------------------------------------------------------------------------NOTE:  readme.txt template -- do not remove empty entries, but you may

findsj: Search and cite articles from Stata Journal                              add entries for additional authors

--------------------------------------------------------------------------------------------------------------------------------------------------------------



Version: 1.0.1Package name:   <leave blank>

Date: 2025-10-18

Author: Yujun LianDOI:  <leave blank>

Email: arlionn@163.com

License: MITTitle:  



--------------------------------------------------------------------------------Author 1 name: 

DescriptionAuthor 1 from:  

--------------------------------------------------------------------------------Author 1 email: 



findsj searches for articles from the Stata Journal (SJ) and Stata Technical Author 2 name:  

Bulletin (STB) by keywords, author names, or article titles. It displays Author 2 from:  

article information including DOI, PDF links, and related Stata packages. Author 2 email: 

Citations can be exported in various formats (Markdown, LaTeX, or plain text).

Author 3 name:  

Key Features:Author 3 from:  

- Search by keyword, author name, or article titleAuthor 3 email: 

- Display article information with clickable links

- Export citations in Markdown, LaTeX, or plain text formatAuthor 4 name:  

- Automatic clipboard support (Windows and Mac)Author 4 from:  

- Access to DOI, PDF links, and related packagesAuthor 4 email: 

- Easy-to-use interface

Author 5 name:  

--------------------------------------------------------------------------------Author 5 from:  

InstallationAuthor 5 email: 

--------------------------------------------------------------------------------

Help keywords: 

Method 1: From SSC (recommended when available)

    . ssc install findsj, replaceFile list: 



Method 2: From GitHubNotes:

    Method 2: From GitHub
    . net install findsj, from(https://raw.githubusercontent.com/BlueDayDreeaming/findsj/main/)

Method 3: Manual installation
    1. Download all files to a local directory
    2. Run: net install findsj, from("path/to/directory")

--------------------------------------------------------------------------------
Quick Start
--------------------------------------------------------------------------------

Basic search:
    . findsj panel data

Search by author:
    . findsj Roodman, author

Search by title:
    . findsj synth, title

Export in Markdown:
    . findsj regression, markdown

Export in LaTeX:
    . findsj "instrumental variables", latex

Display more results:
    . findsj panel, n(10)

Display all results:
    . findsj boottest, allresults

--------------------------------------------------------------------------------
Syntax
--------------------------------------------------------------------------------

findsj keywords [, options]

Options:

    Search scope:
        author          Search by author name
        title           Search by article title
        keyword         Search by keywords (default)
    
    Export format:
        markdown        Export in Markdown format
        latex (tex)     Export in LaTeX format
        plain           Export in plain text format
    
    Output control:
        noclip          Do not copy results to clipboard
        nobrowser       Do not display browser links
        nodoi           Do not display DOI information
        nopdf           Do not display PDF links
        nopkg           Do not display package information
    
    Display:
        n(#)            Number of results to display (default: 5)
        allresults      Display all search results
    
    Other:
        clear           Clear existing search results
        debug           Enable debug mode

--------------------------------------------------------------------------------
Examples
--------------------------------------------------------------------------------

See findsj_examples.do for comprehensive examples, or run:
    . help findsj

Example 1: Search for panel data articles
    . findsj panel

Example 2: Find articles by David Roodman
    . findsj Roodman, author

Example 3: Search for synthetic control articles
    . findsj synth, title

Example 4: Export citations in Markdown
    . findsj treatment, markdown n(3)

Example 5: Export citations in LaTeX
    . findsj regression, latex n(3)

Example 6: Display 10 results
    . findsj instrumental, n(10)

Example 7: Search without browser links
    . findsj causality, nobrowser

--------------------------------------------------------------------------------
System Requirements
--------------------------------------------------------------------------------

- Stata 14.0 or higher
- Internet connection required for searching
- Clipboard support: Windows and Mac only
- Data file: sjget_data_sj.dta (included in package)

--------------------------------------------------------------------------------
Files Included
--------------------------------------------------------------------------------

findsj.ado              Main program file
findsj.sthlp            Help file
findsj.pkg              Package file
findsj_examples.do      Example do-file
findsj_examples.log     Example log file
sjget_data_sj.dta       Stata Journal data file
README.txt              This file

--------------------------------------------------------------------------------
Stored Results
--------------------------------------------------------------------------------

findsj stores the following in r():

    Scalars:
        r(n_results)    Number of articles found
    
    Macros:
        r(keywords)     Search keywords
        r(scope)        Search scope (author/title/keyword)
        r(url)          Search URL
        r(art_id_1)     Article ID of first result
        r(title_1)      Title of first result
        r(author_1)     Author of first result
        r(doi_1)        DOI of first result
        r(url_1)        URL of first result

--------------------------------------------------------------------------------
Support
--------------------------------------------------------------------------------

For questions, bug reports, or feature requests:
- Email: arlionn@163.com
- GitHub: https://github.com/BlueDayDreeaming/findsj

--------------------------------------------------------------------------------
Citation
--------------------------------------------------------------------------------

If you use findsj in your research, please cite:

    Lian, Yujun (2025). findsj: Search and cite articles from Stata Journal.
    Stata software package. Available at: https://github.com/BlueDayDreeaming/findsj

--------------------------------------------------------------------------------
License
--------------------------------------------------------------------------------

MIT License

Copyright (c) 2025 Yujun Lian

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

--------------------------------------------------------------------------------
Version History
--------------------------------------------------------------------------------

Version 1.0.1 (2025-10-18)
- Streamlined code (reduced from 1141 to 642 lines)
- Added cross-platform clipboard support (Windows and Mac)
- Improved error messages
- Enhanced documentation

Version 1.0.0 (2025-10-15)
- Initial release
- Search by keyword, author, or title
- Export in Markdown, LaTeX, and plain text formats
- Integrated 13 sub-programs

--------------------------------------------------------------------------------
End of README
--------------------------------------------------------------------------------
