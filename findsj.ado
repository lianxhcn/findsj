*! findsj version 1.4.0  2025/11/12
*! Authors: Yujun Lian (arlionn@163.com), Chucheng Wan (chucheng.wan@outlook.com)
*! Search Stata Journal and Stata Technical Bulletin articles
*! v1.4.0: Auto-check for database updates (monthly reminder with download option)
*! v1.3.0: Direct getiref integration - click .md/.latex/.txt calls getiref with DOI
*! v1.2.0: Simplified to single 'ref' option with three format buttons
*! v1.1.1: Added individual "Ref" button for each article to copy citation
*! v1.1.0: Removed local data file dependency, all info fetched online

*===============================================================================
* Helper program: findsj_download (defined first to be available for buttons)
* Download BibTeX or RIS file on-demand when user clicks the button
*===============================================================================
cap program drop findsj_download
program define findsj_download
    version 14
    syntax anything(name=artid), Type(string) [DOWNloadpath(string)]
    
    * Set download path (use global if set, otherwise current directory)
    if "`downloadpath'" == "" {
        if "$findsj_download_path" != "" {
            local downloadpath "$findsj_download_path"
        }
        else {
            local downloadpath "`c(pwd)'"
        }
    }
    
    * Build URL based on article ID and type
    if "`type'" == "bib" {
        local url "https://www.stata-journal.com/ris.php?articlenum=`artid'&abs=1&type=bibtex"
    }
    else if "`type'" == "ris" {
        local url "https://www.stata-journal.com/ris.php?articlenum=`artid'&abs=1&type=ris"
    }
    else {
        dis as error "Error: type must be 'bib' or 'ris'"
        exit 198
    }
    
    * Determine file extension
    local file_ext = cond("`type'"=="bib", "bib", "ris")
    local file_name "`artid'.`file_ext'"
    local full_file "`downloadpath'/`file_name'"
    local url_article "https://www.stata-journal.com/article.html?article=`artid'"
    
    * Generate unique temp script file name in system temp directory
    local script_file "`c(tmpdir)'_findsj_dl_`artid'_`type'.`=cond("`c(os)'"=="Windows","ps1","sh")'"
    
    * Create and execute download script
    quietly {
        tempname fh
        
        if "`c(os)'" == "MacOSX" | "`c(os)'" == "Unix" {
            * Unix/Mac shell script with curl
            local full_file_esc = subinstr("`full_file'", `"""', `"\""', .)
            local full_file_esc = subinstr("`full_file_esc'", "$", "\$", .)
            local full_file_esc = subinstr("`full_file_esc'", "`", "\`", .)
            
            file open `fh' using "`script_file'", write replace
            file write `fh' "#!/bin/bash" _n
            file write `fh' "OUTPUT_FILE=" `"""' "`full_file_esc'" `"""' _n
            file write `fh' "curl -sSL -H 'Referer: `url_article'' -H 'User-Agent: Mozilla/5.0' -o " `"""' "$" "{OUTPUT_FILE}" `"""' " '`url'' > /dev/null 2>&1" _n
            file write `fh' "if [ -f " `"""' "$" "{OUTPUT_FILE}" `"""' " ] && [ -s " `"""' "$" "{OUTPUT_FILE}" `"""' " ]; then" _n
            file write `fh' "    echo " `"""' "Downloaded: $" "{OUTPUT_FILE}" `"""' _n
            file write `fh' "    open " `"""' "$" "{OUTPUT_FILE}" `"""' " > /dev/null 2>&1" _n
            file write `fh' "else" _n
            file write `fh' "    echo " `"""' "Download failed" `"""' " >&2" _n
            file write `fh' "fi" _n
            file write `fh' "rm -f " `"""' "`script_file'" `"""' " > /dev/null 2>&1" _n
            file close `fh'
            
            shell chmod +x "`script_file'" > /dev/null 2>&1
            shell bash "`script_file'" &
        }
        else {
            * Windows PowerShell script
            file open `fh' using "`script_file'", write replace
            file write `fh' "$" "headers = @{" _n
            file write `fh' "    'Referer' = '`url_article''" _n
            file write `fh' "    'User-Agent' = 'Mozilla/5.0'" _n
            file write `fh' "}" _n
            file write `fh' "try {" _n
            file write `fh' "    Invoke-WebRequest -Uri '`url'' -Headers $" "headers -OutFile '`full_file''" _n
            file write `fh' "    if (Test-Path '`full_file'') {" _n
            file write `fh' "        Write-Host 'Downloaded: `full_file'' -ForegroundColor Green" _n
            file write `fh' "        Start-Process '`full_file''" _n
            file write `fh' "    } else {" _n
            file write `fh' "        Write-Host 'Download failed!' -ForegroundColor Red" _n
            file write `fh' "    }" _n
            file write `fh' "} finally {" _n
            file write `fh' "    Remove-Item -Path '`script_file'' -Force -ErrorAction SilentlyContinue" _n
            file write `fh' "}" _n
            file close `fh'
            
            shell powershell -ExecutionPolicy Bypass -File "`script_file'"
        }
    }
    
    * Display download information in Results window
    dis as text "Downloading " as result "`file_ext'" as text " file for article " as result "`artid'" as text "..."
    dis as text "Save location: " as result `"{browse "`downloadpath'":`downloadpath'}"'
    dis as text "File name: " as result "`file_name'"
