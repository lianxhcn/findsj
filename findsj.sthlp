{smcl}{smcl}

{* *! version 1.0.3  22oct2025}{...}{* *! version 1.0.1  18oct2025}{...}

{viewerjumpto "Syntax" "findsj##syntax"}{...}{viewerjumpto "Syntax" "findsj##syntax"}{...}

{viewerjumpto "Description" "findsj##description"}{...}{viewerjumpto "Description" "findsj##description"}{...}

{viewerjumpto "Options" "findsj##options"}{...}{viewerjumpto "Options" "findsj##options"}{...}

{viewerjumpto "Examples" "findsj##examples"}{...}{viewerjumpto "Examples" "findsj##examples"}{...}

{viewerjumpto "Stored results" "findsj##results"}{...}{viewerjumpto "Stored results" "findsj##results"}{...}

{viewerjumpto "Author" "findsj##author"}{...}{viewerjumpto "Author" "findsj##author"}{...}

{title:Title}{title:Title}



{p2colset 5 16 18 2}{...}{p2colset 5 16 18 2}{...}

{p2col :{cmd:findsj} {hline 2}}Search and cite articles from Stata Journal{p_end}{p2col :{cmd:findsj} {hline 2}}Search and cite articles from Stata Journal{p_end}

{p2colreset}{...}{p2colreset}{...}





{marker syntax}{...}{marker syntax}{...}

{title:Syntax}{title:Syntax}



{p 8 15 2}{p 8 15 2}

{cmd:findsj}{cmd:findsj}

{it:keywords}{it:keywords}

[{cmd:,} {it:options}][{cmd:,} {it:options}]



{synoptset 20 tabbed}{...}{synoptset 20 tabbed}{...}

{synopthdr}{synopthdr}

{synoptline}{synoptline}

{syntab:Search scope}{syntab:Search scope}

{synopt :{opt author}}search by author name{p_end}{synopt :{opt author}}search by author name{p_end}

{synopt :{opt title}}search by article title{p_end}{synopt :{opt title}}search by article title{p_end}

{synopt :{opt keyword}}search by keywords (default){p_end}{synopt :{opt keyword}}search by keywords (default){p_end}



{syntab:Export format}{syntab:Export format}

{synopt :{opt markdown}}export citations in Markdown format to clipboard{p_end}{synopt :{opt markdown}}export citations in Markdown format{p_end}

{synopt :{opt latex}}export citations in LaTeX format to clipboard{p_end}{synopt :{opt latex}}export citations in LaTeX format{p_end}

{synopt :{opt tex}}export citations in LaTeX format to clipboard (alias){p_end}{synopt :{opt tex}}export citations in LaTeX format (alias){p_end}

{synopt :{opt plain}}export citations in plain text format to clipboard{p_end}{synopt :{opt plain}}export citations in plain text format{p_end}



{syntab:Display}{syntab:Output control}

