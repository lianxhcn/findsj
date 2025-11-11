{smcl}
{* *! version 1.1.0  11nov2025}
{viewerjumpto "Syntax" "findsj##syntax"}
{viewerjumpto "Description" "findsj##description"}
{viewerjumpto "Options" "findsj##options"}
{viewerjumpto "Examples" "findsj##examples"}
{viewerjumpto "Stored results" "findsj##results"}
{viewerjumpto "Author" "findsj##author"}
{title:Title}

{p2colset 5 16 18 2}{...}
{p2col :{cmd:findsj} {hline 2}}Search and cite articles from Stata Journal{p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 15 2}
{cmd:findsj}
{it:keywords}
[{cmd:,} {it:options}]


{synoptset 20 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Search scope}
{synopt :{opt author}}search by author name{p_end}
{synopt :{opt title}}search by article title{p_end}
{synopt :{opt keyword}}search by keywords (default){p_end}

{syntab:Display}
{synopt :{opt n(#)}}number of results to display (default: 10){p_end}
{synopt :{opt allresults}}display all search results{p_end}

{syntab:DOI and Citation}
{synopt :{opt getdoi}}retrieve and display DOI information{p_end}
{synopt :{opt md}}export citations in Markdown format (auto-enables {opt getdoi}){p_end}
{synopt :{opt latex}}export citations in LaTeX format (auto-enables {opt getdoi}){p_end}
{synopt :{opt plain}}export citations in plain text format (auto-enables {opt getdoi}){p_end}

{syntab:Output control}
{synopt :{opt noclip}}do not copy results to clipboard{p_end}
{synopt :{opt nobrowser}}do not display clickable links{p_end}
{synopt :{opt nopdf}}do not display PDF links{p_end}
{synopt :{opt nopkg}}do not display package links{p_end}

{syntab:Path management}
{synopt :{opt setpath(path)}}set custom download path{p_end}
{synopt :{opt querypath}}display current download path{p_end}
{synopt :{opt resetpath}}reset to default path{p_end}

{syntab:Other}
{synopt :{opt clear}}clear existing search results{p_end}
{synopt :{opt debug}}enable debug mode{p_end}
{synoptline}
{p2colreset}{...}


{marker description}{...}
{title:Description}

{pstd}
{cmd:findsj} searches the Stata Journal for articles matching specified keywords, author names, or titles.
It provides clickable links to article pages, PDFs, and installation commands. When used with the {opt getdoi}
option, it can retrieve DOI information and export formatted citations.


{marker options}{...}
{title:Options}

{dlgtab:Search scope}

{phang}
{opt author} searches for articles by author name.

{phang}
{opt title} searches for articles by title.

{phang}
{opt keyword} searches for articles by keywords. This is the default search method.

{dlgtab:Display}

{phang}
{opt n(#)} specifies the number of search results to display. The default is 10.

{phang}
{opt allresults} displays all search results instead of limiting to {opt n(#)} results.

{dlgtab:DOI and Citation}

{phang}
{opt getdoi} retrieves and displays Digital Object Identifier (DOI) information for each article.
This option is slower because it requires additional queries. When a citation format is specified
({opt md}, {opt latex}, or {opt plain}), DOI numbers become clickable links that copy the formatted
citation to your clipboard.

{phang}
{opt md} exports citations in Markdown format. This option automatically enables {opt getdoi}.
Citations are automatically copied to the clipboard and DOI numbers become clickable.

{phang}
{opt latex} exports citations in LaTeX format. This option automatically enables {opt getdoi}.
Citations are automatically copied to the clipboard and DOI numbers become clickable.

{phang}
{opt plain} exports citations in plain text format. This option automatically enables {opt getdoi}.
Citations are automatically copied to the clipboard and DOI numbers become clickable.

{dlgtab:Output control}

{phang}
{opt noclip} prevents results from being automatically copied to the clipboard.

{phang}
{opt nobrowser} disables clickable links in the output.

{phang}
{opt nopdf} hides PDF download links in the results.

{phang}
{opt nopkg} hides package installation links in the results.

{dlgtab:Path management}

{phang}
{opt setpath(path)} sets a custom download path for BibTeX and RIS files.
The path setting is saved and will be used in future sessions.

{phang}
{opt querypath} displays the current download path setting.

{phang}
{opt resetpath} resets the download path to the default (current working directory).

{dlgtab:Other}

{phang}
{opt clear} clears existing search results before displaying new ones.

{phang}
{opt debug} enables debug mode, showing detailed execution information.


{marker examples}{...}
{title:Examples}

{phang}{cmd:. findsj panel}{p_end}
{phang2}Search for articles about "panel" methods{p_end}

{phang}{cmd:. findsj "fixed effects", n(20)}{p_end}
{phang2}Search for articles about "fixed effects" and display 20 results{p_end}

{phang}{cmd:. findsj Angrist, author}{p_end}
{phang2}Search for articles by author name "Angrist"{p_end}

{phang}{cmd:. findsj difference-in-differences, title}{p_end}
{phang2}Search for articles with "difference-in-differences" in the title{p_end}

{phang}{cmd:. findsj regression, getdoi}{p_end}
{phang2}Search for articles about "regression" and retrieve DOI information{p_end}

{phang}{cmd:. findsj panel, md}{p_end}
{phang2}Search for articles about "panel" and export citations in Markdown format.
       Citations are copied to clipboard and DOI numbers are clickable.{p_end}

{phang}{cmd:. findsj "time series", latex}{p_end}
{phang2}Search for articles about "time series" and export citations in LaTeX format{p_end}

{phang}{cmd:. findsj clustering, plain allresults}{p_end}
{phang2}Search for all articles about "clustering" and export citations in plain text format{p_end}

{phang}{cmd:. findsj matching, setpath(D:/Papers)}{p_end}
{phang2}Set download path to D:/Papers and search for articles about "matching"{p_end}

{phang}{cmd:. findsj, querypath}{p_end}
{phang2}Display current download path setting{p_end}

{phang}{cmd:. findsj, resetpath}{p_end}
{phang2}Reset download path to default{p_end}


{marker clickable_doi}{...}
{title:Clickable DOI Feature}

{pstd}
When you use {opt getdoi} with a citation format ({opt md}, {opt latex}, or {opt plain}),
DOI numbers are displayed as clickable links. Clicking on a DOI number will:

{p 8 12 2}1. Copy the formatted citation to your clipboard{p_end}
{p 8 12 2}2. Display a tip message: "Tips: Text is on clipboard. Press 'Ctrl+V' to paste, ^-^"{p_end}
{p 8 12 2}3. Allow you to paste the citation anywhere with Ctrl+V{p_end}

{pstd}
Example workflow:

{p 8 12 2}1. Run: {cmd:findsj panel, md}{p_end}
{p 8 12 2}2. Click on any blue DOI number in the results{p_end}
{p 8 12 2}3. The citation is copied to clipboard{p_end}
{p 8 12 2}4. Paste with Ctrl+V in your document{p_end}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:findsj} stores the following in {cmd:r()}:

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Scalars}{p_end}
{synopt:{cmd:r(n_results)}}number of articles found{p_end}

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Macros}{p_end}
{synopt:{cmd:r(keywords)}}search keywords{p_end}
{synopt:{cmd:r(scope)}}search scope (author, title, or keyword){p_end}
{synopt:{cmd:r(url)}}URL of the search results page{p_end}
{p2colreset}{...}


{marker author}{...}
{title:Author}

{pstd}
Yujun Lian{break}
Lingnan College, Sun Yat-Sen University{break}
Email: {browse "mailto:arlionn@163.com":arlionn@163.com}

{pstd}
Chucheng Wan{break}
Email: {browse "mailto:chucheng.wan@outlook.com":chucheng.wan@outlook.com}


{marker also_see}{...}
{title:Also see}

{psee}
Online: {help getiref} (if installed)
{p_end}
