

struct Population
    coordinate::Vector{Float64}
end

struct Metapopulation
    populations::Vector{Population}
end

abstract type MetapopulationGenerator end

struct MetapopulationState
    abundances::Vector{Number}
end

struct MetapopulationTrajectory
    trajectory::Vector{MetapopulationState}
end

abstract type Parameter end
abstract type ParameterBundle end
abstract type ParameterValues end

abstract type LocalDynamicsModel end
abstract type DispersalModel end


"""
    Treatment
"""
struct Treatment{T <: LocalDynamicsModel, V <: DispersalModel}
    metapopulation::Union{Metapopulation, MetapopulationGenerator}
    local_dynamics_model::T
    dispersal_model::V
    Prθ::ParameterBundle{T,V}
end

struct Replicate
    metapopulation::Metapopulation
    trajectory::MetapopulationTrajectory
    θ::ParameterValues
end


"""
    DispersalPotential
"""
abstract type DispersalKernel end
struct DispersalPotential
    matrix::Matrix{Float64}
end

