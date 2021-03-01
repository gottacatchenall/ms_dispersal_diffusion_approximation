
"""
    RickerModel
"""
struct RickerModel <: LocalDynamicsModel
    λ::Number
    χ::Number
    R::Number
end

RickerModel(params::NamedTuple) = RickerModel(params.λ, params.χ, params.R)


(ricker::RickerModel)(N::Number) = (N > 0) ? rand(Poisson(N * ricker.λ * ricker.R * exp(-1*N*ricker.χ))) : 0
(ricker::RickerModel)(state::MetapopulationState) = MetapopulationState(map(i -> ricker(i), state.abundances))