{synopt :{opt n(#)}}number of results to display (default: 5){p_end}{synopt :{opt noclip}}do not copy results to clipboard{p_end}

{synopt :{opt allresults}}display all search results{p_end}{synopt :{opt nobrowser}}do not display browser links{p_end}

{synopt :{opt getdoi}}retrieve and display DOI information (slower){p_end}{synopt :{opt nodoi}}do not display DOI information{p_end}

{synoptline}{synopt :{opt nopdf}}do not display PDF links{p_end}

{p2colreset}{...}{synopt :{opt nopkg}}do not display package installation commands{p_end}



{syntab:Display}

{marker description}{...}{synopt :{opt n(#)}}number of results to display (default: 5){p_end}

{title:Description}{synopt :{opt allresults}}display all search results{p_end}



{pstd}{syntab:Other}

{cmd:findsj} searches for articles from the Stata Journal (SJ) and {synopt :{opt clear}}clear existing search results{p_end}

Stata Technical Bulletin (STB) by keywords, author names, or article {synopt :{opt debug}}enable debug mode{p_end}

titles. It displays article information including clickable links to:{synoptline}

{p2colreset}{...}

{phang2}• Article pages and PDF downloads{p_end}

{phang2}• BibTeX and RIS citation downloads from Stata Journal{p_end}

{phang2}• Related Stata packages and software{p_end}{marker description}{...}

{phang2}• Google Scholar searches{p_end}{title:Description}



{pstd}{pstd}

Citations can be batch exported to clipboard in plain text, Markdown, {cmd:findsj} searches for articles from the Stata Journal (SJ) and 

or LaTeX formats for easy inclusion in your documents.Stata Technical Bulletin (STB) by keywords, author names, or article 

titles. It displays article information including DOI, PDF links, and 

related Stata packages. Citations can be exported in various formats 

{marker options}{...}(Markdown, LaTeX, or plain text).

{title:Options}



{dlgtab:Search scope}{marker options}{...}

{title:Options}

{phang}

{opt author} searches by author name. Use this option when looking for {dlgtab:Search scope}

articles by a specific author.

{phang}

{phang}{opt author} searches by author name. Use this option when looking for 

{opt title} searches by article title. Use this option when you know articles by a specific author.

part of the article title.

{phang}

{phang}{opt title} searches by article title. Use this option when you know 

{opt keyword} searches by keywords in article content. This is the part of the article title.

default search method.

{phang}

{dlgtab:Export format}{opt keyword} searches by keywords in article content. This is the 

default search method.

{phang}

{opt markdown} exports citations in Markdown format with clickable links {dlgtab:Export format}

and copies them to clipboard. Use this for Markdown documents, GitHub 

README files, or Obsidian notes.{phang}

{opt markdown} exports citations in Markdown format with clickable links.

{phang}

{opt latex} or {opt tex} exports citations in LaTeX format with {phang}

hyperlinks and copies them to clipboard. Use this for LaTeX documents {opt latex} or {opt tex} exports citations in LaTeX format with 

or academic papers.hyperlinks.



{phang}{phang}

{opt plain} exports citations in plain text format and copies them to {opt plain} exports citations in plain text format without links.

clipboard. Use this for simple text documents or emails.

{dlgtab:Output control}

{dlgtab:Display}

{phang}

{phang}{opt noclip} prevents automatic copying of citations to clipboard.

{opt n(#)} specifies the number of search results to display and export. 

Default is 5. When combined with export options (plain/markdown/latex), {phang}

only the first n results will be copied to clipboard.{opt nobrowser} suppresses display of clickable browser links in 

Stata output.

{phang}

{opt allresults} displays all search results instead of limiting {phang}

to n results. When combined with export options, all results will be {opt nodoi} suppresses display of DOI information.

copied to clipboard.

{phang}

{phang}{opt nopdf} suppresses display of PDF download links.

{opt getdoi} retrieves DOI information from the Stata Journal website 

in real-time. This option is slower but useful when DOI information {phang}

is needed. DOI information is automatically retrieved when using export {opt nopkg} suppresses display of package installation commands.

options (plain/markdown/latex).

{dlgtab:Display}



{marker examples}{...}{phang}

{title:Examples}{opt n(#)} specifies the number of search results to display. 

Default is 5.

    {hline}

{pstd}Basic keyword search (shows first 5 results){p_end}{phang}

{phang2}{cmd:. findsj panel data}{p_end}{opt allresults} displays all search results instead of limiting 

to n results.

    {hline}

{pstd}Search and show top 10 results{p_end}{dlgtab:Other}

{phang2}{cmd:. findsj panel data, n(10)}{p_end}

{phang}

    {hline}{opt clear} clears any existing search results before performing 

{pstd}Search by author{p_end}new search.

{phang2}{cmd:. findsj Baum, author}{p_end}

{phang2}{cmd:. findsj "David Roodman", author}{p_end}{phang}

{opt debug} enables debug mode for troubleshooting.

    {hline}

{pstd}Search by title{p_end}

{phang2}{cmd:. findsj panel data, title}{p_end}{marker examples}{...}

{phang2}{cmd:. findsj synthetic control, title}{p_end}{title:Examples}



    {hline}    {hline}

{pstd}Search with DOI information{p_end}{pstd}Basic keyword search{p_end}

{phang2}{cmd:. findsj panel data, n(5) getdoi}{p_end}{phang2}{cmd:. findsj panel data}{p_end}



    {hline}    {hline}

{pstd}Export citations in plain text format (copies to clipboard){p_end}{pstd}Search by author{p_end}

{phang2}{cmd:. findsj panel data, n(5) plain}{p_end}{phang2}{cmd:. findsj "David Roodman", author}{p_end}



    {hline}    {hline}

{pstd}Export citations in Markdown format (copies to clipboard){p_end}{pstd}Search by title{p_end}

{phang2}{cmd:. findsj panel data, n(5) markdown}{p_end}{phang2}{cmd:. findsj synth, title}{p_end}



    {hline}    {hline}

{pstd}Export citations in LaTeX format (copies to clipboard){p_end}{pstd}Export in Markdown format{p_end}

{phang2}{cmd:. findsj difference-in-differences, n(5) latex}{p_end}{phang2}{cmd:. findsj regression, markdown n(3)}{p_end}



    {hline}    {hline}

{pstd}Export all results in Markdown format{p_end}{pstd}Export in LaTeX format{p_end}

{phang2}{cmd:. findsj boottest, author allresults markdown}{p_end}{phang2}{cmd:. findsj "difference-in-differences", latex}{p_end}



    {hline}

{marker results}{...}{pstd}Display more results{p_end}

{title:Stored results}{phang2}{cmd:. findsj panel, n(10)}{p_end}



{pstd}    {hline}

{cmd:findsj} stores the following in {cmd:r()}:{pstd}Display all results{p_end}

{phang2}{cmd:. findsj boottest, author allresults}{p_end}

{synoptset 20 tabbed}{...}

{p2col 5 20 24 2: Scalars}{p_end}    {hline}

{synopt:{cmd:r(n_results)}}number of articles found{p_end}{pstd}Search without clipboard{p_end}

{phang2}{cmd:. findsj "synthetic control", title noclip}{p_end}

{synoptset 20 tabbed}{...}

{p2col 5 20 24 2: Macros}{p_end}

{synopt:{cmd:r(keywords)}}search keywords{p_end}{marker results}{...}

{synopt:{cmd:r(scope)}}search scope (author/title/keyword){p_end}{title:Stored results}

{synopt:{cmd:r(url)}}search URL{p_end}

{synopt:{cmd:r(format)}}export format (plain/markdown/latex){p_end}{pstd}

{cmd:findsj} stores the following in {cmd:r()}:

{pstd}

For each result i (i=1,2,3,...):{synoptset 20 tabbed}{...}

{p2col 5 20 24 2: Scalars}{p_end}

{synopt:{cmd:r(art_id_}{it:i}{cmd:)}}}article ID{p_end}{synopt:{cmd:r(n_results)}}number of articles found{p_end}

{synopt:{cmd:r(title_}{it:i}{cmd:)}}}article title{p_end}

{synopt:{cmd:r(author_}{it:i}{cmd:)}}}author names{p_end}{synoptset 20 tabbed}{...}

{synopt:{cmd:r(issue_}{it:i}{cmd:)}}}journal volume and issue{p_end}{p2col 5 20 24 2: Macros}{p_end}

{synopt:{cmd:r(doi_}{it:i}{cmd:)}}}DOI (when getdoi is used){p_end}{synopt:{cmd:r(keywords)}}search keywords{p_end}

{synopt:{cmd:r(url_}{it:i}{cmd:)}}}article URL{p_end}{synopt:{cmd:r(scope)}}search scope (author/title/keyword){p_end}

{p2colreset}{...}{synopt:{cmd:r(url)}}search URL{p_end}

{synopt:{cmd:r(art_id_1)}}article ID of first result{p_end}

{synopt:{cmd:r(title_1)}}title of first result{p_end}

{marker citation}{...}{synopt:{cmd:r(author_1)}}author of first result{p_end}

{title:Citation downloads}{synopt:{cmd:r(doi_1)}}DOI of first result{p_end}

{synopt:{cmd:r(url_1)}}URL of first result{p_end}

{pstd}{p2colreset}{...}

For each search result, {cmd:findsj} displays clickable links to 

download citations in BibTeX and RIS formats:

{marker author}{...}

{phang2}📚 Citation: BibTeX | RIS{p_end}{title:Author}



{pstd}{pstd}Yujun Lian{p_end}

These links direct to the official Stata Journal citation download {pstd}Email: {browse "mailto:arlionn@163.com":arlionn@163.com}{p_end}

service. Click the links to download citation files that can be 

imported into reference management software like Zotero, Mendeley, 

or EndNote.{title:Also see}



{psee}

{marker author}{...}Online:  {helpb search}, {helpb net}, {helpb ssc}

{title:Author}{p_end}


{pstd}Yujun Lian{p_end}
{pstd}Email: {browse "mailto:arlionn@163.com":arlionn@163.com}{p_end}
{pstd}GitHub: {browse "https://github.com/BlueDayDreeaming/findsj":https://github.com/BlueDayDreeaming/findsj}{p_end}


{marker updates}{...}
{title:Version history}

{pstd}
Version 1.0.3 (22oct2025):{p_end}
{phang2}• Replaced individual copy buttons with official BibTeX/RIS download links{p_end}
{phang2}• Removed findsj_copy subcommand{p_end}
{phang2}• Retained batch export functionality (plain/markdown/latex){p_end}
{phang2}• Added automatic DOI retrieval when using export formats{p_end}

{pstd}
Version 1.0.2 (18oct2025):{p_end}
{phang2}• Added citation copy functionality{p_end}
{phang2}• Improved search results display{p_end}


{title:Also see}

{psee}
Online:  {helpb search}, {helpb net}, {helpb ssc}
{p_end}
