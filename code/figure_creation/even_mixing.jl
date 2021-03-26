using Pkg
Pkg.activate("../")


using MetapopulationDynamics
using Plots, DataFrames
using StatsBase: mean, quantile, std

rickerparams = (λ = 8, χ=0.03, R=0.9)
dispersalparams = (m = 0.01:0.01:1, α =[0, 3, 6, 9])
params = merge(rickerparams, dispersalparams)

mcritvec = []
alphavec = []
npvec = []

for np = 2:25
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

        # have to compute the mean here 
        diff_filtered = filter(row -> row["PCC(10)"] == max(this_alpha["PCC(10)"]...) , this_alpha)
        push!(mcritvec, diff_filtered.m[1])
        push!(alphavec, α)
        push!(npvec, np)
    end
end
df = DataFrame(m=mcritvec, α=alphavec, np=npvec)


plts = []
for α in [0,3,6,9]
    this_alpha = filter(row -> row[:α] == α, df)

    pl = plot( (x) -> 1-(1/(x-1)), ylims=(0.5,1), xlims=(2,25), fontfamily="Helvetica", dpi=144, title="α = $α", lc=:darkgrey, lw=2,frame=:box, legend=nothing)
    xlabel!(pl, "Number of locations in simulation")
    ylabel!(pl, "Value of migration that maximizes PCC")
    scatter!(pl, this_alpha.np, this_alpha.m, mc=:teal, ms=5, msc=:teal)
    push!(plts, pl)
end


panels = plot(plts..., size=(1200,800))
savefig(panels, "evenmixing.png")
