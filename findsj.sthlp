{smcl}
{* *! version 1.0.1  18oct2025}{...}
{viewerjumpto "Syntax" "findsj##syntax"}{...}
{viewerjumpto "Description" "findsj##description"}{...}
{viewerjumpto "Options" "findsj##options"}{...}
{viewerjumpto "Examples" "findsj##examples"}{...}
{viewerjumpto "Stored results" "findsj##results"}{...}
{viewerjumpto "Author" "findsj##author"}{...}
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

{syntab:Export format}
{synopt :{opt markdown}}export citations in Markdown format{p_end}
{synopt :{opt latex}}export citations in LaTeX format{p_end}
{synopt :{opt tex}}export citations in LaTeX format (alias){p_end}
{synopt :{opt plain}}export citations in plain text format{p_end}

{syntab:Output control}
{synopt :{opt noclip}}do not copy results to clipboard{p_end}
{synopt :{opt nobrowser}}do not display browser links{p_end}
{synopt :{opt nodoi}}do not display DOI information{p_end}
{synopt :{opt nopdf}}do not display PDF links{p_end}
{synopt :{opt nopkg}}do not display package installation commands{p_end}

{syntab:Display}
{synopt :{opt n(#)}}number of results to display (default: 5){p_end}
{synopt :{opt allresults}}display all search results{p_end}

{syntab:Other}
{synopt :{opt clear}}clear existing search results{p_end}
{synopt :{opt debug}}enable debug mode{p_end}
{synoptline}
{p2colreset}{...}


{marker description}{...}
{title:Description}

{pstd}
{cmd:findsj} searches for articles from the Stata Journal (SJ) and 
Stata Technical Bulletin (STB) by keywords, author names, or article 
titles. It displays article information including DOI, PDF links, and 
related Stata packages. Citations can be exported in various formats 
(Markdown, LaTeX, or plain text).


{marker options}{...}
{title:Options}

{dlgtab:Search scope}

{phang}
{opt author} searches by author name. Use this option when looking for 
articles by a specific author.

{phang}
{opt title} searches by article title. Use this option when you know 
part of the article title.

{phang}
{opt keyword} searches by keywords in article content. This is the 
default search method.

{dlgtab:Export format}

{phang}
{opt markdown} exports citations in Markdown format with clickable links.

{phang}
{opt latex} or {opt tex} exports citations in LaTeX format with 
hyperlinks.

{phang}
{opt plain} exports citations in plain text format without links.

{dlgtab:Output control}

{phang}
{opt noclip} prevents automatic copying of citations to clipboard.

{phang}
{opt nobrowser} suppresses display of clickable browser links in 
Stata output.

{phang}
{opt nodoi} suppresses display of DOI information.

{phang}
{opt nopdf} suppresses display of PDF download links.

{phang}
{opt nopkg} suppresses display of package installation commands.

{dlgtab:Display}

{phang}
{opt n(#)} specifies the number of search results to display. 
Default is 5.

{phang}
{opt allresults} displays all search results instead of limiting 
to n results.

{dlgtab:Other}

{phang}
{opt clear} clears any existing search results before performing 
new search.

{phang}
{opt debug} enables debug mode for troubleshooting.


{marker examples}{...}
{title:Examples}

    {hline}
{pstd}Basic keyword search{p_end}
{phang2}{cmd:. findsj panel data}{p_end}

    {hline}
{pstd}Search by author{p_end}
{phang2}{cmd:. findsj "David Roodman", author}{p_end}

    {hline}
{pstd}Search by title{p_end}
{phang2}{cmd:. findsj synth, title}{p_end}

    {hline}
{pstd}Export in Markdown format{p_end}
{phang2}{cmd:. findsj regression, markdown n(3)}{p_end}

    {hline}
{pstd}Export in LaTeX format{p_end}
{phang2}{cmd:. findsj "difference-in-differences", latex}{p_end}

    {hline}
{pstd}Display more results{p_end}
{phang2}{cmd:. findsj panel, n(10)}{p_end}

    {hline}
{pstd}Display all results{p_end}
{phang2}{cmd:. findsj boottest, author allresults}{p_end}

    {hline}
{pstd}Search without clipboard{p_end}
{phang2}{cmd:. findsj "synthetic control", title noclip}{p_end}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:findsj} stores the following in {cmd:r()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt:{cmd:r(n_results)}}number of articles found{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Macros}{p_end}
{synopt:{cmd:r(keywords)}}search keywords{p_end}
{synopt:{cmd:r(scope)}}search scope (author/title/keyword){p_end}
{synopt:{cmd:r(url)}}search URL{p_end}
{synopt:{cmd:r(art_id_1)}}article ID of first result{p_end}
{synopt:{cmd:r(title_1)}}title of first result{p_end}
{synopt:{cmd:r(author_1)}}author of first result{p_end}
{synopt:{cmd:r(doi_1)}}DOI of first result{p_end}
{synopt:{cmd:r(url_1)}}URL of first result{p_end}
{p2colreset}{...}


{marker author}{...}
{title:Author}

{pstd}Yujun Lian{p_end}
{pstd}Email: {browse "mailto:arlionn@163.com":arlionn@163.com}{p_end}


{title:Also see}

{psee}
Online:  {helpb search}, {helpb net}, {helpb ssc}
{p_end}
