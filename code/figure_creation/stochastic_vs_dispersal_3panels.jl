using MetapopulationDynamics

rickerparams = (λ = collect(2,5,8), χ=0.03, R=0.9)
dispersalparams = (m = 0.0:0.01:1, α = 3.0)
metapop_generator = PoissonProcess(L = 30)

treatments = createtreatments(metapop_generator, dispersalmodel, localmodel)
