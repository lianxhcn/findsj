--------------------------------------------------------------------------------------------------------------------------------------------------------------NOTE:  readme.txt template -- do not remove empty entries, but you may

Package name:  findsj

findsj: Search and cite articles from Stata Journal                              add entries for additional authors

DOI:  (To be added)

--------------------------------------------------------------------------------------------------------------------------------------------------------------

Title:  findsj - Search and cite articles from Stata Journal



Author 1 name:  Yujun Lian

Author 1 from:  Author affiliationVersion: 1.0.1Package name:   <leave blank>

Author 1 email: arlionn@163.com

Date: 2025-10-18

Author 2 name:  CHUCHENG WAN

Author 2 from:  Sun Yat-sen University, Guangzhou, ChinaAuthor: Yujun LianDOI:  <leave blank>

Author 2 email: chucheng.wan@outlook.com

Email: arlionn@163.com

Help keywords:  findsj

License: MITTitle:  

File list: findsj.ado findsj.sthlp findsj.pkg findsj_examples.do findsj_examples.log README.txt



Notes: Internet connection required for searching Stata Journal articles.

       Clipboard support available on Windows and Mac systems only.--------------------------------------------------------------------------------Author 1 name: 

       

Description:DescriptionAuthor 1 from:  



findsj searches for articles from the Stata Journal (SJ) and Stata Technical --------------------------------------------------------------------------------Author 1 email: 

Bulletin (STB) by keywords, author names, or article titles. It displays 

article information including DOI, PDF links, and related Stata packages. 

Citations can be exported in various formats (Markdown, LaTeX, or plain text).

findsj searches for articles from the Stata Journal (SJ) and Stata Technical Author 2 name:  

Key Features:

- Search by keyword, author name, or article titleBulletin (STB) by keywords, author names, or article titles. It displays Author 2 from:  

- Display article information with clickable links

- Export citations in Markdown, LaTeX, or plain text formatarticle information including DOI, PDF links, and related Stata packages. Author 2 email: 

- Automatic clipboard support (Windows and Mac)

- Access to DOI, PDF links, and related packagesCitations can be exported in various formats (Markdown, LaTeX, or plain text).

- Easy-to-use interface

Author 3 name:  

Installation:

Key Features:Author 3 from:  

Method 1: From GitHub

    . net install findsj, from(https://raw.githubusercontent.com/BlueDayDreeaming/findsj/main/)- Search by keyword, author name, or article titleAuthor 3 email: 



Method 2: From SSC (when available)- Display article information with clickable links

    . ssc install findsj, replace

- Export citations in Markdown, LaTeX, or plain text formatAuthor 4 name:  

Quick Start Examples:

- Automatic clipboard support (Windows and Mac)Author 4 from:  

Basic search:

    . findsj panel data- Access to DOI, PDF links, and related packagesAuthor 4 email: 



Search by author:- Easy-to-use interface

    . findsj Roodman, author

Author 5 name:  

Search by title:

    . findsj synth, title--------------------------------------------------------------------------------Author 5 from:  



Export in Markdown:InstallationAuthor 5 email: 

    . findsj regression, markdown

--------------------------------------------------------------------------------

Export in LaTeX:

    . findsj "instrumental variables", latexHelp keywords: 



Display more results:Method 1: From SSC (recommended when available)

    . findsj panel, n(10)

    . ssc install findsj, replaceFile list: 

Display all results:

    . findsj boottest, allresults



Syntax:Method 2: From GitHubNotes:



findsj keywords [, options]    Method 2: From GitHub

    . net install findsj, from(https://raw.githubusercontent.com/BlueDayDreeaming/findsj/main/)

Options:

Method 3: Manual installation

    Search scope:    1. Download all files to a local directory

        author          Search by author name    2. Run: net install findsj, from("path/to/directory")

        title           Search by article title

        keyword         Search by keywords (default)--------------------------------------------------------------------------------

    Quick Start

    Export format:--------------------------------------------------------------------------------

        markdown        Export in Markdown format

        latex (tex)     Export in LaTeX formatBasic search:

        plain           Export in plain text format    . findsj panel data

    

    Output control:Search by author:

        noclip          Do not copy results to clipboard    . findsj Roodman, author

        nobrowser       Do not display browser links

        nodoi           Do not display DOI informationSearch by title:

        nopdf           Do not display PDF links    . findsj synth, title

        nopkg           Do not display package information

    Export in Markdown:

    Display:    . findsj regression, markdown

        n(#)            Number of results to display (default: 5)

        allresults      Display all search resultsExport in LaTeX:

        . findsj "instrumental variables", latex

    Other:

        clear           Clear existing search resultsDisplay more results:

        debug           Enable debug mode    . findsj panel, n(10)



System Requirements:Display all results:

    . findsj boottest, allresults

- Stata 14.0 or higher

- Internet connection required for searching--------------------------------------------------------------------------------

- Clipboard support: Windows and Mac onlySyntax

--------------------------------------------------------------------------------

Stored Results:

findsj keywords [, options]

findsj stores the following in r():

Options:

    Scalars:

        r(n_results)    Number of articles found    Search scope:

            author          Search by author name

    Macros:        title           Search by article title

        r(keywords)     Search keywords        keyword         Search by keywords (default)

        r(scope)        Search scope (author/title/keyword)    

        r(url)          Search URL    Export format:

        r(art_id_1)     Article ID of first result        markdown        Export in Markdown format

        r(title_1)      Title of first result        latex (tex)     Export in LaTeX format

        r(author_1)     Author of first result        plain           Export in plain text format

        r(doi_1)        DOI of first result    

        r(url_1)        URL of first result    Output control:

        noclip          Do not copy results to clipboard

Support:        nobrowser       Do not display browser links

        nodoi           Do not display DOI information

For questions, bug reports, or feature requests:        nopdf           Do not display PDF links

- GitHub Issues: https://github.com/BlueDayDreeaming/findsj/issues        nopkg           Do not display package information

- Email: arlionn@163.com or chucheng.wan@outlook.com    

    Display:

License:        n(#)            Number of results to display (default: 5)

        allresults      Display all search results

MIT License    

Copyright (c) 2025 Yujun Lian, CHUCHENG WAN    Other:

        clear           Clear existing search results

Version History:        debug           Enable debug mode



Version 1.0.1 (2025-10-18)--------------------------------------------------------------------------------

- Streamlined code (reduced from 1141 to 642 lines)Examples

- Added cross-platform clipboard support (Windows and Mac)--------------------------------------------------------------------------------

- Improved error messages

- Enhanced documentationSee findsj_examples.do for comprehensive examples, or run:

    . help findsj

Version 1.0.0 (2025-10-15)

- Initial releaseExample 1: Search for panel data articles

- Search by keyword, author, or title    . findsj panel

- Export in Markdown, LaTeX, and plain text formats

- Integrated 13 sub-programsExample 2: Find articles by David Roodman

    . findsj Roodman, author

------------------------------------------------------------------------------

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
