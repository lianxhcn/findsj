{smcl}
{* *! version 1.4.0  12nov2025}
{viewerjumpto "Syntax" "findsj##syntax"}
{viewerjumpto "Description" "findsj##description"}
{viewerjumpto "Options" "findsj##options"}
{viewerjumpto "Examples" "findsj##examples"}
{viewerjumpto "Database Updates" "findsj##update"}
{viewerjumpto "Stored results" "findsj##results"}
{viewerjumpto "Author" "findsj##author"}
{title:Title}

{p2colset 5 16 18 2}{...}
{p2col :{cmd:findsj} {hline 2}}Search Stata Journal and Stata Technical Bulletin articles{p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 15 2}
{cmd:findsj}
{it:keywords}
[{cmd:,} {it:options}]

{p 8 15 2}
{cmd:findsj, update source}({it:source}) {hline 2} Update article database


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

{syntab:Citation}
{synopt :{opt ref}}retrieve and display DOI information, enable citation copy{p_end}
{synopt :{opt getdoi}}fetch real-time DOI from Stata Journal website (slower){p_end}

{syntab:Output control}
{synopt :{opt nobrowser}}do not display clickable links{p_end}
{synopt :{opt nopdf}}do not display PDF links{p_end}
{synopt :{opt nopkg}}do not display package links{p_end}

{syntab:Path management}
{synopt :{opt setpath(path)}}set custom download path for BibTeX and RIS files{p_end}
{synopt :{opt querypath}}display current download path{p_end}
{synopt :{opt resetpath}}reset to default path{p_end}

{syntab:Database management}
{synopt :{opt update source}({it:source})}update article database from specified source{p_end}

{syntab:Other}
{synopt :{opt clear}}clear existing search results{p_end}
{synopt :{opt debug}}enable debug mode{p_end}
{synoptline}
{p2colreset}{...}


{marker description}{...}
{title:Description}

{pstd}
{cmd:findsj} searches the Stata Journal (SJ) and Stata Technical Bulletin (STB) for articles 
matching specified keywords, author names, or titles. It provides clickable links to article pages, 
PDFs, and direct installation commands for user-written programs. The command can also retrieve 
digital object identifiers (DOI) and display formatted citations that are automatically copied to clipboard.

{pstd}
Starting from version 1.4.0, {cmd:findsj} includes a database management system. Use the {opt update} 
option with {opt source}() to keep your local article index fresh. The database is stored locally, 
so searches are instant even without internet access (after initial population).


{marker options}{...}
{title:Options}

{dlgtab:Search scope}

{phang}
{opt author} searches for articles by author name.

{phang}
{opt title} searches for articles by article title.

{phang}
{opt keyword} searches for articles by keywords. This is the default search method when no scope is specified.

{dlgtab:Display}

