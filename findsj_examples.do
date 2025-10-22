********************************************************************************
* findsj_examples.do
* Examples demonstrating all features of the findsj command
* Version 1.0.3 (2025/10/22)
* Authors: Yujun Lian (arlionn@163.com), Chucheng Wan (chucheng.wan@outlook.com)
********************************************************************************

capture log close
log using "findsj_examples.log", replace text

clear all
set more off

dis _n(2) "{hline 80}"
dis "FINDSJ EXAMPLES - Version 1.0.3"
dis "Searching Stata Journal Articles"
dis "{hline 80}" _n

********************************************************************************
* Example 1: Basic search
********************************************************************************
dis _n "{bf:Example 1: Basic search for 'panel data'}"
findsj panel data

********************************************************************************
* Example 2: Limit number of results
********************************************************************************
dis _n(2) "{bf:Example 2: Show only top 10 results}"
findsj panel data, n(10)

********************************************************************************
* Example 3: Search in title only
********************************************************************************
dis _n(2) "{bf:Example 3: Search 'panel data' in title only}"
findsj panel data, title

********************************************************************************
* Example 4: Search by author
********************************************************************************
dis _n(2) "{bf:Example 4: Search articles by author 'Baum'"
findsj Baum, author

********************************************************************************
* Example 5: Get DOI information
********************************************************************************
dis _n(2) "{bf:Example 5: Search with DOI information}"
findsj panel data, n(5) getdoi

********************************************************************************
* Example 6: Export citations (plain format to clipboard)
********************************************************************************
dis _n(2) "{bf:Example 6: Export top 5 results in plain format}"
findsj panel data, n(5) plain

********************************************************************************
* Example 7: Export citations (markdown format to clipboard)
********************************************************************************
dis _n(2) "{bf:Example 7: Export top 5 results in markdown format}"
findsj panel data, n(5) markdown

********************************************************************************
* Example 8: Export citations (latex format to clipboard)
********************************************************************************
dis _n(2) "{bf:Example 8: Export top 5 results in latex format}"
findsj panel data, n(5) latex

********************************************************************************
* Summary
********************************************************************************
dis _n(2) "{hline 80}"
dis "EXAMPLES COMPLETED"
dis "{hline 80}"
dis _n "Available options:"
dis "  - n(#)        : Limit number of results"
dis "  - title       : Search in title only"
dis "  - author      : Search by author name"
dis "  - getdoi      : Retrieve DOI information (slower)"
dis "  - plain       : Export citations in plain format"
dis "  - markdown    : Export citations in markdown format"
dis "  - latex       : Export citations in LaTeX format"
dis _n "For each result, you can:"
dis "  - Click BibTeX/RIS links to download citation files"
dis "  - Click article links to view in browser"
dis "{hline 80}" _n

log close

dis _n "{bf:Log file saved as: findsj_examples.log}"