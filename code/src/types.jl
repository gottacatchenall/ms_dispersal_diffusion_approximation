
"""
    LocalDynamicsModel
"""
abstract type LocalDynamicsModel end

"""
    DispersalModel
"""
abstract type DispersalModel end


"""
    DispersalKernel
"""
abstract type DispersalKernel end

"""
    Parameter
"""
abstract type Parameter end

"""
    Priors
"""
abstract type Priors{T,V} end

"""
    ParameterValues
"""
abstract type ParameterValues end



"""
    Population

    TODO
"""
struct Population
    coordinate::Vector{Float64}
end

"""
    Metapopulation

    TODO
"""
struct Metapopulation
    populations::Vector{Population}
end

"""
    MetapopulationGenerator

    TODO
"""
abstract type MetapopulationGenerator end


"""
    MetapopulationTrajectory

    TODO
"""
struct MetapopulationTrajectory
    trajectory::Array{NT, 2} where {NT <: Real}
end



"""
    Treatment

    TODO
"""
struct Treatment
    metapopulation::Union{Metapopulation, MetapopulationGenerator}
    dispersal::DispersalModel
    localdynamics::LocalDynamicsModel
end

""" 
    TreatmentSet

    TODO 
"""
struct TreatmentSet
    metadata::DataFrame
    treatments::Vector{Treatment}
end


"""
    PCC

    TODO
"""
abstract type SummaryStat end
struct PCC <: SummaryStat 
    subsample_frequency::Int
end
struct MeanAbundance <: SummaryStat 
    subsample_frequency::Int
end

"""
    DispersalPotential

    todo
"""
struct DispersalPotential
    matrix::Matrix{Float64}
end

struct ExpKernel <: DispersalKernel
    α::Float64
    ExpKernel(α::Number) = new(α)
end