end

*===============================================================================
* Main program: findsj
*===============================================================================
cap program drop findsj
program define findsj, rclass
version 14

syntax [anything(name=keywords id="keywords")] [, ///
    Author Title Keyword ///
    REF  ///
    NOBrowser NOPDF NOPkg ///
    N(integer 10) ALLresults ///
    GETDOI ///
    Clear Debug ///
    SETPath(string) QUERYpath RESETpath ///
    UPdate source(string) ///
    Type(string) ///
    CLS ///
    MD TEXT TEX ///
    from(string) to(string) ///
    ]

* Handle CLS option
if "`cls'" != "" {
    cls
}

* Check for updates (once per day)
findsj_check_update

* Handle download subcommand (findsj artid, type(bib|ris))
if "`type'" != "" {
    if "`type'" != "bib" & "`type'" != "ris" {
        dis as error "Error: type must be 'bib' or 'ris'"
        exit 198
    }
    findsj_download `keywords', type(`type')
    exit
}

* Handle database update subcommand
if "`update'" != "" {
    * Use source if specified, otherwise empty (will show usage)
    findsj_update_db "`source'"
    exit
}

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

* Auto-enable getdoi when ref option is specified
if "`ref'" != "" {
    local getdoi "getdoi"
}

* Check format options conflicts
local format_opts "`md' `text' `tex'"
if wordcount("`format_opts'") > 1 {
    dis as error "Error: Only one format option (md, text, or tex) is allowed"
    exit 198
}

* Set output format
local output_format ""
if "`md'" != "" {
    local output_format "markdown"
}
else if "`text'" != "" {
    local output_format "text"
}
else if "`tex'" != "" {
    local output_format "latex"
}

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

* Check if findsj.dta exists, if not and ref option is used, show one-time reminder
local dta_found = 0
local search_paths "`c(pwd)' `c(sysdir_personal)' `c(sysdir_plus)' `c(sysdir_plus)'f"
foreach p of local search_paths {
    capture confirm file "`p'/findsj.dta"
    if _rc == 0 {
        local dta_found = 1
        continue, break
    }
}

if `dta_found' == 0 & "`ref'" != "" {
    dis as text _n "{hline 70}"
    dis as text " " as result "Notice:" as text " Local database (findsj.dta) not found."
    dis as text " DOI information will be fetched online (may be slower)."
    dis as text _n " For faster performance, update the database:"
    dis as text "   {stata findsj, update source(github):findsj, update source(github)}  " as text "(international users)"
    dis as text "   {stata findsj, update source(gitee):findsj, update source(gitee)}   " as text "(China users, faster)"
    dis as text "   {stata findsj, update source(both):findsj, update source(both)}    " as text "(auto fallback)"
    dis as text "{hline 70}" _n
}

