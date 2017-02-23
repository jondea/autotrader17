using DataFrames
using Plots, StatPlots

ads_df = readtable("Viewed_ads.csv")

scatter(ads_df,:Price,:Mileage,group=:Make)

function plot_price_against_mileage(make=false)
  if !make 
    return scatter(ads_df,:Mileage,:Price,group=:Make)
  else
    make_df = ads_df[ads_df[:Make] .== make,:]
    return scatter(make_df,:Mileage,:Price)
  end
end

# Rescale
ads_df[:SMileage] = ads_df[:Mileage]/75000
ads_df[:SPrice] = ads_df[:Price]/20000

using GaussianMixtures
n = 3
d = 2

SX = hcat(Array{Float64}(ads_df[:SMileage]),Array{Float64}(ads_df[:SPrice]))

ads_GMM_model =  GMM(n, SX; method=:kmeans, kind=:full, nInit=50, nIter=10, nFinal=10)

# Plot means
# scatter!(ads_GMM_model.μ[:,1],ads_GMM_model.μ[:,2],marker=:cross)

using Distributions

dist = MixtureModel(ads_GMM_model)

GMM_dist(x,y) = pdf(dist,[x,y])

function plot_scatter_and_GMM()
  heatmap(0:0.001:1.0,0:0.001:1.0,GMM_dist,color=:blues,legend=false)
  fig = scatter!(ads_df,:SMileage,:SPrice,group=:Make,markersize=1.5,markeralpha=0.6,markerstrokealpha=0.0)
  savefig("scatter_and_dist_plot")
  return fig
end

