
using MetapopulationDynamics
using Plots, DataFrames
using StatsBase: mean, quantile, std
rickerparams = (λ = 8:0.1:12, χ=0.03, R=1)
dispersalparams = (m = [0.01,0.1,0.25], α = [3, 6, 9])

params = merge(rickerparams, dispersalparams)


diffTreatments = TreatmentSet(
    PoissonProcess(numlocations = 15),
    DiffusionDispersal,
    RickerModel,
    params
)
diffusion_data = simulate(diffTreatments; numreplicates=100)
diff_df = innerjoin(diffusion_data, diffTreatments.metadata, on=:treatment)


stochTreatments = TreatmentSet(
    PoissonProcess(numlocations = 15),
    StochasticDispersal,
    RickerModel,
    params
)
stoch_data = simulate(stochTreatments; numreplicates=100)
stoch_df = innerjoin(stoch_data, stochTreatments.metadata, on=:treatment)


M = unique(stoch_df, :m).m
Λ = unique(stoch_df, :λ).λ

A = unique(stoch_df, :α).α

plts = []
for m in M
    for α in A
    
    meanAbd = []
    meanPCCDiff = [] 
    for λ in Λ
     stoch_filtered = filter(row -> row[:λ] == λ && row[:m] == m && row[:α] == α, stoch_df)
     diff_filtered = filter(row -> row[:λ] == λ && row[:m] == m && row[:α] == α, diff_df)
     pccdiff = mean(diff_filtered["PCC(10)"]) - mean(stoch_filtered["PCC(10)"])
        
     abd = (mean(stoch_filtered["MeanAbundance(10)"]) + mean(diff_filtered["MeanAbundance(10)"]))*0.5
     
     push!(meanPCCDiff, pccdiff )
     push!(meanAbd, abd )
     #scatter!(filterdata.m, filterdata.stat, ma=0.4, ms=2)
    end
    pl = plot(title="m = $m, α = $α")
    plot!(pl, frame=:box, label=:none)
    scatter!(meanAbd, meanPCCDiff)
    xlabel!("Mean Abundance")
    ylabel!("PCC Diff")
    push!(plts, pl)
    end
end

fig = plot(plts..., layout=(3,3), size=(1000,1000))



savefig(fig, "stochastic_vs_dispersal_panels.png")
