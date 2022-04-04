****
**change
cd "C:\Users\Kristof\Desktop\coding_project_2022\CEU_coding_project"

use  "data\derived_data\health2019.dta", clear

*string to num
*8.Fix common data quality errors in Stata (for example, string vs number, missing value).

foreach var of varlist lbw with_access alcohol_impaired chlamydia_rate teen_birth_rate pcp_rate some_college unemployed{
encode `var', gen(`var'_num)
}


 ***generate exercise
 *5. Automate repeating tasks using Stata “for” loops.
 * I am creating a 3 dummy variables and I will merge them together to demonstrate for in STATA
 set seed 1234
 gen tmp=runiform()
 
 gen ind1=1 if tmp<1/3
 replace ind1=0 if missing(ind1)
 
 gen ind2=1 if tmp<2/3 & tmp>=2/3 
 replace ind2=0 if missing(ind2)
 
 gen ind3=1 if tmp>1/3
 replace ind3=0 if missing(ind3)
 
 gen ind=1 if ind1==1
 
 forvalues i = 2/3 {
replace ind = `i' if ind`i' ==1 
}

codebook ind
