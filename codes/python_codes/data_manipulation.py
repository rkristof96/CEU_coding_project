# import library
import pandas as pd

 # read data
data= pd.read_csv("health2019.csv")
# select variables
unemployed=data["Unemployed"]
population=data["Population_25_44"]
# calculate length of a list
len_data=len(population)
# initialize a list
unemployment_rate=[0]*len_data

#2.Automate repeating tasks using Python “for” loops.

for i in range(len_data):
    unemployment_rate[i]=unemployed[i]/population[i]


for i in range(3):
   print('Unemployment rate in '+data["County"][i]+' '+str(round(unemployment_rate[i]*100,2))+'%')

#3.Break up work into smaller components using Python functions.
# same exercie as above with functions

# separete county and state name
def pure_county_name(x):
    y=x.split('_')
    return y[0]

# division function
def divide(nominator,denominator):
    solution=nominator/denominator
    return solution

# print the results
def report_unemployment_rate(unemployment_rate, county):
    message='Unemployment rate in '+county+' '+str(round(unemployment_rate*100,2))+'%'
    return message

# putting everything together
for i in range(3):
    unemp_rate=divide(unemployed[i],population[i])
    county_name=pure_county_name(data["County"][i])
    print(report_unemployment_rate(unemp_rate,county_name))


# 4.Use Python “lists” and “dictionaries” appropriately. Demonstrate one of the two.

state=data["State"] #string
uninsured=data["Uninsured"]# unisured 
#list
state_uninsured=list(state[0:3])

# appending to list and printing results
for i in range(3):
    state_uninsured.append(uninsured[i])
    print('proportion of uninsured in '+state_uninsured[i]+' = '+str(round(state_uninsured[(i+3)],2)))


cumulative=0

for i in [1,2,3]:
    cumulative=cumulative+i

print(cumulative)

# append more items at the same time
tmp=list(['Chicago', 'New York', 'Washington'])
tmp.append(list([1,2,3]))
print(tmp)

# dictionary
from yahoofinancials import YahooFinancials
# getting data from yahoo finance and make some calculation
# firm is PFG (its ticker is PFG, an insurance company)
tickers = ['PFG']
# read adata
yahoo_financials = YahooFinancials(tickers)
# get income statement
income = yahoo_financials.get_financial_stmts('annual', 'income', reformat=True)
# format of income is a combination of list and dictionary
income_history=income.get('incomeStatementHistory')
income_history_PFG=income_history.get('PFG')
income_history_PFG_2021=income_history_PFG[0].get('2021-12-31')
# get costs and revenue
total_op_expense=income_history_PFG_2021.get('totalOperatingExpenses')
total_revenue=income_history_PFG_2021.get('totalRevenue')
# calculate cost share
operational_cost_share=round(total_op_expense/total_revenue*100,2)
# print the results
print("Proportion of operational expenses are: "+str(operational_cost_share)+" for firm PFG.")
