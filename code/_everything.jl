using Distributions, Distances, Plots, StatsBase

"""
    Metapopulation
"""
struct Population
    coordinate::Vector{Float64}
end
Population(;number_of_dimensions=2) = Population(rand(Uniform(), number_of_dimensions))
Base.show(io::IO, pop::Population) = print(io,"Population at ", pop.coordinate)


struct Metapopulation
    populations::Vector{Population}
end
Metapopulation(;number_of_populations::Int=10) = Metapopulation([Population() for p in 1:number_of_populations])
Base.sizeof(mp::Metapopulation) = length(mp.populations)
Base.show(io::IO, mp::Metapopulation) = print(io,"Metapopulation with ", sizeof(mp), " populations")


abstract type MetapopulationGenerator end

struct MetapopulationState
    abundances::Vector{Number}
end
MetapopulationState(; number_of_populations::Int=10, min::Int=10, max::Int=100) = MetapopulationState(rand(DiscreteUniform(min,max), (number_of_populations)))
MetapopulationState(mp::Metapopulation; min::Int=10, max::Int=100) = MetapopulationState(rand(DiscreteUniform(min,max), sizeof(mp)))
Base.:*(mat::Matrix, st::MetapopulationState) = mat * st.abundances
Base.zeros(state::MetapopulationState; number_of_populations::Int=10) = MetapopulationState([0 for p in 1:number_of_populations])
Base.length(state::MetapopulationState) = length(state.abundances)
Base.iterate(state::MetapopulationState) = iterate(state.abundances)
Base.iterate(state::MetapopulationState, i::Int) = iterate(state.abundances, i)


struct MetapopulationTrajectory
    trajectory::Vector{MetapopulationState}
end
Base.show(io::IO, traj::MetapopulationTrajectory) = print(io,"Trajectory with ", length(traj.trajectory), " timesteps")

MetapopulationTrajectory(;number_of_populations::Int=10, number_of_timesteps::Int=30) = MetapopulationTrajectory([zeros(MetapopulationState(number_of_populations=number_of_populations)) for t in 1:number_of_timesteps ])
Base.iterate(trajectory::MetapopulationTrajectory) = iterate(trajectory.trajectory)
Base.iterate(trajectory::MetapopulationTrajectory, i::Int) = iterate(trajectory.trajectory, i)
Base.length(trajectory::MetapopulationTrajectory) = length(trajectory.trajectory)


"""
    Parameters
"""
abstract type Parameter end
abstract type ParameterBundle{T,V} end
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
struct ExpKernel <: DispersalKernel end
(kernel::ExpKernel)(dist::Number, alpha::Number) = exp(-1*dist*alpha)
(kernel::ExpKernel)(pop1::Population, pop2::Population; α::Number=3.0) = exp(-1*α*evaluate(Euclidean(), pop1.coordinate, pop2.coordinate) )

struct DispersalPotential
    matrix::Matrix{Float64}
end
Base.sizeof(potential::DispersalPotential) = size(potential.matrix)
Base.show(io::IO, potential::DispersalPotential) = print(io, sizeof(potential)[1], "x",  sizeof(potential)[2], " dispersal potential")
Base.getindex(potential::DispersalPotential, i::Int64, j::Int64) = potential.matrix[i,j]

DispersalPotential(metapopulation::Metapopulation; kernel=ExpKernel(), α=3) = begin
    Nₚ = sizeof(metapopulation)
    potential::Matrix = zeros(Nₚ, Nₚ)
    for i in 1:Nₚ, j in 1:Nₚ
        potential[i,j] = (i==j) ? 0 : kernel(metapopulation.populations[i], metapopulation.populations[j], α=α)
    end
    for i in 1:Nₚ
        potential[i,:] = (sum(potential[i,:]) == 0) ? zeros(Nₚ) : potential[i,:] / sum(potential[i,:])
    end
    return DispersalPotential(potential)
end


DispersalPotential(; metapopulation::Metapopulation=Metapopulation()) = DispersalPotential(metapopulation)

