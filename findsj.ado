*! findsj version 1.0.1  2025/10/18
*! Author: Yujun Lian (arlionn@163.com)
*! Search Stata Journal and Stata Technical Bulletin articles

cap program drop findsj
program define findsj, rclass
version 14

syntax anything(name=keywords id="keywords") [, ///
    Author Title Keyword ///
    Markdown Latex TEX Plain  ///
    NOCLIP NOBrowser NODOI NOPDF NOPkg ///
    N(integer 5) ALLresults ///
    Clear Debug ///
    ]

if "`debug'" != "" set trace on
if "`tex'" != "" local latex "latex"

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
    findsj_strget v, gen(author_raw) begin(`"<dd>"') end(`"</dd>"')
    
    * Clean up extracted data
    gen author = author_raw
    replace author = author[_n+1] if author == "" & author[_n+1] != ""
    drop author_raw
    
    drop v 
    keep if art_id != ""
    gen selected = 1
    local n_results = _N
    noi dis as text "Found " as result `n_results' as text " article(s)."
    
    local fn_sj ""
    cap findsj_finddata
    if _rc == 0 local fn_sj `"`r(fn)'"'
    
    if `"`fn_sj'"' == "" {
        noi dis as text ""
        noi dis as text "{hline 60}"
        noi dis as text "  Note: Data file not available"
        noi dis as text "  The program will continue with basic search results."
        noi dis as text "  Article IDs and links will still be displayed."
        noi dis as text "{hline 60}"
        noi dis as text ""
    }
    
    * If data file exists, merge with it
    if `"`fn_sj'"' != "" {
        merge 1:1 art_id using `"`fn_sj'"', nogen keep(match master)
    }
    else {
        * Create placeholder variables if data file not available
        gen volume = ""
        gen number = ""
        gen doi = ""
        gen page = ""
        gen volnum = .
    }
    
    keep if selected == 1
    drop if missing(title) | title == "" | title == "."
    drop if missing(author) | author == "" | author == "."
    
    local n_results = _N
    if `n_results' == 0 {
        noi dis as error "No valid articles with complete information."
        restore
        exit
    }
    
    * Sort by volnum if available, otherwise keep original order
    cap gsort -volnum
    
    local url_base "https://www.stata-journal.com/article.html?article="
    gen url_html = "`url_base'" + art_id
    
    local url_pdf_base "https://journals.sagepub.com/doi/pdf/"
    cap confirm variable doi
    if _rc == 0 gen url_pdf = "`url_pdf_base'" + doi if doi != "" & doi != "."
    
    * Generate volume/number strings if variables exist
    cap confirm variable volume
    if _rc == 0 {
        gen volnum_str = volume + "(" + number + ")"
        gen volnum_url = volume + "-" + number
        gen year = string(2000 + real(volume))
    }
    else {
        gen volnum_str = ""
        gen volnum_url = ""
        gen year = ""
    }
    
    cap confirm variable page
    if _rc == 0 gen page_str = ": " + page if page != "" & page != "."
    else gen page_str = ""
    
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

local n = `n_display'
forvalues i = 1/`n' {
    local volnum_i  = volnum_str[`i']
    local author_i  = author[`i']
    local title_i   = title[`i']
    local year_i    = year[`i']
    local art_id_i  = art_id[`i']
    local url_html_i = url_html[`i']
    
    dis as text "[" as result `i' as text "] " _c
    dis as result "`author_i'" as text " (" as result "`year_i'" as text "). "
    dis as text "    " as result "`title_i'"
    dis as text "    " as text "Stata Journal " as result "`volnum_i'" _c
    
    cap local page_i = page[`i']
    if "`page_i'" != "" & "`page_i'" != "." dis as text ": " as result "`page_i'" _c
    dis ""
    
    if "`nobrowser'" == "" {
        dis as text `"    {browse "`url_html_i'":Article page}"' _c
        
        cap local url_pdf_i = url_pdf[`i']
        if "`nopdf'" == "" & "`url_pdf_i'" != "" & "`url_pdf_i'" != "." {
            dis as text `" | {browse "`url_pdf_i'":PDF}"' _c
        }
        
        if "`nodoi'" == "" {
            cap local doi_i = doi[`i']
            if "`doi_i'" != "" & "`doi_i'" != "." {
                local doi_url "https://doi.org/`doi_i'"
                dis as text `" | DOI: {browse "`doi_url'":`doi_i'}"' _c
            }
        }
        dis ""
    }
    
    if "`nopkg'" == "" {
        cap local volnum_url_i = volnum_url[`i']
        dis as text "    " `"{stata "search `art_id_i'":Search for package}"' _c
        dis as text " | " `"{stata "net from http://www.stata-journal.com/software/sj`volnum_url_i'":Browse SJ software}"'
    }
    dis ""
}

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
   cap noi findfile `"`fname'"', path(`".;`c(adopath)'"')
   if _rc {
       dis as text "Data file not found. To install: {stata ssc install findsj, replace}"
       exit
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

cap program drop findsj_download_data
program define findsj_download_data
version 14
    qui {
        * Download data file from GitHub
        local data_url "https://raw.githubusercontent.com/BlueDayDreeaming/findsj/main/sjget_data_sj.dta"
        local save_path "`c(sysdir_plus)'s/sjget_data_sj.dta"
        
        * Create directory if it doesn't exist
        cap mkdir "`c(sysdir_plus)'s"
        
        * Download the file
        cap copy "`data_url'" "`save_path'", replace
        if _rc {
            noi dis as error "Failed to download data file from GitHub"
            exit 601
        }
        else {
            noi dis as text "Data file downloaded successfully to: `save_path'"
        }
    }
end
