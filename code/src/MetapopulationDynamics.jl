module MetapopulationDynamics
    using Plots.RecipesBase
    using Distributions    
    using Distances: Euclidean, evaluate
    include(joinpath(".", "types.jl"))

    include(joinpath(".", "metapopulations.jl"))
    include(joinpath(".", "trajectory.jl"))
    include(joinpath(".", "dispersal.jl"))
    include(joinpath(".", "local_dynamics.jl"))
    include(joinpath(".", "visualisation.jl"))
    include(joinpath(".", "summary_stats.jl"))

    include(joinpath(".", "treatments.jl"))


end
