{smcl}{smcl}{smcl}

{* *! version 1.1.0  05nov2025}

{viewerjumpto "Syntax" "findsj##syntax"}{* *! version 1.0.3  22oct2025}{...}{* *! version 1.0.1  18oct2025}{...}

{viewerjumpto "Description" "findsj##description"}

{viewerjumpto "Options" "findsj##options"}{viewerjumpto "Syntax" "findsj##syntax"}{...}{viewerjumpto "Syntax" "findsj##syntax"}{...}

{viewerjumpto "Examples" "findsj##examples"}

{viewerjumpto "Stored results" "findsj##results"}{viewerjumpto "Description" "findsj##description"}{...}{viewerjumpto "Description" "findsj##description"}{...}

{viewerjumpto "Author" "findsj##author"}

{title:Title}{viewerjumpto "Options" "findsj##options"}{...}{viewerjumpto "Options" "findsj##options"}{...}



{p2colset 5 16 18 2}{...}{viewerjumpto "Examples" "findsj##examples"}{...}{viewerjumpto "Examples" "findsj##examples"}{...}

{p2col :{cmd:findsj} {hline 2}}Search and cite articles from Stata Journal{p_end}

{p2colreset}{...}{viewerjumpto "Stored results" "findsj##results"}{...}{viewerjumpto "Stored results" "findsj##results"}{...}



{viewerjumpto "Author" "findsj##author"}{...}{viewerjumpto "Author" "findsj##author"}{...}

{marker syntax}{...}

{title:Syntax}{title:Title}{title:Title}



{p 8 15 2}

{cmd:findsj}

{it:keywords}{p2colset 5 16 18 2}{...}{p2colset 5 16 18 2}{...}

[{cmd:,} {it:options}]

{p2col :{cmd:findsj} {hline 2}}Search and cite articles from Stata Journal{p_end}{p2col :{cmd:findsj} {hline 2}}Search and cite articles from Stata Journal{p_end}

{p 8 15 2}

{cmd:findsj}{p2colreset}{...}{p2colreset}{...}

{cmd:,} {opt setpath(path)}



{p 8 15 2}

{cmd:findsj}

{cmd:,} {opt querypath}

{marker syntax}{...}{marker syntax}{...}

{p 8 15 2}

{cmd:findsj}{title:Syntax}{title:Syntax}

{cmd:,} {opt resetpath}



{synoptset 20 tabbed}{...}

{synopthdr}{p 8 15 2}{p 8 15 2}

{synoptline}

{syntab:Search scope}{cmd:findsj}{cmd:findsj}

{synopt :{opt author}}search by author name{p_end}

{synopt :{opt title}}search by article title{p_end}{it:keywords}{it:keywords}

{synopt :{opt keyword}}search by keywords (default){p_end}

[{cmd:,} {it:options}][{cmd:,} {it:options}]

{syntab:Export format}

{synopt :{opt markdown}}export citations in Markdown format{p_end}

{synopt :{opt latex}}export citations in LaTeX format{p_end}

{synopt :{opt tex}}export citations in LaTeX format (alias){p_end}{synoptset 20 tabbed}{...}{synoptset 20 tabbed}{...}

{synopt :{opt plain}}export citations in plain text format{p_end}

{synopthdr}{synopthdr}

{syntab:Output control}

{synopt :{opt noclip}}do not copy results to clipboard{p_end}{synoptline}{synoptline}

{synopt :{opt nobrowser}}do not display clickable links{p_end}

{synopt :{opt nopdf}}do not display PDF links{p_end}{syntab:Search scope}{syntab:Search scope}

{synopt :{opt nopkg}}do not display package links{p_end}

{synopt :{opt author}}search by author name{p_end}{synopt :{opt author}}search by author name{p_end}

{syntab:Display}

