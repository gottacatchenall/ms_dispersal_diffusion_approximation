module MetapopulationDynamics
    using Plots.RecipesBase
    using Distributions: Poisson, Uniform, DiscreteUniform
    using DataFrames: DataFrame
    using Distances: Euclidean, evaluate

    include(joinpath(".", "types.jl"))

    

    include(joinpath(".", "metapopulations.jl"))
    export Population,Metapopulation,MetapopulationGenerator,PoissonProcess

    include(joinpath(".", "trajectory.jl"))
    export MetapopulationState,MetapopulationTrajectory

    include(joinpath(".", "dispersal.jl"))
    export DispersalModel,DispersalPotential,DiffusionDispersal,StochasticDispersal, ExpKernel

    include(joinpath(".", "local_dynamics.jl"))
    export LocalDynamicsModel, RickerModel

    include(joinpath(".", "visualisation.jl"))
    include(joinpath(".", "summary_stats.jl"))

    include(joinpath(".", "treatments.jl"))
    export Treatment,TreatmentSet,Replicate, metadata


    include(joinpath(".", "simulation.jl"))
    export simulate
end