{phang}
{opt n(#)} specifies the number of search results to display. The default is 10. 
Useful for limiting output or exploring results.

{phang}
{opt allresults} displays all search results without limit, instead of restricting to the {opt n(#)} threshold.

{dlgtab:Citation}

{phang}
{opt ref} retrieves DOI information and enables the citation copy feature. 
For each article found, DOI numbers are displayed as clickable links. Clicking on a DOI will copy 
the article citation to your clipboard with a message: "Tips: Text is on clipboard. Press 'Ctrl+V' to paste, ^-^"

{phang}
{opt getdoi} fetches real-time DOI information from the Stata Journal website. This option is slower 
because it queries the website for each article. Use this when you need the most current DOI information 
or when the local database may be out of date.

{dlgtab:Output control}

{phang}
{opt nobrowser} disables clickable links in the output. Article titles and DOI numbers will be 
displayed as plain text, not as clickable elements.

{phang}
{opt nopdf} hides PDF download links in the search results.

{phang}
{opt nopkg} hides package installation links (ado-files) in the search results.

{dlgtab:Path management}

{phang}
{opt setpath(path)} sets a custom download directory for BibTeX and RIS citation files. 
The path setting is saved in {cmd:`c(sysdir_personal)'findsj_config.txt} 
and will be remembered for future Stata sessions. Example: {cmd:findsj ..., setpath(D:/MyPapers)}

{phang}
{opt querypath} displays the current download path setting. Useful for checking where files will be saved.

{phang}
{opt resetpath} resets the download path to the default (current working directory).

{dlgtab:Database management}

{phang}
{opt update source}({it:source}) updates the local article database. {it:source} can be:

{p 12 16 2}
{bf:github} {hline 2} Download from GitHub (recommended for international users with stable connections){p_end}

{p 12 16 2}
{bf:gitee} {hline 2} Download from Gitee (recommended for users in China; faster within China){p_end}

{p 12 16 2}
{bf:both} {hline 2} Try GitHub first; if it fails, automatically retry with Gitee{p_end}

{pstd}
Examples:

{p 8 12 2}
{cmd:. findsj, update source(github)}{p_end}

{p 8 12 2}
{cmd:. findsj, update source(gitee)}{p_end}

{p 8 12 2}
{cmd:. findsj, update source(both)}{p_end}

{dlgtab:Other}

{phang}
{opt clear} clears the current search results in memory before performing a new search.

{phang}
{opt debug} enables debug mode, showing detailed trace information during execution. 
Useful for troubleshooting.


{marker examples}{...}
{title:Examples}

{pstd}{bf:Basic search}

{phang}{cmd:. findsj panel}{p_end}
{phang2}Search for articles about "panel" methods using keyword search{p_end}

{phang}{cmd:. findsj "fixed effects", n(20)}{p_end}
{phang2}Search for "fixed effects" and display 20 results{p_end}

{pstd}{bf:Search by author or title}

{phang}{cmd:. findsj Angrist, author}{p_end}
{phang2}Search for articles authored by "Angrist"{p_end}

{phang}{cmd:. findsj "difference-in-differences", title}{p_end}
{phang2}Search for articles with "difference-in-differences" in the title{p_end}

{pstd}{bf:Display options}

{phang}{cmd:. findsj regression, allresults}{p_end}
{phang2}Display all results for "regression", not just the first 10{p_end}

{phang}{cmd:. findsj areg, nopdf}{p_end}
{phang2}Search for "areg" but hide PDF links in results{p_end}

{pstd}{bf:Citation and DOI}

{phang}{cmd:. findsj panel, ref}{p_end}
{phang2}Search for "panel" and display DOI links. Click any DOI to copy the citation to clipboard{p_end}

{phang}{cmd:. findsj "time series", getdoi}{p_end}
{phang2}Search for "time series" and fetch real-time DOI information from the website{p_end}

{pstd}{bf:Download path management}

{phang}{cmd:. findsj, querypath}{p_end}
{phang2}Display the current download path for citation files{p_end}

{phang}{cmd:. findsj matching, setpath(D:/Papers)}{p_end}
{phang2}Set download path to D:/Papers and search for articles about "matching"{p_end}

{phang}{cmd:. findsj, resetpath}{p_end}
{phang2}Reset download path to default (current working directory){p_end}

{pstd}{bf:Database updates}

{phang}{cmd:. findsj, update source(github)}{p_end}
{phang2}Update the local article database from GitHub{p_end}

{phang}{cmd:. findsj, update source(gitee)}{p_end}
{phang2}Update the database from Gitee (faster for users in mainland China){p_end}

{phang}{cmd:. findsj, update source(both)}{p_end}
{phang2}Attempt database update from GitHub; if it fails, automatically retry with Gitee{p_end}


{marker update}{...}
{title:Database Updates}

{pstd}
The local article database is the foundation of {cmd:findsj}. Starting with version 1.4.0, 
you can periodically update it to include the latest Stata Journal articles. Use the {opt update} 
option with {opt source}() to control where the database is downloaded from.

{pstd}{bf:Update sources}

{p 12 16 2}
{cmd:findsj, update source(github)} {hline 2} Download from GitHub (stable, international){p_end}

{p 12 16 2}
{cmd:findsj, update source(gitee)} {hline 2} Download from Gitee (faster in mainland China){p_end}

{p 12 16 2}
{cmd:findsj, update source(both)} {hline 2} Try GitHub first; on failure, retry with Gitee{p_end}

{pstd}{bf:When to update}

{p 8 12 2}• After installation: Update to populate the database with articles{p_end}

{p 8 12 2}• Periodically: Run the update every few weeks to include newly published articles{p_end}

{p 8 12 2}• When experiencing issues: If search results seem incomplete, update may help{p_end}

{pstd}{bf:Update behavior}

{pstd}
The update process:

{p 8 12 2}1. Connects to the specified source (GitHub/Gitee){p_end}

{p 8 12 2}2. Downloads the latest article database file{p_end}

{p 8 12 2}3. Replaces the local database{p_end}

{p 8 12 2}4. Displays a success message with the source name{p_end}

{pstd}
If the selected source fails and you specified {opt source(both)}, 
{cmd:findsj} automatically retries with the alternative source. Updates are cumulative; 
the new database includes all articles from the previous version plus new additions.


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
Yujun Lian (连玉君){break}
Lingnan College, Sun Yat-Sen University{break}
Email: {browse "mailto:arlionn@163.com":arlionn@163.com}

{pstd}
Chucheng Wan (万楚呈){break}
Email: {browse "mailto:chucheng.wan@outlook.com":chucheng.wan@outlook.com}


{marker also_see}{...}
{title:Also see}

{psee}
Online: {help getiref} (if installed)
{p_end}

{psee}
Related: {help search}
{p_end}


{marker version_history}{...}
{title:Version History}

{pstd}
{bf:v1.4.0 (12 Nov 2025):} Added {opt update source}() option for database management. 
Simplified update syntax from {opt updatesource}() to {opt source}(). 
Support for GitHub and Gitee sources with automatic fallback.

{pstd}
{bf:v1.3.0:} Direct integration with {cmd:getiref}; clicking citation formats calls {cmd:getiref} with DOI.

{pstd}
{bf:v1.2.0:} Simplified to single {opt ref} option with three format buttons.

{pstd}
{bf:v1.1.1:} Added individual citation copy button for each article.

{pstd}
{bf:v1.1.0:} Removed local data file dependency; all information fetched online.