{synopt :{opt n(#)}}number of results to display (default: 10){p_end}{synopt :{opt title}}search by article title{p_end}{synopt :{opt title}}search by article title{p_end}

{synopt :{opt allresults}}display all search results{p_end}

{synopt :{opt keyword}}search by keywords (default){p_end}{synopt :{opt keyword}}search by keywords (default){p_end}

{syntab:Path management}

{synopt :{opt setpath(path)}}set custom download path{p_end}

{synopt :{opt querypath}}display current download path{p_end}

{synopt :{opt resetpath}}reset to default path{p_end}{syntab:Export format}{syntab:Export format}



{syntab:Other}{synopt :{opt markdown}}export citations in Markdown format to clipboard{p_end}{synopt :{opt markdown}}export citations in Markdown format{p_end}

{synopt :{opt getdoi}}retrieve and display DOI information (slower){p_end}

{synopt :{opt clear}}clear existing search results{p_end}{synopt :{opt latex}}export citations in LaTeX format to clipboard{p_end}{synopt :{opt latex}}export citations in LaTeX format{p_end}

{synopt :{opt debug}}enable debug mode{p_end}

{synoptline}{synopt :{opt tex}}export citations in LaTeX format to clipboard (alias){p_end}{synopt :{opt tex}}export citations in LaTeX format (alias){p_end}

{p2colreset}{...}

{synopt :{opt plain}}export citations in plain text format to clipboard{p_end}{synopt :{opt plain}}export citations in plain text format{p_end}



{marker description}{...}

{title:Description}

{syntab:Display}{syntab:Output control}

{pstd}

{cmd:findsj} searches for articles from the Stata Journal (SJ) and {synopt :{opt n(#)}}number of results to display (default: 5){p_end}{synopt :{opt noclip}}do not copy results to clipboard{p_end}

Stata Technical Bulletin (STB) by keywords, author names, or article 

titles. All article information is fetched directly from the Stata {synopt :{opt allresults}}display all search results{p_end}{synopt :{opt nobrowser}}do not display browser links{p_end}

Journal website in real-time, ensuring up-to-date results without 

requiring local data files.{synopt :{opt getdoi}}retrieve and display DOI information (slower){p_end}{synopt :{opt nodoi}}do not display DOI information{p_end}



{pstd}{synoptline}{synopt :{opt nopdf}}do not display PDF links{p_end}

The command displays article information including clickable links to:

{p2colreset}{...}{synopt :{opt nopkg}}do not display package installation commands{p_end}

{phang2}• Article pages and PDF downloads{p_end}

{phang2}• BibTeX and RIS citation downloads (cross-platform support){p_end}

{phang2}• Related Stata packages and software{p_end}

{phang2}• Google Scholar searches{p_end}{syntab:Display}



{pstd}{marker description}{...}{synopt :{opt n(#)}}number of results to display (default: 5){p_end}

Citations can be batch exported to clipboard in plain text, Markdown, 

or LaTeX formats for easy inclusion in your documents.{title:Description}{synopt :{opt allresults}}display all search results{p_end}



{pstd}

Version 1.1.0 introduces download path management and removes dependency 

on local data files. All searches are performed in real-time.{pstd}{syntab:Other}



{cmd:findsj} searches for articles from the Stata Journal (SJ) and {synopt :{opt clear}}clear existing search results{p_end}

{marker options}{...}

{title:Options}Stata Technical Bulletin (STB) by keywords, author names, or article {synopt :{opt debug}}enable debug mode{p_end}



{dlgtab:Search scope}titles. It displays article information including clickable links to:{synoptline}



{phang}{p2colreset}{...}

{opt author} searches by author name. Use this option when looking for 

articles by a specific author.{phang2}• Article pages and PDF downloads{p_end}



{phang}{phang2}• BibTeX and RIS citation downloads from Stata Journal{p_end}

{opt title} searches by article title. Use this option when you know 

part of the article title.{phang2}• Related Stata packages and software{p_end}{marker description}{...}



{phang}{phang2}• Google Scholar searches{p_end}{title:Description}

{opt keyword} searches by keywords in article content. This is the 

default search method.



{dlgtab:Export format}{pstd}{pstd}



{phang}Citations can be batch exported to clipboard in plain text, Markdown, {cmd:findsj} searches for articles from the Stata Journal (SJ) and 

{opt markdown} exports citations in Markdown format with clickable links.

Citations are automatically copied to clipboard unless {opt noclip} is specified.or LaTeX formats for easy inclusion in your documents.Stata Technical Bulletin (STB) by keywords, author names, or article 



{phang}titles. It displays article information including DOI, PDF links, and 

{opt latex} or {opt tex} exports citations in LaTeX format with 

hyperlinks. Citations are automatically copied to clipboard unless {opt noclip} related Stata packages. Citations can be exported in various formats 

is specified.

{marker options}{...}(Markdown, LaTeX, or plain text).

{phang}

{opt plain} exports citations in plain text format without links.{title:Options}

Citations are automatically copied to clipboard unless {opt noclip} is specified.



{dlgtab:Output control}

{dlgtab:Search scope}{marker options}{...}

{phang}

{opt noclip} prevents automatic copying of citations to clipboard when {title:Options}

using export formats.

{phang}

{phang}

{opt nobrowser} suppresses display of clickable browser links in {opt author} searches by author name. Use this option when looking for {dlgtab:Search scope}

Stata output.

articles by a specific author.

{phang}

{opt nopdf} suppresses display of PDF download links.{phang}



{phang}{phang}{opt author} searches by author name. Use this option when looking for 

{opt nopkg} suppresses display of package installation commands and 

software links.{opt title} searches by article title. Use this option when you know articles by a specific author.



{dlgtab:Display}part of the article title.



{phang}{phang}

{opt n(#)} specifies the number of search results to display. 

Default is 10. When combined with export options (plain/markdown/latex), {phang}{opt title} searches by article title. Use this option when you know 

only the first n results will be exported.

{opt keyword} searches by keywords in article content. This is the part of the article title.

{phang}

{opt allresults} displays all search results instead of limiting default search method.

to n results. When combined with export options, all results will be 

exported to clipboard.{phang}



{dlgtab:Path management}{dlgtab:Export format}{opt keyword} searches by keywords in article content. This is the 



{phang}default search method.

{opt setpath(path)} sets a custom directory path where BibTeX and RIS 

files will be downloaded. The path must exist and be writable. This {phang}

setting is persistent across Stata sessions. Use absolute paths.

{opt markdown} exports citations in Markdown format with clickable links {dlgtab:Export format}

{pmore}

Windows example: {cmd:findsj, setpath(D:\Citations)}and copies them to clipboard. Use this for Markdown documents, GitHub 



{pmore}README files, or Obsidian notes.{phang}

Mac/Linux example: {cmd:findsj, setpath(/Users/name/Documents/Citations)}

{opt markdown} exports citations in Markdown format with clickable links.

{phang}

{opt querypath} displays the current download path setting.{phang}



{phang}{opt latex} or {opt tex} exports citations in LaTeX format with {phang}

{opt resetpath} resets the download path to the default (current 

working directory).hyperlinks and copies them to clipboard. Use this for LaTeX documents {opt latex} or {opt tex} exports citations in LaTeX format with 



{dlgtab:Other}or academic papers.hyperlinks.



{phang}

{opt getdoi} retrieves DOI and page number information from the Stata 

Journal website in real-time. This option is slower but provides complete {phang}{phang}

citation information. DOI information is automatically retrieved when using 

export options (plain/markdown/latex).{opt plain} exports citations in plain text format and copies them to {opt plain} exports citations in plain text format without links.



{phang}clipboard. Use this for simple text documents or emails.

{opt clear} clears any existing search results before performing 

new search.{dlgtab:Output control}



{phang}{dlgtab:Display}

{opt debug} enables debug mode for troubleshooting.

{phang}



{marker examples}{...}{phang}{opt noclip} prevents automatic copying of citations to clipboard.

{title:Examples}

{opt n(#)} specifies the number of search results to display and export. 

    {hline}

{pstd}Basic keyword search (shows first 10 results){p_end}Default is 5. When combined with export options (plain/markdown/latex), {phang}

{phang2}{cmd:. findsj panel data}{p_end}

only the first n results will be copied to clipboard.{opt nobrowser} suppresses display of clickable browser links in 

    {hline}

{pstd}Search and show top 5 results{p_end}Stata output.

{phang2}{cmd:. findsj machine learning, n(5)}{p_end}

{phang}

    {hline}

{pstd}Search by author{p_end}{opt allresults} displays all search results instead of limiting {phang}

{phang2}{cmd:. findsj Baum, author}{p_end}

{phang2}{cmd:. findsj "David Roodman", author}{p_end}to n results. When combined with export options, all results will be {opt nodoi} suppresses display of DOI information.



    {hline}copied to clipboard.

{pstd}Search by title{p_end}

{phang2}{cmd:. findsj synthetic control, title}{p_end}{phang}



    {hline}{phang}{opt nopdf} suppresses display of PDF download links.

{pstd}Show all results{p_end}

{phang2}{cmd:. findsj boottest, author allresults}{p_end}{opt getdoi} retrieves DOI information from the Stata Journal website 



    {hline}in real-time. This option is slower but useful when DOI information {phang}

{pstd}Export citations in Markdown format{p_end}

{phang2}{cmd:. findsj propensity score, markdown n(5)}{p_end}is needed. DOI information is automatically retrieved when using export {opt nopkg} suppresses display of package installation commands.



    {hline}options (plain/markdown/latex).

{pstd}Export citations in LaTeX format{p_end}

{phang2}{cmd:. findsj difference-in-differences, latex}{p_end}{dlgtab:Display}



    {hline}

{pstd}Export in plain text{p_end}

{phang2}{cmd:. findsj regression, plain n(3)}{p_end}{marker examples}{...}{phang}



    {hline}{title:Examples}{opt n(#)} specifies the number of search results to display. 

{pstd}Search with DOI information{p_end}

{phang2}{cmd:. findsj causal inference, getdoi n(3)}{p_end}Default is 5.



    {hline}    {hline}

{pstd}Configure download path{p_end}

{phang2}{cmd:. findsj, setpath(D:\Citations)}{space 10}// Windows{p_end}{pstd}Basic keyword search (shows first 5 results){p_end}{phang}

{phang2}{cmd:. findsj, setpath(/Users/name/Documents/Citations)}{space 2}// Mac{p_end}

{phang2}{cmd:. findsj panel data}{p_end}{opt allresults} displays all search results instead of limiting 

    {hline}

{pstd}Check current download path{p_end}to n results.

{phang2}{cmd:. findsj, querypath}{p_end}

    {hline}

    {hline}

{pstd}Reset download path to default{p_end}{pstd}Search and show top 10 results{p_end}{dlgtab:Other}

{phang2}{cmd:. findsj, resetpath}{p_end}

{phang2}{cmd:. findsj panel data, n(10)}{p_end}

    {hline}

{phang}



{marker results}{...}    {hline}{opt clear} clears any existing search results before performing 

{title:Stored results}

{pstd}Search by author{p_end}new search.

{pstd}

{cmd:findsj} stores the following in {cmd:r()}:{phang2}{cmd:. findsj Baum, author}{p_end}



{synoptset 20 tabbed}{...}{phang2}{cmd:. findsj "David Roodman", author}{p_end}{phang}

{p2col 5 20 24 2: Scalars}{p_end}

{synopt:{cmd:r(n_results)}}number of articles found{p_end}{opt debug} enables debug mode for troubleshooting.



{synoptset 20 tabbed}{...}    {hline}

{p2col 5 20 24 2: Macros}{p_end}

{synopt:{cmd:r(keywords)}}search keywords{p_end}{pstd}Search by title{p_end}

{synopt:{cmd:r(scope)}}search scope (author/title/keyword){p_end}

{synopt:{cmd:r(url)}}search URL{p_end}{phang2}{cmd:. findsj panel data, title}{p_end}{marker examples}{...}

{synopt:{cmd:r(art_id_1)}}article ID of first result{p_end}

{synopt:{cmd:r(title_1)}}title of first result{p_end}{phang2}{cmd:. findsj synthetic control, title}{p_end}{title:Examples}

{synopt:{cmd:r(author_1)}}author of first result{p_end}

{synopt:{cmd:r(doi_1)}}DOI of first result (if available){p_end}

{synopt:{cmd:r(url_1)}}URL of first result{p_end}

{p2colreset}{...}    {hline}    {hline}



{pstd}Search with DOI information{p_end}{pstd}Basic keyword search{p_end}

{marker citation}{...}

{title:Citation downloads}{phang2}{cmd:. findsj panel data, n(5) getdoi}{p_end}{phang2}{cmd:. findsj panel data}{p_end}



{pstd}

For each search result, {cmd:findsj} displays clickable "Download BibTeX" 

and "Download RIS" buttons. These buttons execute platform-specific     {hline}    {hline}

scripts to download citation files:

{pstd}Export citations in plain text format (copies to clipboard){p_end}{pstd}Search by author{p_end}

{phang2}• {bf:Windows}: Uses PowerShell with proper Referer headers{p_end}

{phang2}• {bf:Mac/Linux}: Uses curl with proper Referer headers{p_end}{phang2}{cmd:. findsj panel data, n(5) plain}{p_end}{phang2}{cmd:. findsj "David Roodman", author}{p_end}



{pstd}

Downloaded files are saved to the configured download path (check with 

{cmd:findsj, querypath}). Files automatically open after download.    {hline}    {hline}



{pstd}{pstd}Export citations in Markdown format (copies to clipboard){p_end}{pstd}Search by title{p_end}

Citation files can be imported into reference management software like 

Zotero, Mendeley, EndNote, or used directly in LaTeX bibliographies.{phang2}{cmd:. findsj panel data, n(5) markdown}{p_end}{phang2}{cmd:. findsj synth, title}{p_end}





{marker technical}{...}

{title:Technical notes}    {hline}    {hline}



{pstd}{pstd}Export citations in LaTeX format (copies to clipboard){p_end}{pstd}Export in Markdown format{p_end}

{bf:Version 1.1.0 changes:}

{phang2}{cmd:. findsj difference-in-differences, n(5) latex}{p_end}{phang2}{cmd:. findsj regression, markdown n(3)}{p_end}

{phang2}• Removed dependency on local data files{p_end}

{phang2}• All article information fetched in real-time from Stata Journal website{p_end}

{phang2}• Added download path configuration (persistent across sessions){p_end}

{phang2}• Improved cross-platform download support{p_end}    {hline}    {hline}

{phang2}• Fixed BibTeX/RIS download with Referer header spoofing{p_end}

{phang2}• Changed default display from 5 to 10 results{p_end}{pstd}Export all results in Markdown format{p_end}{pstd}Export in LaTeX format{p_end}

{phang2}• Enhanced display format (title shown first){p_end}

{phang2}• Removed findsj_finddata and findsj_download_data subcommands{p_end}{phang2}{cmd:. findsj boottest, author allresults markdown}{p_end}{phang2}{cmd:. findsj "difference-in-differences", latex}{p_end}



{pstd}

{bf:System requirements:}

    {hline}

{phang2}• Stata 14.0 or higher{p_end}

{phang2}• Active internet connection{p_end}{marker results}{...}{pstd}Display more results{p_end}

{phang2}• Mac/Linux: curl (pre-installed on most systems){p_end}

{phang2}• Windows: PowerShell (built-in){p_end}{title:Stored results}{phang2}{cmd:. findsj panel, n(10)}{p_end}





{marker author}{...}

{title:Authors}{pstd}    {hline}



{pstd}Yujun Lian{p_end}{cmd:findsj} stores the following in {cmd:r()}:{pstd}Display all results{p_end}

{pstd}Sun Yat-sen University, Guangzhou, China{p_end}

{pstd}Email: {browse "mailto:arlionn@163.com":arlionn@163.com}{p_end}{phang2}{cmd:. findsj boottest, author allresults}{p_end}



{pstd}Chucheng Wan{p_end}{synoptset 20 tabbed}{...}

{pstd}Sun Yat-sen University, Guangzhou, China{p_end}

{pstd}Email: {browse "mailto:chucheng.wan@outlook.com":chucheng.wan@outlook.com}{p_end}{p2col 5 20 24 2: Scalars}{p_end}    {hline}



{pstd}GitHub: {browse "https://github.com/BlueDayDreeaming/findsj":https://github.com/BlueDayDreeaming/findsj}{p_end}{synopt:{cmd:r(n_results)}}number of articles found{p_end}{pstd}Search without clipboard{p_end}

{pstd}Gitee: {browse "https://gitee.com/ChuChengWan/findsj":https://gitee.com/ChuChengWan/findsj}{p_end}

{phang2}{cmd:. findsj "synthetic control", title noclip}{p_end}



{marker updates}{...}{synoptset 20 tabbed}{...}

{title:Version history}

{p2col 5 20 24 2: Macros}{p_end}

{pstd}

{bf:Version 1.1.0 (05nov2025):}{p_end}{synopt:{cmd:r(keywords)}}search keywords{p_end}{marker results}{...}

{phang2}• Major update: Removed local data file dependency{p_end}

{phang2}• All data now fetched in real-time from Stata Journal{p_end}{synopt:{cmd:r(scope)}}search scope (author/title/keyword){p_end}{title:Stored results}

{phang2}• Added download path management (setpath/querypath/resetpath){p_end}

{phang2}• Improved cross-platform BibTeX/RIS download support{p_end}{synopt:{cmd:r(url)}}search URL{p_end}

{phang2}• Fixed citation download with Referer header spoofing{p_end}

{phang2}• Changed default display to 10 results{p_end}{synopt:{cmd:r(format)}}export format (plain/markdown/latex){p_end}{pstd}

{phang2}• Enhanced display format{p_end}

{cmd:findsj} stores the following in {cmd:r()}:

{pstd}

{bf:Version 1.0.3 (22oct2025):}{p_end}{pstd}

{phang2}• Replaced copy buttons with download links{p_end}

{phang2}• Removed findsj_copy subcommand{p_end}For each result i (i=1,2,3,...):{synoptset 20 tabbed}{...}

{phang2}• Added automatic DOI retrieval for exports{p_end}

{p2col 5 20 24 2: Scalars}{p_end}

{pstd}

{bf:Version 1.0.2 (20oct2025):}{p_end}{synopt:{cmd:r(art_id_}{it:i}{cmd:)}}}article ID{p_end}{synopt:{cmd:r(n_results)}}number of articles found{p_end}

{phang2}• Added citation copy functionality{p_end}

{phang2}• Improved search results display{p_end}{synopt:{cmd:r(title_}{it:i}{cmd:)}}}article title{p_end}



{pstd}{synopt:{cmd:r(author_}{it:i}{cmd:)}}}author names{p_end}{synoptset 20 tabbed}{...}

{bf:Version 1.0.1 (18oct2025):}{p_end}

{phang2}• Initial release{p_end}{synopt:{cmd:r(issue_}{it:i}{cmd:)}}}journal volume and issue{p_end}{p2col 5 20 24 2: Macros}{p_end}



{synopt:{cmd:r(doi_}{it:i}{cmd:)}}}DOI (when getdoi is used){p_end}{synopt:{cmd:r(keywords)}}search keywords{p_end}

{title:Also see}

{synopt:{cmd:r(url_}{it:i}{cmd:)}}}article URL{p_end}{synopt:{cmd:r(scope)}}search scope (author/title/keyword){p_end}

{psee}

Online: {helpb search}, {helpb net}, {helpb ssc}{p2colreset}{...}{synopt:{cmd:r(url)}}search URL{p_end}

{p_end}

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