dis _n as text "  Searching ... " _c

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
    local n_results_before_time = _N
    
    * Calculate how many results to display (will be updated after time filtering)
    if "`allresults'" != "" local n_display = `n_results_before_time'
    else local n_display = min(`n', `n_results_before_time')
}  // Temporarily exit qui block for user messages

* Create clickable link to show all results (will be updated if time filtering is applied)
local url_sj "https://www.stata-journal.com/sjsearch.html?choice=`scope'&q=`keywords_url'"

qui {  // Resume qui block
    * Use HTML-extracted data as primary source
    gen volume = volume_html
    gen number = number_html
    gen year = year_from_html
    gen volnum_str = volume + "(" + number + ")" if volume != "" & volume != "."
    gen volnum_url = volume + "-" + number if volume != "" & volume != "."
    
    * Initialize optional fields (will be fetched on-demand if getdoi is specified)
    gen doi = "."
    gen page = "."
    gen volnum = real(volume + "." + number) if volume != "" & volume != "."
    
    * Time range filtering (from/to options)
    if "`from'" != "" | "`to'" != "" {
        * Parse from date (format: YYYY-N, e.g., 2023-1)
        if "`from'" != "" {
            local from_clean = subinstr("`from'", "-", ".", .)
            local from_val = real("`from_clean'")
        }
        else {
            local from_val = 0  // No lower bound
        }
        
        * Parse to date (format: YYYY-N, e.g., 2024-1)
        if "`to'" != "" {
            local to_clean = subinstr("`to'", "-", ".", .)
            local to_val = real("`to_clean'")
        }
        else {
            local to_val = 9999  // No upper bound
        }
        
        * Filter by time range
        if "`from'" != "" & "`to'" != "" {
            keep if volnum >= `from_val' & volnum <= `to_val'
        }
        else if "`from'" != "" {
            keep if volnum >= `from_val'
        }
        else if "`to'" != "" {
            keep if volnum <= `to_val'
        }
        
        * Update result count after time filtering
        local n_results_after_time = _N
        local time_filtered = 1
    }
    else {
        local n_results_after_time = _N
        local time_filtered = 0
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
    
    * Clean art_id by manually encoding BOM characters to avoid double encoding
    gen art_id_clean = art_id
    qui replace art_id_clean = subinstr(art_id_clean, "ï»¿", "%EF%BB%BF", .)
    
    local url_base "https://www.stata-journal.com/article.html?article="
    gen url_html = "`url_base'" + art_id_clean
    
    local url_pdf_base "https://journals.sagepub.com/doi/pdf/"
    gen url_pdf = "`url_pdf_base'" + doi if doi != "" & doi != "."
    
    * Page string for display
    gen page_str = ": " + page if page != "" & page != "."
    replace page_str = "" if page_str == ": ."
    
    * Generate title with auto-wrap support for Results Window display
    * Using {browse "URL":"text"} format for automatic line wrapping
    local title_br `"{browse ""' + url_html + `"":"' + title + `"}"'
    
    * Generate formatted output strings based on output_format
    if "`output_format'" == "markdown" {
        * Markdown format: - Author, Year, [title](URL), Stata Journal Vol(No): pages
        gen _title_link = "[" + title + "](" + url_html + ")"
        gen _title_link_br = "[" + `"`title_br'"' + "](" + url_html + ")"
        gen _journal_info = ", Stata Journal " + volnum_str if volnum_str != "" & volnum_str != "."
        replace _journal_info = _journal_info + page_str if page_str != ""
        replace _journal_info = "" if _journal_info == "."
        gen _OutputStr = "- " + author + ", " + year + ", " + _title_link + _journal_info
        gen _OutputDis = "- " + author + ", " + year + ", " + _title_link_br + _journal_info
    }
    else if "`output_format'" == "latex" {
        * LaTeX format: - Author, Year, \href{URL}{title}, Stata Journal Vol(No): pages
        gen _title_link = "\href{" + url_html + "}{" + title + "}"
        gen _title_link_br = "\href{" + url_html + "}{" + `"`title_br'"' + "}"
        gen _journal_info = ", Stata Journal " + volnum_str if volnum_str != "" & volnum_str != "."
        replace _journal_info = _journal_info + page_str if page_str != ""
        replace _journal_info = "" if _journal_info == "."
        gen _OutputStr = "- " + author + ", " + year + ", " + _title_link + _journal_info
        gen _OutputDis = "- " + author + ", " + year + ", " + _title_link_br + _journal_info
    }
    else if "`output_format'" == "text" {
        * Plain text format: Author, Year, title, URL, Stata Journal Vol(No): pages
        gen _journal_info = ", Stata Journal " + volnum_str if volnum_str != "" & volnum_str != "."
        replace _journal_info = _journal_info + page_str if page_str != ""
        replace _journal_info = "" if _journal_info == "."
        gen _OutputStr = author + ", " + year + ", " + title + ", " + url_html + _journal_info
        gen _OutputDis = author + ", " + year + ", " + `"`title_br'"' + ", " + url_html + _journal_info
    }
}

local total_results = _N
if "`allresults'" != "" local n_display = `total_results'
else local n_display = min(`n', `total_results')

