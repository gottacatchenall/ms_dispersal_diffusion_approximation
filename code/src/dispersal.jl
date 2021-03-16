
"""
    DispersalPotential
"""
(kernel::ExpKernel)(pop1::Population, pop2::Population) = exp(-1*kernel.α*evaluate(Euclidean(), pop1.coordinate, pop2.coordinate) )


Base.sizeof(potential::DispersalPotential) = size(potential.matrix)
Base.show(io::IO, potential::DispersalPotential) = print(io, sizeof(potential)[1], "x",  sizeof(potential)[2], " dispersal potential")
Base.getindex(potential::DispersalPotential, i::Int64, j::Int64) = potential.matrix[i,j]

Base.getindex(potential::DispersalPotential, i::Int64, ::Colon) = potential.matrix[i,:]

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
    α::Number
    m::Float64
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



"""
    Stochastic Model of Dispersal
"""
struct StochasticDispersal <: DispersalModel
    α::Number
    m::Float64
end

Base.show(io::IO, dispersal_model::StochasticDispersal) = print(io, "Stochastic dispersal model with ", dispersal_model.α, " and m=", dispersal_model.m)
StochasticDispersal(params::NamedTuple) = StochasticDispersal(params.α, params.m)

"""
    No Dispersal
"""
struct NoDispersal <: DispersalModel
    α::Number
    m::Float64
end
NoDispersal(params::NamedTuple) = NoDispersal(params.α, params.m)


# implementation
function (dispersal_model::DiffusionDispersal)(state, Φ)
    D = DiffusionMatrix(Φ, dispersal_model.m)
    state = floor.(D*state)
    return state
end

# implementation
function (dispersal_model::StochasticDispersal)(state, Φ)
    delta = zeros(length(state))

    for (l,ab) in enumerate(state)
        Nₘ = rand(Binomial(ab,dispersal_model.m))
        for i in 1:Nₘ
            if (sum(Φ[l,:]) ≈ 1)
                new_home = rand(Categorical(Φ[l, :]))
                delta[new_home] += 1
                delta[l] -= 1
            end
        end
    end
    ret = state .+ delta
    return ret
end