"""
    RickerModel
"""
struct RickerModelParameterValues <: ParameterValues
    λ::Number
    χ::Number
    R::Number
end
RickerModelParameterValues(; λ::Number=5, χ::Number=0.03, R::Number=0.9) = RickerModelParameterValues(λ, χ, R)
struct RickerModel <: LocalDynamicsModel
    θ::RickerModelParameterValues
end
RickerModel(; θ::RickerModelParameterValues=RickerModelParameterValues()) = RickerModel(θ)

(ricker::RickerModel)(N::Number) = (rand(Poisson(N * ricker.θ.λ * ricker.θ.R * exp(-1*N*ricker.θ.χ))))
(ricker::RickerModel)(state::MetapopulationState) = MetapopulationState(map(i -> ricker(i), state.abundances))

"""
    Diffusion model of dispersal
"""
# Diffusion dispersal model
struct DiffusionDispersal <: DispersalModel
    Φ::DispersalPotential
    m::Float64
end
Base.show(io::IO, dispersal_model::DispersalModel) = print(io, "Dispersal model with \n\t", dispersal_model.Φ, "\n\tm=", dispersal_model.m)
DiffusionDispersal(;Φ=DispersalPotential(), m::Float64=0.1 ) = DiffusionDispersal(Φ, m)

DiffusionMatrix(Φ::DispersalPotential, m::Number) = begin
    Nₚ = sizeof(Φ)[1]
    D::Matrix = zeros(Nₚ, Nₚ)   # diffusion matrix
    for i in 1:Nₚ, j in 1:Nₚ
        D[i,j] = (i==j) ? (1.0-m) : m*Φ[i,j]
    end
    return D
end

# implementation
(dispersal_model::DiffusionDispersal)(state::MetapopulationState) = begin
    D = DiffusionMatrix(dispersal_model.Φ, dispersal_model.m)
    return MetapopulationState(D*state)
end


"""
    Stochastic Model of Dispersal
"""
struct StochasticDispersal <: DispersalModel
    Φ::DispersalPotential
    m::Float64
end
Base.show(io::IO, dispersal_model::StochasticDispersal) = print(io, "Stochastic dispersal model with \n\t", dispersal_model.Φ, "\n\tm=", dispersal_model.m)
StochasticDispersal(;Φ=DispersalPotential(), m::Float64=0.1 ) = StochasticDispersal(Φ, m)
# implementation
(dispersal_model::StochasticDispersal)(state::MetapopulationState) = begin
    for ab in state
        Nₘ = rand(Binomial())
    end
    return MetapopulationState()
end

function run_simulation()
    mp = Metapopulation(number_of_populations=30)
    diffusion_model = DiffusionDispersal(m=0.8, Φ=DispersalPotential(mp, α=0))
    local_model = RickerModel(RickerModelParameterValues(λ=8))
    model = (current, _) -> local_model(diffusion_model(current))
    traj = MetapopulationTrajectory(accumulate(model, MetapopulationTrajectory(); init=MetapopulationState(mp)))
end

Plots.plot(traj::MetapopulationTrajectory) = begin
    matrix = Matrix(traj)
    plot(matrix)
end

Matrix(traj::MetapopulationTrajectory) = begin
    Nₚ = length(traj.trajectory[1])
    Nₜ = length(traj)
    matrix = zeros(Nₚ, Nₜ)
    for (i,st) in enumerate(traj)
        matrix[:,i] = st.abundances
    end
    return matrix
end

function pcc(traj::MetapopulationTrajectory)
    matrix = Matrix(traj)
    Nₚ = length(traj.trajectory[1])
    mean_cc::Float64 = 0.0
    s::Float64 =0.0
    for p1 in 1:Nₚ, p2 in (p1+1):Nₚ
        cc = crosscor(matrix[p1,:], matrix[p2,:],[0])
        s += cc[1]
    end
    mean_cc = s/(Nₚ*(Nₚ-1) * 0.5)
    return mean_cc
end