* Display search summary with appropriate message
if `time_filtered' == 1 {
    * Time filtering was applied - show filtered results
    dis as text "Showing " as result "`n_display'" as text " of " as result "`total_results'" as text " articles" _c
    dis as text " (filtered from " as result "`n_results_before_time'" as text " total)" _n
}
else {
    * No time filtering - show link to full online results
    dis as text "Showing " as result "`n_display'" as text " of " `"{browse "`url_sj'":`total_results' articles}"' _n
}

* Display time range if from/to options are used
if "`from'" != "" | "`to'" != "" {
    dis as text "  Time range: " _c
    if "`from'" != "" & "`to'" != "" {
        dis as result "SJ `from'" as text " to " as result "SJ `to'" _n
    }
    else if "`from'" != "" {
        dis as result "from SJ `from'" _n
    }
    else {
        dis as result "up to SJ `to'" _n
    }
}

* Save and increase line size to prevent wrapping
local old_linesize = c(linesize)
quietly set linesize 255

local n = `n_display'
forvalues i = 1/`n' {
    * For formatted output, use the pre-generated display string with auto-wrap
    if "`output_format'" != "" {
        local output_dis = _OutputDis[`i']
        dis `"`output_dis'"'
    }
    else {
        * Default format: Original display style
        local volnum_i  = volnum_str[`i']
        local author_i  = author[`i']
        local title_i   = title[`i']
        local year_i    = year[`i']
        local art_id_i  = art_id[`i']
        local art_id_clean_i = art_id_clean[`i']
        local url_html_i = url_html[`i']
        
        * Create BOM-free version for Stata commands (search, etc.)
        local art_id_nobom = subinstr("`art_id_i'", "ï»¿", "", .)
        
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
            as text "Stata Journal" _c
        if "`volnum_i'" != "" & "`volnum_i'" != "." {
            dis as text " " as result "`volnum_i'" _c
        }
        
        cap local page_i = page[`i']
        if "`page_i'" != "" & "`page_i'" != "." {
            dis as text ": " as result "`page_i'" _c
        }
        dis as text "{p_end}"
    }
    
    * Skip the rest for formatted output
    if "`output_format'" != "" {
        continue
    }
    
    * Get article info for default format links
    local volnum_i  = volnum_str[`i']
    local author_i  = author[`i']
    local title_i   = title[`i']
    local year_i    = year[`i']
    local art_id_i  = art_id[`i']
    local art_id_clean_i = art_id_clean[`i']
    local url_html_i = url_html[`i']
    local art_id_nobom = subinstr("`art_id_i'", "ï»¿", "", .)
    
    * Get DOI and page info from data file or fetch real-time
    cap local doi_i = doi[`i']
    local has_doi = 0
    if "`doi_i'" != "" & "`doi_i'" != "." {
        local has_doi = 1
    }

    * Priority 1: try to find DOI in a local `findsj.dta' by matching art_id
    * Try several likely locations: current working directory, personal plus, and system plus
    if `has_doi' == 0 {
        qui {
            * Clean art_id for matching (remove BOM if present)
            local art_id_match = subinstr("`art_id_i'", "ï»¿", "", .)
            
            local search_paths "`c(pwd)' `c(sysdir_personal)' `c(sysdir_plus)' `c(sysdir_plus)'f"
            foreach p of local search_paths {
                capture confirm file "`p'/findsj.dta"
                if _rc == 0 & `has_doi' == 0 {
                    * Use frame to avoid nested preserve issue (Stata 16+)
                    * Generate unique frame name to avoid conflicts
                    local framename = "findsj_temp_" + string(floor(runiform()*100000))
                    capture {
                        frame create `framename'
                        frame `framename': use "`p'/findsj.dta", clear
                        * Check if artid or art_id variable exists
                        frame `framename' {
                            cap confirm variable artid
                            if _rc == 0 {
                                qui keep if artid == "`art_id_match'"
                                if _N > 0 {
                                    cap local doi_tmp = DOI[1]
                                    if _rc != 0 cap local doi_tmp = doi[1]
                                    if "`doi_tmp'" != "" & "`doi_tmp'" != "." {
                                        local doi_i = "`doi_tmp'"
                                        local has_doi = 1
                                    }
                                }
                            }
                            else {
                                cap confirm variable art_id
                                if _rc == 0 {
                                    qui keep if art_id == "`art_id_match'"
                                    if _N > 0 {
                                        cap local doi_tmp = DOI[1]
                                        if _rc != 0 cap local doi_tmp = doi[1]
                                        cap local page_tmp = page[1]
                                        if "`doi_tmp'" != "" & "`doi_tmp'" != "." {
                                            local doi_i = "`doi_tmp'"
                                            local page_i = "`page_tmp'"
                                            local has_doi = 1
                                        }
                                    }
                                }
                            }
                        }
                        cap frame drop `framename'
                    }
                    * If frame failed (Stata < 16), silently skip local lookup
                }
            }
        }
    }

    * Priority 2 (fallback): if still not found and ref option is used, fetch online automatically
    if `has_doi' == 0 & "`ref'" != "" {
        qui {
            cap findsj_doi `art_id_nobom'
            if _rc == 0 {
                local doi_i = r(doi)
                local page_i = r(page)
                if "`doi_i'" != "" & "`doi_i'" != "." {
                    local has_doi = 1
                }
            }
        }
    }
    
    if "`nobrowser'" == "" & "`output_format'" == "" {
        dis as text "    " _c
        dis as text `"{browse "`url_html_i'":Article}"' _c
        
        * Display PDF link - use DOI-based URL (only if DOI is available)
        if "`nopdf'" == "" & `has_doi' == 1 {
            local url_pdf_i "https://journals.sagepub.com/doi/pdf/`doi_i'"
            dis as text " | " _c
            dis as text `"{browse "`url_pdf_i'":PDF}"' _c
        }
        
        * Display Google Scholar link
        local title_search = subinstr(`"`title_i'"', " ", "+", .)
        local title_search = subinstr(`"`title_search'"', "&amp;", "%26", .)
        local title_search = subinstr(`"`title_search'"', "&ndash;", "-", .)
        local url_google "https://scholar.google.com/scholar?q=`title_search'"
        dis as text " | " _c
        dis as text `"{browse "`url_google'":Google}"' _c
        
        * Add package search on same line
        if "`nopkg'" == "" {
            dis as text " | " _c
            dis as text `"{stata "search `art_id_nobom'":Install}"' _c
        }
        
        * Display BibTeX and RIS buttons (on-demand download via helper program)
        dis as text " | " _c
        dis as text `"{stata "findsj `art_id_nobom', type(bib)":BibTeX}"' _c
        dis as text " | " _c
        dis as text `"{stata "findsj `art_id_nobom', type(ris)":RIS}"'
    }
    else if "`output_format'" != "" {
        * In formatted output mode, skip browser links
        dis ""
    }
    else {
        dis ""  // End line if nobrowser
    }
    
    * Display format buttons (.md .latex .txt) if ref option is specified (but skip if output_format is set)
    if "`ref'" != "" & "`output_format'" == "" {
        dis ""  // End the button line first
        
        * Check if we have DOI for generating citations
        if `has_doi' == 1 & "`getdoi'" != "" {
            * Display "Cite:" label followed by three format buttons with separator
            dis as text "    Cite: " _c
            dis as text `"{stata "getiref `doi_i', md":.md}"' _c
            dis as text " | " _c
            dis as text `"{stata "getiref `doi_i', latex":.latex}"' _c
            dis as text " | " _c
            dis as text `"{stata "getiref `doi_i', text":.txt}"'
        }
        else {
            * No DOI available - provide helpful guidance
            dis as text "    " as error "(No DOI found)" as text " - Try: " _c
            dis as text `"{stata "findsj, update source(both)":Update database}"'
        }
    }
    
}


* Restore original line size
quietly set linesize `old_linesize'

* Save total number of displayed results
global findsj_n_display `n_display'

if `total_results' > `n_display' {
    dis _n as text "{hline 60}"
    dis as text "  Showing " as result "`n_display'" as text " of " as result "`total_results'" as text " results."
    if `time_filtered' == 1 {
        * Time filtering applied - suggest adding allresults to see all filtered results
        dis as text "  To see all filtered results, add option: " as result "allresults"
        if "`from'" != "" & "`to'" != "" {
            dis as text "  Example: " `"{stata "findsj `keywords', from(`from') to(`to') allresults":findsj `keywords', from(`from') to(`to') allresults}"'
        }
        else if "`from'" != "" {
            dis as text "  Example: " `"{stata "findsj `keywords', from(`from') allresults":findsj `keywords', from(`from') allresults}"'
        }
        else {
            dis as text "  Example: " `"{stata "findsj `keywords', to(`to') allresults":findsj `keywords', to(`to') allresults}"'
        }
    }
    else {
        * No time filtering - standard message
        dis as text "  To see all results, add option: " as result "allresults"
        dis as text "  Example: " `"{stata "findsj `keywords', allresults":findsj `keywords', allresults}"'
    }
    dis as text "{hline 60}"
}

* Note: Batch clipboard copy removed. Users can click individual "Ref" buttons to copy citations.
* This provides better user experience and avoids command-line length limitations.

* Export formatted output to file if format option specified
if "`output_format'" != "" {
    * Determine file extension
    if "`output_format'" == "markdown" {
        local fn_suffix ".md"
    }
    else if "`output_format'" == "latex" {
        local fn_suffix ".txt"
    }
    else if "`output_format'" == "text" {
        local fn_suffix ".txt"
    }
    
    * Set save path (current directory)
    local path `"`c(pwd)'"'
    local path = subinstr(`"`path'"', "\\", "/", .)
    local saving "_findsj_temp_out_`fn_suffix'"
    
    * Export to file
    qui export delimited _OutputStr using `"`path'/`saving'"', ///
        novar nolabel delimiter(tab) replace
    
    * Display file location with four buttons (View/Open_Mac/Open_Win/dir)
    dis " "
    dis _dup(58) "-" _n ///
        _col(3)  `"{stata `" view  "`path'/`saving'" "': View}"' ///
        _col(17) `"{stata `" !open "`path'/`saving'" "' : Open_Mac}"' ///
        _col(30) `"{stata `" winexec cmd /c start "" "`path'/`saving'" "' : Open_Win}"' ///
        _col(50) `"{browse `"`path'"': dir}"'
    dis _dup(58) "-"
}

