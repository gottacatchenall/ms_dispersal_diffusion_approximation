
"""
    RickerModel
"""
struct RickerModelParameterValues <: ParameterValues
    λ::Number
    χ::Number
    R::Number
end
struct RickerModel <: LocalDynamicsModel
    θ::RickerModelParameterValues
end

RickerModel(; θ::RickerModelParameterValues=RickerModelParameterValues()) = RickerModel(θ)
RickerModelParameterValues(; λ::Number=5, χ::Number=0.03, R::Number=0.9) = RickerModelParameterValues(λ, χ, R)

(ricker::RickerModel)(N::Number) = (rand(Poisson(N * ricker.θ.λ * ricker.θ.R * exp(-1*N*ricker.θ.χ))))
(ricker::RickerModel)(state::MetapopulationState) = MetapopulationState(map(i -> ricker(i), state.abundances))