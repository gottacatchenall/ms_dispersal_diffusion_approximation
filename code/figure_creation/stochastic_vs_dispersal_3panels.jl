using Pkg
Pkg.activate("../")

using MetapopulationDynamics
using Plots, DataFrames
using StatsBase: mean, quantile, std

rickerparams = (λ = [5, 10, 15], χ=0.03, R=0.9)
dispersalparams = (m = 0.0:0.01:1, α = [0., 5., 10.])

params = merge(rickerparams, dispersalparams)


diffTreatments = TreatmentSet(
    PoissonProcess(numlocations = 15),
    DiffusionDispersal, 
    RickerModel,
    params
)
diffusion_data = simulate(diffTreatments; numreplicates=30)
diff_df = innerjoin(diffusion_data, diffTreatments.metadata, on=:treatment)


stochTreatments = TreatmentSet(
    PoissonProcess(numlocations = 15), 
    StochasticDispersal,
    RickerModel,
    params
)
stoch_data = simulate(stochTreatments; numreplicates=30)
stoch_df = innerjoin(stoch_data, stochTreatments.metadata, on=:treatment)

M = unique(stoch_df, :m).m
Λ = unique(stoch_df, :λ).λ

A = unique(stoch_df, :α).α

plts = []
for λ in Λ
    for α in A
    μD = []
    σD = []
    μS = []
    σS = []

    for m in M
     stoch_filtered = filter(row -> row[:λ] == λ && row[:m] == m && row[:α] == α, stoch_df)
     diff_filtered = filter(row -> row[:λ] == λ && row[:m] == m && row[:α] == α, diff_df)

     push!(μD, mean(diff_filtered.stat))
     push!(σD, std(diff_filtered.stat))

     push!(μS, mean(stoch_filtered.stat))
     push!(σS, std(stoch_filtered.stat))
     #scatter!(filterdata.m, filterdata.stat, ma=0.4, ms=2)
    end
    pl = plot(M, title="λ = $λ, α = $α")
    plot!(aspectratio=1, frame=:box, ms=2, ma=0.1, ylim=(0,1), xlim=(0,1), label=:none)
    plot!(M, μD, ribbon=σD, label="diff")
    plot!(M, μS, ribbon=σS, label="stoch")
    xlabel!("m")
    ylabel!("PCC")
    push!(plts, pl)
    end
end

fig = plot(plts..., layout=(3,3), size=(1000,1000))
savefig(fig, "stochacstic_vs_dispersal_panels.png")