return local keywords   = "`keywords'"
return local scope      = "`scope'"
return local url        = "`url_sj'"
return scalar n_results = `total_results'

if `total_results' > 0 {
    return local art_id_1  = art_id[1]
    return local title_1   = title[1]
    return local author_1  = author[1]
    cap return local doi_1 = doi[1]
    return local url_1     = url_html[1]
}

restore

dis _n as text "{hline 60}"
dis as text "  Search completed. Found " as result `total_results' as text " article(s)" _c
if `time_filtered' == 1 {
    dis as text " (filtered from " as result "`n_results_before_time'" as text " total)."
}
else {
    dis as text "."
}
if "`nobrowser'" == "" & `time_filtered' == 0 {
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
dis as error "Note: findsj_add_data is deprecated. Local data file support has been removed."
dis as text "DOI and page information are now fetched in real-time when using the 'getdoi' option."
exit 199
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
* Database Update Check and Download Functions
*===============================================================================

cap program drop findsj_update_db
program define findsj_update_db
    args source_choice
    
    dis as text "{hline 70}"
    dis as result "  Stata Journal Database Update"
    dis as text "{hline 70}"
    dis ""
    
    * Find findsj.ado location
    qui findfile findsj.ado
    local ado_dir = subinstr("`r(fn)'", "findsj.ado", "", .)
    local dta_file "`ado_dir'findsj.dta"
    
    dis as text "Database location: " as result "`dta_file'"
    dis ""
    
    * Define download sources
    local github_url "https://raw.githubusercontent.com/BlueDayDreeaming/findsj/main/findsj.dta"
    local gitee_url "https://gitee.com/ChuChengWan/findsj/raw/main/findsj.dta"
    
    * Determine source based on argument
    if "`source_choice'" == "" | "`source_choice'" == "auto" {
        dis as text "Download source options:"
        dis as text "  {stata findsj, update source(github):github} = GitHub (Recommended for international users)"
        dis as text "  {stata findsj, update source(gitee):gitee}  = Gitee (Recommended for users in China)"
        dis as text "  {stata findsj, update source(both):both}   = Try both (GitHub first, then Gitee)"
        dis as text ""
        dis as text "Click on a source above to download."
        dis as text "{hline 70}"
        exit
    }
    
    local sources ""
    local source_names ""
    
    if "`source_choice'" == "github" {
        local sources "`github_url'"
        local source_names "GitHub"
    }
    else if "`source_choice'" == "gitee" {
        local sources "`gitee_url'"
        local source_names "Gitee"
    }
    else if "`source_choice'" == "both" {
        local sources "`github_url' `gitee_url'"
        local source_names "GitHub Gitee"
    }
    else {
        dis as error "Invalid source: `source_choice'"
        dis as text "Valid options: github, gitee, both"
        exit 198
    }
    
    * Try each source
    local n_sources = wordcount("`sources'")
    forvalues i = 1/`n_sources' {
        local source_url = word("`sources'", `i')
        local source_name = word("`source_names'", `i')
        
        dis ""
        dis as text "Downloading from `source_name'..." _c
        
        cap copy "`source_url'" "`dta_file'", replace
        
        if _rc == 0 {
            dis as result " Success!"
            
            * Verify the file
            cap use "`dta_file'", clear
            if _rc == 0 {
                qui count
                local n_records = r(N)
                dis ""
                dis as text "{hline 70}"
                dis as result "  Update Complete!"
                dis as text "{hline 70}"
                dis as text "Database updated successfully from `source_name'"
                dis as text "Total articles: " as result "`n_records'"
                dis as text "Location: " as result "`dta_file'"
                dis as text "{hline 70}"
                exit
            }
            else {
                dis as error " File corrupted."
                if `i' < `n_sources' {
                    dis as text "Trying next source..."
                }
            }
        }
        else {
            dis as error " Failed."
            if `i' < `n_sources' {
                dis as text "Trying next source..."
            }
        }
    }
    
    * All sources failed
    dis ""
    dis as text "{hline 70}"
    dis as error "  Update Failed"
    dis as text "{hline 70}"
    dis as error "Could not download database from selected source(s)"
    dis as text "Possible reasons:"
    dis as text "  - No internet connection"
    dis as text "  - Firewall blocking access"
    dis as text "  - Repository temporarily unavailable"
    dis ""
    dis as text "Manual download instructions:"
    dis as text "  1. Visit: " as result "https://github.com/BlueDayDreeaming/findsj"
    dis as text "     (China: " as result "https://gitee.com/ChuChengWan/findsj" as text ")"
    dis as text "  2. Download findsj.dta"
    dis as text "  3. Copy to: " as result "`ado_dir'"
    dis as text "{hline 70}"
