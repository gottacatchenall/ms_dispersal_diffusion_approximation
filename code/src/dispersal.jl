
"""
    DispersalPotential
"""
(kernel::ExpKernel)(dist::Number, alpha::Number) = exp(-1*dist*alpha)
(kernel::ExpKernel)(pop1::Population, pop2::Population) = exp(-1*kernel.α*evaluate(Euclidean(), pop1.coordinate, pop2.coordinate) )


Base.sizeof(potential::DispersalPotential) = size(potential.matrix)
Base.show(io::IO, potential::DispersalPotential) = print(io, sizeof(potential)[1], "x",  sizeof(potential)[2], " dispersal potential")
Base.getindex(potential::DispersalPotential, i::Int64, j::Int64) = potential.matrix[i,j]

"""
    DispersalPotential(metapopulation::Metapopulation; kernel=ExpKernel())
"""
DispersalPotential(metapopulation::Metapopulation; kernel=ExpKernel(3)) = begin
    Nₚ = sizeof(metapopulation)
    potential::Matrix = zeros(Nₚ, Nₚ)
    for i in 1:Nₚ, j in 1:Nₚ
        potential[i,j] = (i==j) ? 0 : kernel(metapopulation.populations[i], metapopulation.populations[j])
    end
    for i in 1:Nₚ
        potential[i,:] = (sum(potential[i,:]) == 0) ? zeros(Nₚ) : potential[i,:] / sum(potential[i,:])
    end
    return DispersalPotential(potential)
end

DispersalPotential(metapopulation::Metapopulation, kernel::DispersalKernel) = DispersalPotential(metapopulation, kernel=kernel)
DispersalPotential(; metapopulation::Metapopulation=Metapopulation()) = DispersalPotential(metapopulation)


"""
    Diffusion model of dispersal
"""
# Diffusion dispersal model
struct DiffusionDispersal <: DispersalModel
    m::Float64
    α::Number
end
Base.show(io::IO, dispersal_model::DispersalModel) = print(io, "Dispersal model with α = ", dispersal_model.α, ", m = ", dispersal_model.m)

DiffusionDispersal(params::NamedTuple) = begin
    # todo assert these exist
    α = params.α
    m = params.m
    return DiffusionDispersal(α, m)
end



DiffusionMatrix(Φ::DispersalPotential, m::Number) = begin
    Nₚ = sizeof(Φ)[1]
    D::Matrix = zeros(Nₚ, Nₚ)   # diffusion matrix
    for i in 1:Nₚ, j in 1:Nₚ
        D[i,j] = (i==j) ? (1.0-m) : m*Φ[i,j]
    end
    return D
end

# implementation
(dispersal_model::DiffusionDispersal)(state::MetapopulationState, Φ::DispersalPotential, m::Float64) = begin
    D = DiffusionMatrix(Φ, m)
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
        @assert 1 == 0
    end
    return MetapopulationState()
end
