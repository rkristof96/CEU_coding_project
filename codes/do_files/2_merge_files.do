*7.Read .csv data in in Stata.
 
*import delimited "C:\Users\Kristof\Desktop\coding_project_2022\CEU_coding_project\data\raw_data\health2019.csv", clear

import delimited using "data\raw_data\health2019_part1.csv",  varnames(1) bindquotes(strict) delimiters(";")  clear
*encoding("utf-8") not necessary and not working

**9.Aggregate, reshape, and combine data for analysis in Python or Stata. Demonstrate at least one of these data manipulations.
*merge data sets
merge 1:1 county using "data\derived_data\health2019_new.dta"

*11. Save data in Stata.
save "data\derived_data\health2019.dta", replace