end

*===============================================================================
* Helper program: findsj_check_update
* Check if findsj.ado needs update (once per day)
*===============================================================================
cap program drop findsj_check_update
program define findsj_check_update
    version 14
    
    local today_str = c(current_date)
    
    * Try to find findsj_version.dta
    local version_found = 0
    local db_date_val = 0
    local version_file_path = ""
    
    * Search in multiple locations (including where findsj.ado is located)
    capture findfile findsj.ado
    if !_rc {
        local ado_dir = subinstr(r(fn), "/findsj.ado", "", .)
        local ado_dir = subinstr("`ado_dir'", "\findsj.ado", "", .)
    }
    else {
        local ado_dir ""
    }
    
    foreach location in "`c(sysdir_plus)'f" "`c(sysdir_personal)'" "`ado_dir'" "d:\User\private\Desktop\stata\findsj_v3" {
        if "`location'" == "" continue
        if `version_found' continue  // Skip if already found
        capture confirm file "`location'/findsj_version.dta"
        if !_rc {
            preserve
            quietly use "`location'/findsj_version.dta", clear
            local db_date_val = db_date[1]
            
            * Check if already checked today
            capture confirm variable last_check
            if !_rc {
                local last_check = last_check[1]
                if "`last_check'" == "`today_str'" {
                    restore
                    exit  // Already checked today
                }
            }
            restore
            
            local version_found = 1
            local version_file_path = "`location'/findsj_version.dta"
        }
    }
    
    * If version file not found, skip check
    if !`version_found' | `db_date_val' == 0 {
        exit
    }
    
    * Parse database date (yyyyMMdd format)
    local db_year = floor(`db_date_val'/10000)
    local db_month = floor((`db_date_val' - `db_year'*10000)/100)
    local db_day = `db_date_val' - `db_year'*10000 - `db_month'*100
    
    * Calculate days difference
    local db_date_num = mdy(`db_month', `db_day', `db_year')
    local today = date("`today_str'", "DMY")
    local days_diff = `today' - `db_date_num'
    
    * If older than 120 days (about 4 months), show update reminder
    if `days_diff' > 120 {
        dis ""
        dis as text "{hline 70}"
        dis as result "  📢 Update Available!"
        dis as text "{hline 70}"
        dis as text "Your findsj database is " as result "`days_diff'" as text " days old"
        dis as text "(last updated: " as result "`db_day'/`db_month'/`db_year'" as text ")"
        dis ""
        dis as text "You can update findsj, type:"
        dis as result "  net install findsj, from(https://github.com/BlueDayDreeaming/findsj/raw/main/) replace"
        dis as text "Or (China users):"
        dis as result "  net install findsj, from(https://gitee.com/ChuChengWan/findsj/raw/main/) replace"
        dis as text "{hline 70}"
        dis ""
    }
    
    * Update last_check date in version file
    quietly {
        preserve
        use "`version_file_path'", clear
        
        * Add last_check variable if it doesn't exist
        capture confirm variable last_check
        if _rc {
            gen str20 last_check = ""
        }
        
        * Update the date
        replace last_check = "`today_str'" in 1
        save "`version_file_path'", replace
        restore
    }
end
