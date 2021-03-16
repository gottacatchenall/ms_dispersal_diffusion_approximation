
"""
    RickerModel
"""
struct RickerModel <: LocalDynamicsModel
    λ::Number
    χ::Number
    R::Number
end

RickerModel(params::NamedTuple) = RickerModel(params.λ, params.χ, params.R)

function (ricker::RickerModel)(N::Number) 
    if (N > 0) 
        mn = N * ricker.R * ricker.λ * exp(-1*N*ricker.χ)
        return rand(Poisson(mn)) 
    end
    return 0
end


function (ricker::RickerModel)(state)
    ret = copy(state)
    for i in 1:length(state)
        ret[i] = ricker(state[i])
    end
    return ret
end


struct StochasticLogistic <: LocalDynamicsModel
    λ::Number
    K::Number
    σ::Number
    Δt::Number
end

StochasticLogistic(params::NamedTuple) = StochasticLogistic(params.λ, params.K, params.σ, params.Δt)

function (stochlog::StochasticLogistic)(N::Number)
    if (N > 0)
        dndt =  stochlog.λ * N * (1.0 - (N/stochlog.K))
        dndw = rand(Normal(0, stochlog.σ * N))
        return N + (dndt+dndw)*stochlog.Δt
    end
    return 0
end

function (stochlog::StochasticLogistic)(state)    
    for i in 1:length(state)
        state[i] = floor(stochlog(state[i]))
    end
    return state
end

