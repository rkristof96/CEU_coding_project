 ***
import delimited "C:\Users\Kristof\Desktop\coding_project_2022\CEU_coding_project\data\raw_data\health2019_part2.csv", delimiters(";") clear 
*8.Fix common data quality errors in Stata (for example, string vs number, missing value).
* string encode to "factor"
encode presence_of_violation, gen(violation)
* numeric encode (from string)
encode single_parent_households, gen(sph)
encode severe_housing_problems , gen(shp)
encode drive_alone , gen(drivea)
* count missing values
 display missing()

foreach var of varlist county income_ratio association_rate violent_crime_rate injury_death_rate severe_housing_problems violation sph shp drivea{
count if missing(`var')
}
* sph should be inputed
count if missing(sph)

* install package to inpute data
*15. Install a Stata package. (Can be the same as we already did in class.)
ssc install fillmissing, replace
* input data with mean
fillmissing sph, with (mean)

*11. Save data in Stata.
save "C:\Users\Kristof\Desktop\coding_project_2022\CEU_coding_project\data\derived_data\health2019_partb.dta", replace
 *7.Read .csv data in in Stata.
 
*import delimited "C:\Users\Kristof\Desktop\coding_project_2022\CEU_coding_project\data\raw_data\health2019.csv", clear

import delimited using "C:\Users\Kristof\Desktop\coding_project_2022\CEU_coding_project\data\raw_data\health2019_part1.csv",  varnames(1) bindquotes(strict) delimiters(";")  clear
*encoding("utf-8") not necessary and not working

**9.Aggregate, reshape, and combine data for analysis in Python or Stata. Demonstrate at least one of these data manipulations.
*merge data sets
merge 1:1 county using "C:\Users\Kristof\Desktop\coding_project_2022\CEU_coding_project\data\derived_data\health2019_partb.dta"

*11. Save data in Stata.
save "C:\Users\Kristof\Desktop\coding_project_2022\CEU_coding_project\data\derived_data\health2019.dta", replace



*string to num
*Fix common data quality errors in Stata (for example, string vs number, missing value).

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

*** another loop in Stata
* iterating on variable list
* calculate numerical values from percentages
*foreach var of varlist teen_birth_rate pcp_rate dentist_rate mhp_rate preventable_hosp__rate graduation_rate association_rate violent_crime_rate injury_death_rate {
*generate `var'_num =`var'/100

*}


*10.Prepare a sample for analysis by filtering observations and variables and creating transformations of variables. Demonstrate all three.
* keep variables (filter variables)
keep violation with_access_num alcohol_impaired_num chlamydia_rate_num teen_birth_rate_num pcp_rate_num some_college_num unemployed_num lbw_num income_ratio population_25_44 vaccinated county state

bysort vaccinated: gen index=_n
summarize vaccinated
* select below mean vaccination
* create variables to filter observations
gen low_vaccination = 1 if vaccinated < r(vaccinated)
keep d10==1 
gen vaccinated_per_population= vaccinated/population_25_44
* too many countries
* calculate quantiles
* create variables to filter observations (filtering is made in plotting
xtile d10=vaccinated,n(10)

* 13. Create a graph (of any type) in State.
graph twoway (scatter vaccinated income_ratio if state == "Kentucky" & low_vaccination==1 ) (scatter vaccinated income_ratio if state == "Texas" & low_vaccination==1), xsc(log) ysc(log) xti("Income ratio") yti("Vaccinated") title("Vaccination and income ratio below average vaccination")legend(label(1 Kentucky) label(2 Texas)) 
graph export "C:\Users\Kristof\Desktop\coding_project_2022\CEU_coding_project\plots\vaccinated1.png"
graph twoway (scatter vaccinated income_ratio if state == "Kentucky" & d10==1 ) (scatter vaccinated income_ratio if state == "Texas" & d10==1), xsc(log) ysc(log) xti("Income ratio") yti("Vaccinated") title("Vaccination and income ratio in 1st decile")legend(label(1 Kentucky) label(2 Texas)) 
graph export "C:\Users\Kristof\Desktop\coding_project_2022\CEU_coding_project\plots\vaccinated2.png"

*12.Run ordinary least squares regression in Stata.
tabulate violation, gen(violationfe)
eststo vaccinated_regression: regress vaccinated income_ratio violationfe* lbw_num with_access_num alcohol_impaired_num chlamydia_rate_num teen_birth_rate_num pcp_rate_num some_college_num unemployed_num
predict vaccinated_hat

graph twoway (scatter vaccinated vaccinated_hat) (lfitci vaccinated vaccinated_hat), title(Regression output correlation) xti("Vaccinated") yti("Predicted value")xsc(log) ysc(log)
graph export "C:\Users\Kristof\Desktop\coding_project_2022\CEU_coding_project\plots\residuals.png"



*14. Save regression tables and graphs as files. Demonstrate both.
***ssc outreg2
outreg2 using vaccinated, word append ctitle("Vaccinated") drop(violationfe*) addtext(Violation fixed effect, YES) label
