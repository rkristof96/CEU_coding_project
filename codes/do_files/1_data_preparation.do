****
**change
cd "C:\Users\Kristof\Desktop\coding_project_2022\CEU_coding_project"
***import delimited "C:\Users\Kristof\Desktop\coding_project_2022\CEU_coding_project\data\raw_data\health2019_part2.csv", delimiters(";") clear 
*7. Read .csv data in in Stata.
import delimited "data\raw_data\health2019_part2.csv", delimiters(";") clear 

*8.Fix common data quality errors in Stata (for example, string vs number, missing value).
* string encode to "factor"
encode presence_of_violation, gen(violation)
* numeric encode (from string)
encode single_parent_households, gen(sph)
encode severe_housing_problems , gen(shp)
encode drive_alone , gen(drivea)
* count missing values
 display missing()

 * print missing values one-by-one
 *5.Automate repeating tasks using Stata “for” loops.
foreach var of varlist county income_ratio association_rate violent_crime_rate injury_death_rate severe_housing_problems violation sph shp drivea{
count if missing(`var')
}
* sph should be inputed
count if missing(sph)

* install package to inpute data
*15. Install a Stata package. (Can be the same as we already did in class.)
ssc install fillmissing, replace
*package is used to imput data
* input data with mean
fillmissing sph, with (mean)

*check if inputed
count if missing(sph)

*11. Save data in Stata.
save "data\derived_data\health2019_new.dta", replace
