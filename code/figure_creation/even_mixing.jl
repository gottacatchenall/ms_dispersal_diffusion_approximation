using Pkg
Pkg.activate("../")


using MetapopulationDynamics
using Plots, DataFrames
using StatsBase: mean, quantile, std,

rickerparams = (λ = 8, χ=0.03, R=0.9)
dispersalparams = (m = 0.01:0.01:1, α =[0, 3, 6, 9])
params = merge(rickerparams, dispersalparams)

mcritvec = []
alphavec = []
npvec = []

for np = 2:50
    diffTreatments = TreatmentSet(
        PoissonProcess(numlocations = np),
        DiffusionDispersal, 
        RickerModel,
        params
    )
    diffusion_data = simulate(diffTreatments; numreplicates=50)
    diff_df = innerjoin(diffusion_data, diffTreatments.metadata, on=:treatment)


    for α in [0,3,6,9]
        this_alpha = filter(row -> row[:α] == α, diff_df)
        diff_filtered = filter(row -> row["PCC(10)"] == max(this_alpha["PCC(10)"]...) , this_alpha)
        push!(mcritvec, diff_filtered.m)
        push!(alphavec, alpha)
        push!(npvec, np)
    end

    #maxpcc = filter
end

f