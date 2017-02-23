using DataFrames
using Plots, StatPlots

using GLM

cars_df = readtable("Ford_Focus_prices.csv")

scatter(cars_df,:Mileage,:Price)

# Looks vaguely exponential, try taking the log
cars_df[:LogPrice] = log(cars_df[:Price])

# Also try plotting on a log-log scale
scatter(cars_df,:Mileage,:Price,scale=:log10)
# Looks interesting... there appears to be two distinct clusters with their own behaviour

# cars_lm = lm(LogPrice ~ Mileage, cars_df)