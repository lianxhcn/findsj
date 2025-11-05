*! findsj version 1.0.4  2025/11/05
*! Authors: Yujun Lian (arlionn@163.com), Chucheng Wan (chucheng.wan@outlook.com)
*! Search Stata Journal and Stata Technical Bulletin articles

cap program drop findsj
program define findsj, rclass
version 14

syntax [anything(name=keywords id="keywords")] [, ///
    Author Title Keyword ///
    Markdown Latex TEX Plain  ///
    NOCLIP NOBrowser NOPDF NOPkg ///
    N(integer 10) ALLresults ///
    GETDOI ///
    Clear Debug ///
    SETPath(string) QUERYpath RESETpath ///
    ]

* Handle download path configuration subcommands
if "`querypath'" != "" | "`resetpath'" != "" | "`setpath'" != "" {
    local config_file "`c(sysdir_personal)'findsj_config.txt"
    
    * Query current path
    if "`querypath'" != "" {
        capture confirm file "`config_file'"
        if _rc == 0 {
            tempname fh
            file open `fh' using "`config_file'", read text
            file read `fh' line
            file close `fh'
            local saved_path = strtrim("`line'")
            if "`saved_path'" != "" {
                dis as result "Current download path: " as text "`saved_path'"
            }
            else {
                dis as result "Current download path: " as text "`c(pwd)'" as text " (default)"
            }
        }
        else {
            dis as result "Current download path: " as text "`c(pwd)'" as text " (default)"
        }
        exit
    }
    
    * Reset to default
    if "`resetpath'" != "" {
        capture erase "`config_file'"
        dis as result "Download path reset to default (current working directory)"
        dis as text "Use " as result "findsj ..., setpath(path)" as text " to set a custom download path"
        exit
    }
    
    * Set new path
    if "`setpath'" != "" {
        * Try to change to the directory as validation
        local current_dir = c(pwd)
        quietly capture cd "`setpath'"
        if _rc != 0 {
            dis as error "Directory does not exist: `setpath'"
            exit 601
        }
        quietly cd "`current_dir'"
        
        * Save path to config file
        tempname fh
        file open `fh' using "`config_file'", write replace
        file write `fh' "`setpath'"
        file close `fh'
        
        dis as result "Download path set to: " as text "`setpath'"
        dis as text "This setting will be remembered for future sessions."
        exit
    }
}

if "`debug'" != "" set trace on
if "`tex'" != "" local latex "latex"

* Read download path from config file
local config_file "`c(sysdir_personal)'findsj_config.txt"
local download_path ""
capture confirm file "`config_file'"
if _rc == 0 {
    tempname fh
    file open `fh' using "`config_file'", read text
    file read `fh' line
    file close `fh'
    local download_path = strtrim("`line'")
}
* Use current directory as default if no config or empty config
if "`download_path'" == "" {
    local download_path "`c(pwd)'"
}

local keywords = strtrim(`"`keywords'"')   
local keywords = stritrim(`"`keywords'"')
if wordcount(`"`keywords'"') > 1 {
    local keywords_url = subinstr(`"`keywords'"', " ", "+", .)
}
else {
    local keywords_url `"`keywords'"'
}

local args_scope "`author' `title' `keyword'"
local num_scope = wordcount("`args_scope'")
if `num_scope' > 1 {
    dis as error "Specify only one: author, title, or keyword"
    exit 198
}
if `num_scope' == 0 local scope "keyword"
else {
    if "`author'" != "" local scope "author"
    if "`title'"  != "" local scope "title"
    if "`keyword'"!= "" local scope "keyword"
}

local args_export "`markdown' `latex' `plain'"
local num_export = wordcount("`args_export'")
if `num_export' > 1 {
    dis as error "Specify only one export format: markdown, latex, or plain"
    exit 198
}

* Auto-enable getdoi when export format is specified
if `num_export' > 0 {
    local getdoi "getdoi"
}

dis _n as text "{hline 60}"
dis as text "  Searching Stata Journal articles..."
dis as text "  Keywords: " as result "`keywords'"
dis as text "  Search by: " as result "`scope'"
if `num_export' > 0 dis as text "  Export format: " as result "`args_export'"
dis as text "{hline 60}" _n

