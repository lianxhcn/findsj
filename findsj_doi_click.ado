*! findsj_doi_click version 1.0  11nov2025
*! Helper command to copy citation to clipboard when DOI is clicked

cap program drop findsj_doi_click
program define findsj_doi_click
    version 14
    syntax, idx(integer)
    
    * Get citation from global macro
    if `"${findsj_cite_`idx'}"' == "" {
        di as error "Error: Citation not found for article `idx'"
        exit 198
    }
    
    * Copy citation to clipboard
    tempfile cliptemp
    tempname fh
    qui {
        file open `fh' using "`cliptemp'", write text replace
        file write `fh' `"${findsj_cite_`idx'}"'
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
        di as error "Clipboard operation only supported on Windows and Mac"
        exit 198
    }
    
    * Display success message
    if _rc == 0 {
        di as text "Tips: Text is on clipboard. Press 'Ctrl+V' to paste, ^-^"
    }
    else {
        di as error "Failed to copy to clipboard"
    }
end
