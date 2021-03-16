module MetapopulationDynamics
    using Plots.RecipesBase
    using Distributions: Poisson, Uniform, DiscreteUniform, Binomial, Categorical, Normal
    using StatsBase: crosscor, mean, std
    using DataFrames: DataFrame
    using ProgressMeter
    using Distances: Euclidean, evaluate

    include(joinpath(".", "types.jl"))



    include(joinpath(".", "metapopulations.jl"))
    export Population,Metapopulation,MetapopulationGenerator,PoissonProcess

    include(joinpath(".", "trajectory.jl"))
    export MetapopulationState,MetapopulationTrajectory

    include(joinpath(".", "dispersal.jl"))
    export DispersalModel,DispersalPotential,DiffusionDispersal,StochasticDispersal,NoDispersal,ExpKernel

    include(joinpath(".", "local_dynamics.jl"))
    export LocalDynamicsModel, RickerModel, StochasticLogistic

    include(joinpath(".", "visualisation.jl"))
    include(joinpath(".", "summary_stats.jl"))
    export PCC, subsample, MeanAbundance, SummaryStat
    include(joinpath(".", "treatments.jl"))
    export Treatment,TreatmentSet,Replicate, metadata


    include(joinpath(".", "simulation.jl"))
    export simulate
end