preserve 
qui {
    tempfile sj_search_result
    local url_sj "https://www.stata-journal.com/sjsearch.html?choice=`scope'&q=`keywords_url'"
    
    cap copy "`url_sj'" "`sj_search_result'.txt", replace
    if _rc {
        noi dis as error "Failed to connect to Stata Journal website."
        noi dis as error "Please check your internet connection."
        restore
        exit 631
    }
    
    * Use import delimited for better encoding handling
    cap import delimited "`sj_search_result'.txt", delim("@#@") clear varnames(nonames) stringcols(_all)
    if _rc {
        * Fallback to infix if import delimited fails
        cap infix strL v 1-20000 using "`sj_search_result'.txt", clear
        if _rc {
            noi dis as error "Failed to parse search results."
            noi dis as error "Error code: " _rc
            restore
            exit 198
        }
    }
    else {
        * Rename first variable to v for consistency
        rename v1 v
    }
    
    * Clean the data
    cap drop if v == ""
    keep if regexm(v, ".*<d[td]>.*")
    if _N == 0 {
        noi dis as error "No articles found matching: `keywords'"
        noi dis as text "Try different keywords or search scope."
        restore
        exit
    }
    
    * Extract article information from HTML
    findsj_strget v, gen(art_id) begin(`"article="') end(`"">"')
    findsj_strget v, gen(title) begin(`"">"') end(`"</a></dt>"')
    
    * Extract author and year (first <dd> tag after <dt>)
    gen author_year_raw = ""
    gen n = _n
    forvalues i = 1/`=_N' {
        if art_id[`i'] != "" & `i' < _N {
            if regexm(v[`i'+1], "<dd>(.+)</dd>") {
                qui replace author_year_raw = regexs(1) in `i'
            }
        }
    }
    drop n
    
    * Extract volume and number from HTML (second <dd> tag)
    gen volume_html = ""
    gen number_html = ""
    gen n = _n
    forvalues i = 1/`=_N' {
        if art_id[`i'] != "" & `i' < _N - 1 {
            if regexm(v[`i'+2], "Volume ([0-9]+) Number ([0-9]+)") {
                qui replace volume_html = regexs(1) in `i'
                qui replace number_html = regexs(2) in `i'
            }
        }
    }
    drop n
    
    * Extract year from author_year_raw (format: "Author. Year.")
    gen year_from_html = ""
    replace year_from_html = regexs(1) if regexm(author_year_raw, "\.[ ]*([0-9]{4})\.[ ]*$")
    
    * Clean up extracted data - remove year from author string
    gen author = regexr(author_year_raw, "\.[ ]*[0-9]{4}\.[ ]*$", ".")
    replace author = strtrim(author)
    replace author = author[_n+1] if author == "" & author[_n+1] != ""
    drop author_year_raw
    
    drop v 
    keep if art_id != ""
    gen selected = 1
    local n_results = _N
}  // Temporarily exit qui block for user messages

dis as text "Found " as result `n_results' as text " article(s)."

qui {  // Resume qui block
    * Check for optional data file (provides DOI and page numbers)
    local fn_sj ""
    cap findsj_finddata
    if _rc == 0 local fn_sj `"`r(fn)'"'
}  // Temporarily exit qui block for download messages

* If data file not found, try to download from GitHub or Gitee
if `"`fn_sj'"' == "" {
    dis as text "→ Data file not found. Attempting to download..."
    cap findsj_download_data
    if _rc == 0 {
        local fn_sj `"`r(fn)'"'
        dis as text "→ Data file downloaded successfully."
    }
    else {
        dis as text "→ Could not download data file. Will fetch DOI in real-time if needed."
    }
}

qui {  // Resume qui block
    * Use HTML-extracted data as primary source
    * Data file (if available) provides supplementary info (DOI, page numbers)
    gen volume = volume_html
    gen number = number_html
    gen year = year_from_html
    gen volnum_str = volume + "(" + number + ")" if volume != "" & volume != "."
    gen volnum_url = volume + "-" + number if volume != "" & volume != "."
    
    * Initialize optional fields
    gen doi = ""
    gen page = ""
    gen volnum = real(volume + "." + number) if volume != "" & volume != "."
    
    * If data file exists, merge to get DOI and page numbers
    local has_datafile = 0
    if `"`fn_sj'"' != "" {
        merge 1:1 art_id using `"`fn_sj'"', nogen keep(match master)
        * Data file provides DOI and page, but volume/number from HTML are preferred
        replace doi = "" if doi == "."
        replace page = "" if page == "."
        * Check if data file has useful information
        qui count if doi != "" | page != ""
        if r(N) > 0 local has_datafile = 1
    }
    
    keep if selected == 1
    
    * Check if title and author variables exist and clean
    cap confirm variable title
    if _rc == 0 {
        drop if missing(title) | title == "" | title == "."
    }
    else {
        noi dis as error "Failed to extract article titles from search results."
        noi dis as text "Please try again or check your internet connection."
        restore
        exit 198
    }
    
    cap confirm variable author
    if _rc == 0 {
        drop if missing(author) | author == "" | author == "."
    }
    else {
        * If author is missing, create placeholder
        gen author = "Author information not available"
    }
    
    local n_results = _N
    if `n_results' == 0 {
        noi dis as error "No valid articles with complete information."
        restore
        exit
    }
    
    local url_base "https://www.stata-journal.com/article.html?article="
    gen url_html = "`url_base'" + art_id
    
    local url_pdf_base "https://journals.sagepub.com/doi/pdf/"
    gen url_pdf = "`url_pdf_base'" + doi if doi != "" & doi != "."
    
    * Page string for display
    gen page_str = ": " + page if page != "" & page != "."
    replace page_str = "" if page_str == ": ."
    
    if "`markdown'" != "" {
        gen cite_text = author + " (" + year + "). " + title + ". " + ///
                        "_Stata Journal_ " + volnum_str + page_str + ". " + ///
                        "[Link](" + url_html + ")"
        if "`nopdf'" == "" cap replace cite_text = cite_text + " [PDF](" + url_pdf + ")" if url_pdf != ""
    }
    else if "`latex'" != "" {
        gen cite_text = author + " (" + year + "). " + title + ". " + ///
                        "\textit{Stata Journal} " + volnum_str + page_str + ". " + ///
                        "\href{" + url_html + "}{Link}"
        if "`nopdf'" == "" cap replace cite_text = cite_text + " \href{" + url_pdf + "}{PDF}" if url_pdf != ""
    }
    else if "`plain'" != "" {
        gen cite_text = author + " (" + year + "). " + title + ". " + ///
                        "Stata Journal " + volnum_str + page_str + "."
    }
    else {
        gen cite_text = author + " (" + year + "). " + title + ". " + ///
                        "Stata Journal " + volnum_str + page_str + "."
    }
}

local total_results = _N
if "`allresults'" != "" local n_display = `total_results'
else local n_display = min(`n', `total_results')

dis _n as text "{hline 60}"
dis as text "  Search Results (Showing `n_display' of `total_results')"
dis as text "{hline 60}" _n

* Save and increase line size to prevent wrapping
local old_linesize = c(linesize)
quietly set linesize 255

local n = `n_display'
forvalues i = 1/`n' {
    local volnum_i  = volnum_str[`i']
    local author_i  = author[`i']
    local title_i   = title[`i']
    local year_i    = year[`i']
    local art_id_i  = art_id[`i']
    local url_html_i = url_html[`i']
    
    * Clean HTML entities in title for display
    local title_display = `"`title_i'"'
    local title_display = subinstr(`"`title_display'"', "&amp;", "&", .)
    local title_display = subinstr(`"`title_display'"', "&ndash;", "-", .)
    local title_display = subinstr(`"`title_display'"', "&mdash;", "--", .)
    local title_display = subinstr(`"`title_display'"', "&lt;", "<", .)
    local title_display = subinstr(`"`title_display'"', "&gt;", ">", .)
    local title_display = subinstr(`"`title_display'"', "&quot;", `"""', .)
    
    * First line: Article number and title (use smcl to prevent wrapping)
    dis as text "{p 0 0 0}[" as result `i' as text "] " as result `"`title_display'"' as text "{p_end}"
    
    * Second line: Author, year, and journal info
    dis as text "{p 4 4 4}" as result "`author_i'" as text " (" as result "`year_i'" as text "). " ///
        as text "_Stata Journal_" _c
    if "`volnum_i'" != "" & "`volnum_i'" != "." {
        dis as text " " as result "`volnum_i'" _c
    }
    
    cap local page_i = page[`i']
    if "`page_i'" != "" & "`page_i'" != "." {
        dis as text ": " as result "`page_i'" _c
    }
    dis as text "{p_end}"
    
    * Get DOI and page info from data file or fetch real-time
    cap local doi_i = doi[`i']
    local has_doi = 0
    if "`doi_i'" != "" & "`doi_i'" != "." {
        local has_doi = 1
    }
    
    * Fetch DOI only if getdoi option is specified (unless already in data file)
    if `has_doi' == 0 & "`getdoi'" != "" {
        qui {
            cap findsj_doi `art_id_i'
            if _rc == 0 {
                local doi_i = r(doi)
                local page_i = r(page)
                if "`doi_i'" != "" & "`doi_i'" != "." {
                    local has_doi = 1
                }
            }
        }
    }
    
    if "`nobrowser'" == "" {
        dis as text "    " _c
        dis as text `"{browse "`url_html_i'":Article page}"' _c
        
        * Display PDF link - use sjpdf.html (works without DOI)
        if "`nopdf'" == "" {
            local url_pdf_i "https://www.stata-journal.com/sjpdf.html?articlenum=`art_id_i'"
            dis as text " | " _c
            dis as text `"{browse "`url_pdf_i'":[PDF]}"' _c
        }
        
        * Display Google Scholar link
        local title_search = subinstr(`"`title_i'"', " ", "+", .)
        local title_search = subinstr(`"`title_search'"', "&amp;", "%26", .)
        local title_search = subinstr(`"`title_search'"', "&ndash;", "-", .)
        local url_google "https://scholar.google.com/scholar?q=`title_search'"
        dis as text " | " _c
        dis as text `"{browse "`url_google'":[Google]}"' _c
        
        * Add package search and software links on same line
        if "`nopkg'" == "" {
            dis as text " | " _c
            dis as text `"{stata "search `art_id_i'":Search package}"' _c
            * Only show Browse SJ software link if volume/number info is available
            cap local volnum_url_i = volnum_url[`i']
            cap local volume_i = volume[`i']
            if _rc == 0 & "`volume_i'" != "" & "`volume_i'" != "." {
                dis as text " | " _c
                dis as text `"{stata "net from http://www.stata-journal.com/software/sj`volnum_url_i'":Browse software}"' _c
            }
        }
        
        * Continue on same line - no line break yet
    }
    
    * Display DOI as plain text in a separate line (only if getdoi was used)
    if "`getdoi'" != "" & `has_doi' == 1 {
        dis ""  // End the button line first
        dis as text "    DOI: " as result "`doi_i'"
    }
    
    * Display citation download links (BibTeX and RIS)
    local url_article "https://www.stata-journal.com/article.html?article=`art_id_i'"
    local url_bibtex "https://www.stata-journal.com/ris.php?articlenum=`art_id_i'&abs=1&type=bibtex"
    local url_ris "https://www.stata-journal.com/ris.php?articlenum=`art_id_i'&abs=1&type=ris"
    local file_bib "`art_id_i'.bib"
    local file_ris "`art_id_i'.ris"
    
    * Detect OS and set appropriate script extension
    if "`c(os)'" == "MacOSX" | "`c(os)'" == "Unix" {
        local script_ext "sh"
        local script_file_bib "_download_`art_id_i'_bib.sh"
        local script_file_ris "_download_`art_id_i'_ris.sh"
    }
    else {
        local script_ext "ps1"
        local script_file_bib "_download_`art_id_i'_bib.ps1"
        local script_file_ris "_download_`art_id_i'_ris.ps1"
    }
    
    if "`debug'" != "" {
        noi dis as text "DEBUG: art_id_i = `art_id_i'"
        noi dis as text "DEBUG: url_article = `url_article'"
        noi dis as text "DEBUG: url_bibtex = `url_bibtex'"
        noi dis as text "DEBUG: url_ris = `url_ris'"
        noi dis as text "DEBUG: OS = `c(os)', script_ext = `script_ext'"
    }
    
    * Create download scripts (PowerShell for Windows, shell script for Mac/Unix)
    * Create download scripts (PowerShell for Windows, shell script for Mac/Unix)
    quietly {
        tempname fh
        
        * Use configured download path (defined at program start)
        local full_file_bib "`download_path'/`file_bib'"
        local full_file_ris "`download_path'/`file_ris'"
        
        if "`c(os)'" == "MacOSX" | "`c(os)'" == "Unix" {
            * Shell script for BibTeX (Mac/Unix with curl)
            file open `fh' using "`script_file_bib'", write replace
            file write `fh' "#!/bin/bash" _n
            file write `fh' "curl -H 'Referer: `url_article'' \" _n
            file write `fh' "     -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36' \" _n
            file write `fh' "     -o '`full_file_bib'' \" _n
            file write `fh' "     '`url_bibtex''" _n
            file write `fh' "if [ -f '`full_file_bib'' ]; then" _n
            file write `fh' `"    echo -e "\033[32mDownloaded: `full_file_bib'\033[0m""' _n
            file write `fh' `"    echo """' _n
            file write `fh' `"    echo -e "\033[36mTo change future download path:\033[0m""' _n
            file write `fh' `"    echo -e "\033[33m  findsj, setpath(/your/path)  -- Set new path\033[0m""' _n
            file write `fh' `"    echo -e "\033[33m  findsj, querypath              -- Check current path\033[0m""' _n
            file write `fh' `"    echo -e "\033[33m  findsj, resetpath              -- Reset to default\033[0m""' _n
            file write `fh' "    open '`full_file_bib''" _n
            file write `fh' "else" _n
            file write `fh' `"    echo -e "\033[31mDownload failed!\033[0m""' _n
            file write `fh' "fi" _n
            file close `fh'
            
            * Make script executable
            shell chmod +x "`script_file_bib'"
            
            * Shell script for RIS (Mac/Unix with curl)
            file open `fh' using "`script_file_ris'", write replace
            file write `fh' "#!/bin/bash" _n
            file write `fh' "curl -H 'Referer: `url_article'' \" _n
            file write `fh' "     -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36' \" _n
            file write `fh' "     -o '`full_file_ris'' \" _n
            file write `fh' "     '`url_ris''" _n
            file write `fh' "if [ -f '`full_file_ris'' ]; then" _n
            file write `fh' `"    echo -e "\033[32mDownloaded: `full_file_ris'\033[0m""' _n
            file write `fh' `"    echo """' _n
            file write `fh' `"    echo -e "\033[36mTo change future download path:\033[0m""' _n
            file write `fh' `"    echo -e "\033[33m  findsj, setpath(/your/path)  -- Set new path\033[0m""' _n
            file write `fh' `"    echo -e "\033[33m  findsj, querypath              -- Check current path\033[0m""' _n
            file write `fh' `"    echo -e "\033[33m  findsj, resetpath              -- Reset to default\033[0m""' _n
            file write `fh' "    open '`full_file_ris''" _n
            file write `fh' "else" _n
            file write `fh' `"    echo -e "\033[31mDownload failed!\033[0m""' _n
            file write `fh' "fi" _n
            file close `fh'
            
            * Make script executable
            shell chmod +x "`script_file_ris'"
        }
        else {
            * PowerShell script for BibTeX (Windows)
            file open `fh' using "`script_file_bib'", write replace
            file write `fh' "$" "headers = @{" _n
            file write `fh' "    'Referer' = '`url_article''" _n
            file write `fh' "    'User-Agent' = 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36'" _n
            file write `fh' "}" _n
            file write `fh' "Invoke-WebRequest -Uri '`url_bibtex'' -Headers $" "headers -OutFile '`full_file_bib''" _n
            file write `fh' "if (Test-Path '`full_file_bib'') {" _n
            file write `fh' "    Write-Host " `"""' "Downloaded: `full_file_bib'" `"""' " -ForegroundColor Green" _n
            file write `fh' "    Write-Host " `"""' "" `"""' _n
            file write `fh' "    Write-Host " `"""' "To change future download path:" `"""' " -ForegroundColor Cyan" _n
            file write `fh' "    Write-Host " `"""' "  findsj, setpath(d:\your\path)  -- Set new path" `"""' " -ForegroundColor Yellow" _n
            file write `fh' "    Write-Host " `"""' "  findsj, querypath              -- Check current path" `"""' " -ForegroundColor Yellow" _n
            file write `fh' "    Write-Host " `"""' "  findsj, resetpath              -- Reset to default" `"""' " -ForegroundColor Yellow" _n
            file write `fh' "    Start-Process '`full_file_bib''" _n
            file write `fh' "} else {" _n
            file write `fh' "    Write-Host " `"""' "Download failed!" `"""' " -ForegroundColor Red" _n
            file write `fh' "}" _n
            file close `fh'
            
            * PowerShell script for RIS (Windows)
            file open `fh' using "`script_file_ris'", write replace
            file write `fh' "$" "headers = @{" _n
            file write `fh' "    'Referer' = '`url_article''" _n
            file write `fh' "    'User-Agent' = 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36'" _n
            file write `fh' "}" _n
            file write `fh' "Invoke-WebRequest -Uri '`url_ris'' -Headers $" "headers -OutFile '`full_file_ris''" _n
            file write `fh' "if (Test-Path '`full_file_ris'') {" _n
            file write `fh' "    Write-Host " `"""' "Downloaded: `full_file_ris'" `"""' " -ForegroundColor Green" _n
            file write `fh' "    Write-Host " `"""' "" `"""' _n
            file write `fh' "    Write-Host " `"""' "To change future download path:" `"""' " -ForegroundColor Cyan" _n
            file write `fh' "    Write-Host " `"""' "  findsj, setpath(d:\your\path)  -- Set new path" `"""' " -ForegroundColor Yellow" _n
            file write `fh' "    Write-Host " `"""' "  findsj, querypath              -- Check current path" `"""' " -ForegroundColor Yellow" _n
            file write `fh' "    Write-Host " `"""' "  findsj, resetpath              -- Reset to default" `"""' " -ForegroundColor Yellow" _n
            file write `fh' "    Start-Process '`full_file_ris''" _n
            file write `fh' "} else {" _n
            file write `fh' "    Write-Host " `"""' "Download failed!" `"""' " -ForegroundColor Red" _n
            file write `fh' "}" _n
            file close `fh'
        }
    }
    
    * Create shell commands based on OS
    if "`c(os)'" == "MacOSX" | "`c(os)'" == "Unix" {
        local dl_bib "!bash `script_file_bib'"
        local dl_ris "!bash `script_file_ris'"
    }
    else {
        local dl_bib "!powershell -ExecutionPolicy Bypass -File `script_file_bib'"
        local dl_ris "!powershell -ExecutionPolicy Bypass -File `script_file_ris'"
    }
    
    * Add Download BibTeX and RIS to the same button line
    dis as text " | " _c
    dis as text `"{stata `dl_bib':Download BibTeX}"' _c
    dis as text " | " _c
    dis as text `"{stata `dl_ris':Download RIS}"'
    dis ""  // Now end the button line
    
}

* Restore original line size
quietly set linesize `old_linesize'

* Save total number of displayed results
global findsj_n_display `n_display'

if `total_results' > `n_display' {
    dis _n as text "{hline 60}"
    dis as text "  Showing " as result "`n_display'" as text " of " as result "`total_results'" as text " results."
    dis as text "  To see all results, add option: " as result "allresults"
    dis as text "  Example: " `"{stata "findsj `keywords', allresults":findsj `keywords', allresults}"'
    dis as text "{hline 60}"
}

if `num_export' > 0 & "`noclip'" == "" {
    local export_text ""
    forvalues i = 1/`n_display' {
        local cite_i = cite_text[`i']
        local export_text `"`export_text'`cite_i'"'
        if `i' < `n_display' local export_text `"`export_text'`=char(10)'`=char(10)'"'
    }
    
    cap findsj_clipout `"`export_text'"'
    if _rc == 0 {
        dis _n as text "→ Citations copied to clipboard in " as result "`args_export'" as text " format."
        if `n_display' < `total_results' {
            dis as text "  (Copied " as result "`n_display'" as text " of " as result "`total_results'" as text " results. Use " as result "allresults" as text " to copy all)"
        }
    }
}

return local keywords   = "`keywords'"
return local scope      = "`scope'"
return local url        = "`url_sj'"
return scalar n_results = `n_results'

if `n_results' > 0 {
    return local art_id_1  = art_id[1]
    return local title_1   = title[1]
    return local author_1  = author[1]
    cap return local doi_1 = doi[1]
    return local url_1     = url_html[1]
}

restore

dis _n as text "{hline 60}"
dis as text "  Search completed. Found " as result `n_results' as text " article(s)."
if "`nobrowser'" == "" {
    dis as text "  To view full search results online: " _c
    dis as text `"{browse "`url_sj'":Open in browser}"'
}
dis as text "{hline 60}" _n

if "`debug'" != "" set trace off

end

*==========================================
* SUB-PROGRAMS
*==========================================

cap program drop findsj_strget   
program define findsj_strget, rclass 
version 14 
  syntax varname, Generate(string) [Begin(string) Endwith(string) Match(string) Jthmatch(integer 1)]
  
  cap noi confirm new variable `generate'
  if `jthmatch' < 0 {
      dis as error "'#' in -jthmatch(#)- must be nonnegative."
      exit 198
  }
  if `"`match'"' == "" local match ".*"
  local regex `"(?<=`begin')(`match')(?=`endwith')"'  
  qui gen `generate' = ustrregexs(`jthmatch') if ustrregexm(`varlist', `"`regex'"') 
  qui count if `generate'!=""
  if r(N) == 0 dis `"Note: nothing matched. Try different patterns."'
end   

cap program drop findsj_finddata
program define findsj_finddata, rclass
version 14
   args fname 
   if `"`fname'"' == "" local fname = "sjget_data_sj.dta"	
   
   * First priority: current directory and user's working directory
   * Second priority: system adopath directories
   cap findfile `"`fname'"', path(`".;`c(pwd)';`c(adopath)'"')
   if _rc {
       * Silently return error - caller will handle
       exit 601
   }
   else{
       local fn_find `"`r(fn)'"'
       preserve 
       qui use `"`fn_find'"', clear 
       qui cap destring volume number, gen(vol_int num_int)
       if _rc == 0 {
           gsort -vol_int -num_int
           local vol = volume[1]
           local num = number[1]
           local volnum_loc = `vol'.`num'
       }
       else {
           local vol = volume[1]
           local num = number[1]
           local volnum_loc = 0
       }
       restore 
       return local fn = `"`fn_find'"'
       return scalar vol = `vol'
       return scalar num = `num'
       return scalar vn = `volnum_loc'		
   }
end 

cap program drop findsj_current
program define findsj_current, rclass
version 14
qui {
preserve
  tempvar v VolNum vol num volnum
  tempname matrix_vn 
  local fn "sjarchive"
  local url_fn "https://www.stata-journal.com/archives/"    
  cap copy "`url_fn'" "`fn'.txt", replace
  if _rc == 0 {
      infix strL `v' 1-1000 using "`fn'.txt", clear
      local begin   `"<b><a href="/sj"'
      local endwith `".html"'
      local regex `"(?<=`begin')(.*)(?=`endwith')"'  
      gen `VolNum' = ustrregexs(1) if ustrregexm(`v', `"`regex'"')
      keep if `VolNum' != "" 
      if _N > 0 {
          split `VolNum', parse("-") destring
          gen `volnum' = `VolNum'1 + `VolNum'2/10
          mkmat `VolNum'1 `VolNum'2 `volnum', mat(`matrix_vn')  
          mat colnames `matrix_vn' = vol num volnum
          return matrix all = `matrix_vn'
          qui keep in 1
          local volnum_str = `VolNum'[1]
          tokenize `volnum_str', parse(-)
          return local volnum "`volnum_str'"
          return scalar vol = `1'
          return scalar num = `3'
          return scalar vn  = `=`1'.`3''
      }
  }
restore
}
end

cap program drop findsj_clipout
program define findsj_clipout
version 8.0 
    args text_to_clipboard
    tempfile cliptemp
    tempname fh
    qui {
        file open `fh' using "`cliptemp'", write text replace
        file write `fh' `"`text_to_clipboard'"'
        file close `fh'
    }
    
    * Detect OS and use appropriate clipboard command
    if "`c(os)'" == "Windows" {
        cap !type "`cliptemp'" | clip
    }
    else if "`c(os)'" == "MacOSX" {
        cap !cat "`cliptemp'" | pbcopy
    }
    else {
        dis as text "Note: Clipboard operation only supported on Windows and Mac"
        dis as text "You can manually copy the text displayed above"
        exit
    }
    
    if _rc == 0 dis as text "Citations copied to clipboard. Press Ctrl+V (Cmd+V on Mac) to paste"
    else {
        dis as text "Note: Clipboard operation failed"
        dis as text "You can manually copy the text displayed above"
    }
end

cap program drop findsj_doi   
program define findsj_doi, rclass
version 14
args art_id
preserve 
qui {
  local art_url "https://www.stata-journal.com/article.html?article=`art_id'"
  tempfile sj_art
  copy "`art_url'"  "`sj_art'.txt" , replace   
  tempvar v
  infix strL `v' 1-1000 using "`sj_art'.txt", clear
  keep if regexm(`v', "^pp.") | strpos(`v',"doi/pdf/") 
  local regex `"(?<=doi/pdf/)(.*)(?=">)"' 
  gen doi  = ustrregexs(1) if ustrregexm(`v', `"`regex'"')
  replace doi = "." if doi==""
  local regex `"(?<=pp. )(.*)(?=</span)"' 
  gen page = ustrregexs(1) if ustrregexm(`v', `"`regex'"')
  local doi  =  doi[2]
  local page = page[1]
  ret local id  = "`art_id'"
  ret local doi = "`doi'"
  ret local page= "`page'"
}
restore 
end

cap program drop findsj_volnum
program define findsj_volnum, rclass
version 14
  syntax, Volume(integer) Number(integer) [More]
preserve 
qui{	
  local vol = `volume'
  local num = `number'
  local sjlink "https://www.stata-journal.com/sj"
  local url "`sjlink'`vol'-`num'.html" 
  local fn "sj`vol'_`num'"
  tempfile sjFILE
  copy "`url'"  "`sjFILE'.txt" , replace
  infix strL v 1-1000 using "`sjFILE'.txt", clear
  keep if regexm(v, ".*<d[td]>.*")
  findsj_strget v, gen(title)  begin(`"">"')     end(`"</a></dt>"')
  findsj_strget v, gen(author) begin(`"<dd>"')   end(`"</dd>"')
  findsj_strget v, gen(DOI)    begin("doi/pdf/") end(`"">"') 
  replace author = author[_n+1] if author==""
  drop if title == ""
  replace author = "" if author=="&nbsp;"
  if "`more'" !=""{
  	  gen year   = 2000 + `vol' 
  	  gen volume = `vol'
	  gen number = `num'
  } 
  drop v
  save "`fn'.dta", replace	
  return scalar vol = `vol'      
  return scalar num = `num'      
  return local data = "`fn'.dta" 
}
restore  
end

cap program drop findsj_frmark
program define findsj_frmark
version 16 
  qui pwf
  global Frame__User__ = r(currentframe)
end

cap program drop findsj_frback
program define findsj_frback
version 16
  cap frame change $Frame__User__
  if _rc {
  	  dis as error "Nothing to back. Use {help findsj_frmark} first."
	  exit
  }
  macro drop Frame__User__
end

cap program drop findsj_sjarchive
program define findsj_sjarchive, rclass
version 14
  syntax [, Saving(string)]
preserve 
qui{	
  tempfile sjarc 
  local url "https://www.stata-journal.com/archives/"    
  copy "`url'"  "`sjarc'.txt" , replace
  infix strL v 1-1000 using "`sjarc'.txt", clear
  local begin `"<b><a href="/sj"'
  local end   `".html"'
  local match ".*"
  local regex `"(?<=`begin')(`match')(?=`end')"'  
  qui gen VolNum = ustrregexs(1) if ustrregexm(v, `"`regex'"') 
  keep if VolNum != "" 
  split VolNum, parse(-) gen(x) destring
  rename (x1 x2) (vol num)
  drop v	
  return local archive "https://www.stata-journal.com/archives/"
  return local sjurl "https://www.stata-journal.com/sj"
  qui gsort -vol -num
  return scalar vol = vol[1]
  return scalar num = num[1]
  return local volnum = VolNum[1]
  if "`saving'" != "" save "`saving'.dta", replace 
}
restore  
end

cap program drop findsj_data_id
program define   findsj_data_id, rclass
version 14
syntax [, Savepwd Filename(string)]
preserve 
qui{
  tempname sj_search 
  local url_sj "https://www.stata-journal.com/sjsearch.html?choice=title&q="
  copy "`url_sj'"           "`sj_search'.txt" , replace
  infix strL v 1-1000 using "`sj_search'.txt", clear
  keep if regexm(v, ".*<d[td]>.*")
  findsj_strget v, gen(title)  begin(`"">"')    end(`"</a></dt>"')
  findsj_strget v, gen(author) begin(`"<dd>"')  end(`"\.\s[0-9]{4}\.</dd>"')
  findsj_strget v, gen(volume) begin(`"Volume "') match([\d]{1,2})
  findsj_strget v, gen(number) begin(`"Number "') match([\d]{1})  
  findsj_strget v, gen(art_id) begin(`"article="') end(`"">"')
  drop v 
  egen tag = tag(art_id)
  gen id = sum(tag)
  bysort id: replace author = author[_n+1] if author[_n]==""
  bysort id: replace volume = volume[_n+2] if volume[_n]==""
  bysort id: replace number = number[_n+2] if number[_n]==""
  keep if tag==1
  drop tag 
  gen volnum = real(volume + "." + number)
  if `"`filename'"' == "" local filename "sj_data_id"
  else local filename = subinstr("`filename'", ".dta", "", .)
  if "`savepwd'" != "" save "`filename'.dta", replace 
  else save "`c(sysdir_plus)'s/`filename'.dta", replace
  cap noi erase "`sj_search'.txt"
}
restore 
end

cap program drop findsj_add_data
program define findsj_add_data, rclass
version 14
syntax, From(string) 
  tempfile sj_tempdata 
  local vn_local = "`from'"
  findsj_data_id, save file("`sj_tempdata'")
  use "`sj_tempdata'.dta", clear
  qui keep if volnum> `vn_local'
  local N = _N	
  qui gen doi  = ""
  qui gen page = "" 
  forvalues i=1/`N'{
  	local art_id = art_id[`i']
	qui findsj_doi `art_id'
  	qui replace doi  = r(doi)  in `i'	
  	qui replace page = r(page) in `i'
  	if mod(`i',3)==0 dis _c "." 	
  } 
  qui findsj_finddata
  local fn `"`r(fn)'"'
  qui append using `"`fn'"'
  qui duplicates drop doi, force 
  qui format title author doi %-20s
  qui format volume number %4s
  qui format art_id page %10s
  qui save `"`fn'"', replace 	
  local vn_old = subinstr("`from'", ".", "-",1)
  qui sum volnum
  local vn_new = subinstr("`r(max)'", ".", "-",1)
  dis _n "Update finished: " _c
  dis _c in yellow "SJ `vn_old'" as text " --> " in y "SJ `vn_new'"  
  return local vn  = r(max)
  return local vn_old = `vn_old'
  return local vn_new = `vn_new'
end

cap program drop findsj_compact_name
program define findsj_compact_name, rclass
version 8
syntax varlist(min=1) [, Add(string) Back Symbol(string) Generate(string)] 
foreach var of varlist `varlist'{
  if "`generate'" == "" {
      local genrep "replace"
	  local varname "`var'"
  }
  else{
	  cap noi confirm new variable `generate'
	  if _rc exit 198
	  else{
	  	local genrep  "generate"
		local varname "`generate'"
	  }
  } 	
	if `'"`symbol'"' == "" local symbol "~_~"
	if "`back'" != ""{
		local nchanges = 0	
		qui `genrep' `varname' = subinstr(`var', `"`symbol'"', " ", .)
		qui count if strpos(`var', `"`symbol'"')
		local nchanges = `nchanges' + r(N)		
		exit 
	}
    #delimit ;
    local list `"
	 "van de" "von der" von van de mc mac la "st." st "`add'"
     "'  ;
    #delimit cr	
	local nchanges = 0
    foreach name in `list'{
        qui `genrep' `varname' = subinstr(`var', " `name' ", `" `name'`symbol'"', .)
		qui count if strpos(`var', "`name'")
		local nchanges = `nchanges' + `r(N)'
    }	
	dis "(`nchanges' real changes made)"
	return scalar N = `nchanges'
}	
end

cap program drop findsj_author_name_abb  
program define findsj_author_name_abb, rclass
  syntax varname [, SJformat Order(integer 1) Suffix(string) REPLACE]
  if "`suffix'" == "" local suffix "_full"
  else{
	  cap qui confirm new variable `varlist'`suffix' 
	  if _rc{
	  	  dis as error "Invalid suffix. Use only [0-9], _, or letters"
		  exit 198
	  }
  } 
qui{ 
  tempvar var 
  clonevar `var' = `varlist'
  findsj_compact_name `var'  
  gen   `var'_wordcount = wordcount(`var')
  gen   `var'_rev = ustrreverse(`var')
  split `var'_rev, parse(" ")
  qui sum `var'_wordcount
  local max_length = r(max)
  forvalues j = 2/`max_length'{
  	  replace `var'_rev`j' = ustrreverse(`var'_rev`j')
	  replace `var'_rev`j' = substr(`var'_rev`j',1,1) + "." ///
	          if strpos(`var'_rev`j', ".")==0 & `var'_rev`j' != "" & ///
				 ustrregexm(substr(`var'_rev`j',1,1), "[A-Z]")
  }
  tempvar `var'_Last  `var'_rest
  replace `var'_rev1 = ustrreverse(`var'_rev1)
  rename  `var'_rev1 `var'_Last
  gen      `var'_rest = `var'_rev3 if `var'_rev3 != ""
  gen str1 `var'_blank = cond(`var'_wordcount>=3, " ", "")
  replace  `var'_rest = `var'_rest + `var'_blank + `var'_rev2 
  gen `var'`suffix' = ""
  if "`sjformat'" != "" & `order' != 1 replace `var'`suffix' = `var'_rest + " " + `var'_Last 
  else replace `var'`suffix' = `var'_Last + " " + `var'_rest
  findsj_compact_name `var'_full, back
  if "`replace'" == "" gen `varlist'`suffix' = `var'`suffix'
  else replace `varlist' = `var'`suffix'
  drop `var'_wordcount `var'_rev* `var'_Last  `var'_rest  `var'`suffix'  
}  
end 


*===============================================================================
* findsj_download_data: Download optional data file from GitHub or Gitee
*===============================================================================
program define findsj_download_data, rclass
    version 14.0
    
    * Define URLs for the data file
    local github_url "https://raw.githubusercontent.com/BlueDayDreeaming/findsj/main/sjget_data_sj.dta"
    local gitee_url "https://gitee.com/ChuChengWan/findsj/raw/main/sjget_data_sj.dta"
    
    * Determine download location (PERSONAL directory)
    local download_path "`c(sysdir_personal)'"
    
    * Create directory if it doesn't exist
    cap mkdir "`download_path'"
    
    local dest_file "`download_path'sjget_data_sj.dta"
    
    * Try GitHub first
    noi dis as text "   Trying GitHub..."
    cap copy "`github_url'" "`dest_file'", replace
    
    if _rc == 0 {
        * Verify the file is valid
        cap use "`dest_file'", clear
        if _rc == 0 {
            clear
            return local fn "`dest_file'"
            exit 0
        }
        else {
            * File downloaded but invalid, try Gitee
            noi dis as text "   GitHub file invalid, trying Gitee..."
        }
    }
    else {
        noi dis as text "   GitHub failed, trying Gitee..."
    }
    
    * Try Gitee as fallback
    cap copy "`gitee_url'" "`dest_file'", replace
    
    if _rc == 0 {
        * Verify the file is valid
        cap use "`dest_file'", clear
        if _rc == 0 {
            clear
            return local fn "`dest_file'"
            exit 0
        }
        else {
            noi dis as error "   Downloaded file is invalid."
            exit 198
        }
    }
    else {
        noi dis as error "   Both GitHub and Gitee download failed."
        exit 631
    }
end


