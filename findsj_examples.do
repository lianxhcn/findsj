********************************************************************************
* findsj Examples
* Authors: Yujun Lian (arlionn@163.com), Chucheng Wan (chucheng.wan@outlook.com)
* Affiliation: Sun Yat-sen University, Guangzhou, China
* Date: 2025-10-18
* Description: Examples demonstrating findsj command usage
********************************************************************************

capture log close
log using "findsj_examples.log", replace text

version 14
clear all
set more off

********************************************************************************
* Example 1: Basic keyword search
********************************************************************************

display as text _n(2) "{hline 80}"
display as text "Example 1: Search articles by keyword"
display as text "{hline 80}" _n

* Search for articles about panel data
findsj panel, n(3)

* Store and display results
return list


********************************************************************************
* Example 2: Search by author name
********************************************************************************

display as text _n(2) "{hline 80}"
display as text "Example 2: Search articles by author"
display as text "{hline 80}" _n

* Find articles by David Roodman
findsj Roodman, author n(2)

* Display returned values
display as text _n "Number of results: " as result r(n_results)
display as text "First article: " as result r(title_1)


********************************************************************************
* Example 3: Search by article title
********************************************************************************

display as text _n(2) "{hline 80}"
display as text "Example 3: Search articles by title"
display as text "{hline 80}" _n

* Search for synthetic control articles
findsj synth, title n(2)


********************************************************************************
* Example 4: Export citations in Markdown format
********************************************************************************

display as text _n(2) "{hline 80}"
display as text "Example 4: Export citations in Markdown"
display as text "{hline 80}" _n

* Export in Markdown format (without clipboard for log clarity)
findsj treatment, markdown n(2) noclip


********************************************************************************
* Example 5: Export citations in LaTeX format
********************************************************************************

display as text _n(2) "{hline 80}"
display as text "Example 5: Export citations in LaTeX"
display as text "{hline 80}" _n

* Export in LaTeX format
findsj regression, latex n(2) noclip


********************************************************************************
* Example 6: Export in plain text format
********************************************************************************

display as text _n(2) "{hline 80}"
display as text "Example 6: Export in plain text"
display as text "{hline 80}" _n

* Plain text format (suitable for academic papers)
findsj "difference in differences", plain n(2) noclip


********************************************************************************
* Example 7: Display more results
********************************************************************************

display as text _n(2) "{hline 80}"
display as text "Example 7: Display more results"
display as text "{hline 80}" _n

* Show 10 results
findsj panel, n(10)


********************************************************************************
* Example 8: Display all results
********************************************************************************

display as text _n(2) "{hline 80}"
display as text "Example 8: Display all results"
display as text "{hline 80}" _n

* Show all results for a specific search
findsj xtabond, title allresults


********************************************************************************
* Example 9: Search without browser links
********************************************************************************

display as text _n(2) "{hline 80}"
display as text "Example 9: Search without browser links"
display as text "{hline 80}" _n

* Suppress browser links
findsj instrumental, nobrowser n(2)


********************************************************************************
* Example 10: Comprehensive search with multiple options
********************************************************************************

display as text _n(2) "{hline 80}"
display as text "Example 10: Comprehensive search"
display as text "{hline 80}" _n

* Search with markdown export, no clipboard, no package info
findsj causality, markdown n(3) noclip nopkg


********************************************************************************
* Summary
********************************************************************************

display as text _n(2) "{hline 80}"
display as text "All examples completed successfully!"
display as text "{hline 80}" _n

log close
