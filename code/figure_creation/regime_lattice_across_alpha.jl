using Pkg
Pkg.activate("../")


using MetapopulationDynamics
using Plots, DataFrames
using StatsBase: mean, quantile, std

rickerparams = (λ = collect(5:0.25:30), χ=0.03, R=0.9)
dispersalparams = (m = [0.01, 0.1, 0.25, 0.5], α = 0:0.25:25)
params = merge(rickerparams, dispersalparams)


diffTreatments = TreatmentSet(
    PoissonProcess(numlocations = 10),
    DiffusionDispersal, 
    RickerModel,
    params
)


stochTreatments = TreatmentSet(
    PoissonProcess(numlocations = 10), 
    StochasticDispersal,
    RickerModel,
    params
)

diffusion_data = simulate(diffTreatments; numreplicates=10)
stoch_data = simulate(stochTreatments; numreplicates=10)


stoch_df = innerjoin(stoch_data, stochTreatments.metadata, on=:treatment)
diff_df = innerjoin(diffusion_data, diffTreatments.metadata, on=:treatment)

M = unique(stoch_df, :m).m
Λ = unique(stoch_df, :λ).λ
A = unique(stoch_df, :α).α

plts = []
for m in M
    mat = zeros(length(Λ), length(A))
    for (l, λ) in enumerate(Λ)
        for (a, α) in enumerate(A)
            stoch_filtered = filter(row -> row[:λ] == λ && row[:m] == m && row[:α] == α, stoch_df)
            diff_filtered = filter(row -> row[:λ] == λ && row[:m] == m && row[:α] == α, diff_df)
            pcc_diff = abs(mean(diff_filtered.stat) - mean(stoch_filtered.stat))    

            mat[l,a] = pcc_diff

        end
    end
    pl = contourf(A, Λ, mat, title="m=$m",lim=(0,1))
    xlabel!("α")
    ylabel!("λ")
    push!(plts, pl)
end

plt = plot(plts..., layout=(2,2), size=(1000,1000))
savefig(plt, "raster.png")

heatmap(zeros(30, 10))
