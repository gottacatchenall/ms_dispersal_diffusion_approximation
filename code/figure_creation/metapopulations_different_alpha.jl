using MetapopulationDynamics

rickerparams = (λ = collect(2:0.25:12), χ=0.03, R=0.9)
dispersalparams = (m = 0.0:0.01:1, α = 0:3:12)
metapop_generator = PoissonProcess(L = 30)
