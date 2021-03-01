using MetapopulationDynamics

rickerparams = (λ = collect(2:0.25:12), χ=0.03, R=0.9)
dispersalparams = (m = 0.1, α = 3.0)
metapop_generator = PoissonProcess(numlocations = 30)

treatments = createtreatments(metapop_generator, dispersalmodel, localmodel)
