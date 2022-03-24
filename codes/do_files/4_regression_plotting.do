use  "data\derived_data\health2019.dta", clear
*10.Prepare a sample for analysis by filtering observations and variables and creating transformations of variables. Demonstrate all three.
* keep variables (filter variables)
keep violation with_access_num alcohol_impaired_num chlamydia_rate_num teen_birth_rate_num pcp_rate_num some_college_num unemployed_num lbw_num income_ratio population_25_44 vaccinated county state

bysort vaccinated: gen index=_n
summarize vaccinated
* select below mean vaccination
* create variables to filter observations
gen low_vaccination = 1 if vaccinated < r(vaccinated)
 
gen vaccinated_per_population= vaccinated/population_25_44
* too many countries
* calculate quantiles
* create variables to filter observations (filtering is made in plotting
xtile d10=vaccinated,n(10)

* 13. Create a graph (of any type) in State.
graph twoway (scatter vaccinated income_ratio if state == "Kentucky" & low_vaccination==1 ) (scatter vaccinated income_ratio if state == "Texas" & low_vaccination==1), xsc(log) ysc(log) xti("Income ratio") yti("Vaccinated") title("Vaccination and income ratio below average vaccination")legend(label(1 Kentucky) label(2 Texas)) 
graph export "plots\vaccinated1.png"
*, replace
graph twoway (scatter vaccinated income_ratio if state == "Kentucky" & d10==1 ) (scatter vaccinated income_ratio if state == "Texas" & d10==1), xsc(log) ysc(log) xti("Income ratio") yti("Vaccinated") title("Vaccination and income ratio in 1st decile")legend(label(1 Kentucky) label(2 Texas)) 
graph export "plots\vaccinated2.png"
*, replace

*12.Run ordinary least squares regression in Stata.
tabulate violation, gen(violationfe)
eststo vaccinated_regression: regress vaccinated income_ratio violationfe* lbw_num with_access_num alcohol_impaired_num chlamydia_rate_num teen_birth_rate_num pcp_rate_num some_college_num unemployed_num
predict vaccinated_hat

graph twoway (scatter vaccinated vaccinated_hat) (lfitci vaccinated vaccinated_hat), title(Regression output correlation) xti("Vaccinated") yti("Predicted value")xsc(log) ysc(log)
graph export "plots\residuals.png"
*, replace



*14. Save regression tables and graphs as files. Demonstrate both.
***ssc outreg2
cd "codes\do_files"
outreg2 using vaccinated, word append ctitle("Vaccinated") drop(violationfe*) addtext(Violation fixed effect, YES) label
