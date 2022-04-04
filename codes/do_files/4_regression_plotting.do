****
**change
cd "C:\Users\Kristof\Desktop\coding_project_2022\CEU_coding_project"

use "data\derived_data\health2019_manipulated.dta"
*use  "data\derived_data\health2019.dta", clear
*10.Prepare a sample for analysis by filtering observations (10.1) and variables (10.2) and creating transformations of variables (10.3). Demonstrate all three.
* 10.2 keep variables (filter variables)
keep violation with_access_num alcohol_impaired_num chlamydia_rate_num teen_birth_rate_num pcp_rate_num some_college_num unemployed_num lbw_num income_ratio population_25_44 vaccinated county state

bysort vaccinated: gen index=_n
summarize vaccinated
* select below mean vaccination
* create variables to filter observations
gen low_vaccination = 1 if vaccinated < r(vaccinated)
* I am using this index in plotting to filter observations
 
 * 10.3 transform variable
gen vaccinated_per_population= vaccinated/population_25_44
* too many countries
* calculate quantiles


* 10.1 create variables to filter observations (filtering is made in plotting
xtile d10=vaccinated,n(10)
* I am using this variable in plotting to filter observations

* 13. Create a graph (of any type) in Stata.
* 14. Save regression tables and graphs as files. Demonstrate both.
* if there is a picture in the folder with the same name, STATA does not export the file
graph twoway (scatter vaccinated income_ratio if state == "Kentucky" & low_vaccination==1 ) (scatter vaccinated income_ratio if state == "Texas" & low_vaccination==1), xsc(log) ysc(log) xti("Income ratio") yti("Vaccinated") title("Vaccination and income ratio below average vaccination")legend(label(1 Kentucky) label(2 Texas)) 
graph export "plots\vaccinated1.png", replace
*, replace
graph twoway (scatter vaccinated income_ratio if state == "Kentucky" & d10==1 ) (scatter vaccinated income_ratio if state == "Texas" & d10==1), xsc(log) ysc(log) xti("Income ratio") yti("Vaccinated") title("Vaccination and income ratio in 1st decile")legend(label(1 Kentucky) label(2 Texas)) 
* if there is a picture in the folder with the same name, STATA does not export the file
graph export "plots\vaccinated2.png", replace


*12.Run ordinary least squares regression in Stata.
tabulate violation, gen(violationfe)
*generate fix effects
* estimate regression model
eststo vaccinated_regression: regress vaccinated income_ratio violationfe* lbw_num with_access_num alcohol_impaired_num chlamydia_rate_num teen_birth_rate_num pcp_rate_num some_college_num unemployed_num
* prediction
predict vaccinated_hat

* plot fitted values and observations (y)
graph twoway (scatter vaccinated vaccinated_hat) (lfitci vaccinated vaccinated_hat), title(Regression output correlation) xti("Vaccinated") yti("Predicted value")xsc(log) ysc(log)
* export graph
graph export "plots\residuals.png", replace


*14. Save regression tables and graphs as files. Demonstrate both.
***ssc outreg2
cd "codes\do_files"
outreg2 using vaccinated, word append ctitle("Vaccinated") drop(violationfe*) addtext(Violation fixed effect, YES) label, replace
