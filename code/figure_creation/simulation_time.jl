using Pkg
Pkg.activate("../")


using MetapopulationDynamics
using Plots, DataFrames
using ProgressMeter
using StatsBase: mean, quantile, std


function time_simulations(m; numreplicates = 100, max_numlocations=30)

    rickerparams = (λ = 10, χ=0.03, R=1.0)
    dispersalparams = (m = m, α = 0)
    params = merge(rickerparams, dispersalparams)
    
    
    numpops = []
    diffusion_runtime = []
    stochastic_runtime = []
    mig = []

    @showprogress for np in 2:max_numlocations
        diffTreatments = TreatmentSet(
            PoissonProcess(numlocations = np),
            DiffusionDispersal, 
            RickerModel,
            params
        )
        stochTreatments = TreatmentSet(
            PoissonProcess(numlocations = np), 
            StochasticDispersal,
            RickerModel,
            params
        )

        difftime = (@elapsed simulate(diffTreatments; numreplicates=numreplicates))  / numreplicates
        stochtime = (@elapsed simulate(stochTreatments; numreplicates=numreplicates))  / numreplicates

        push!(numpops, np)
        push!(mig, params.m)
        push!(diffusion_runtime, difftime)
        push!(stochastic_runtime, stochtime)
    end
    return (numpops, diffusion_runtime, stochastic_runtime)
end



migs = [0.01, 0.05, 0.1, 0.25]

colvec = palette(:tab10)

stochshapevec = [:circle, :diamond, :utriangle, :rect]
diffshapevec = [ :cross, :xcross, :+, :x]

plt = plot()
nr = 50
maxnl = 100
xlabel!(plt, "Number of locations in simulation")
ylabel!(plt, "Mean run time per replicate")
for (i,m) in enumerate(migs) 
    (numpops, diffusionvec, stochvec) = time_simulations(m, max_numlocations=maxnl, numreplicates=nr)
    scatter!(plt, numpops, stochvec, msize=5, mc=colvec[i], shape=stochshapevec[i], label="stochastic dispersal, m = $m")
    scatter!(plt, numpops, diffusionvec, msize=5, markerstrokewidth=0, mc=colvec[i],  shape=diffshapevec[i], label="diffusion, m = $m")
end
plot!(plt, yaxis=:log10, legend=:outerright, fontfamily="Roboto", size=(1200, 800))
xlims!(plt, 2,maxnl)
plt

savefig(plt, "runtime.png")