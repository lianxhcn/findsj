*! version 1.0.0  17Nov2025
*! Helper program for findsj: Download BibTeX or RIS file on-demand
*! Authors: Yujun Lian, Chucheng Wan

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
        local file_name "`artid'.bib"
    }
    else if "`type'" == "ris" {
        local url "https://www.stata-journal.com/ris.php?articlenum=`artid'&abs=1&type=ris"
        local file_name "`artid'.ris"
    }
    else {
        dis as error "Error: type must be 'bib' or 'ris'"
        exit 198
    }
    
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
    
    dis as text "Downloading `type' file for `artid'..."
end
