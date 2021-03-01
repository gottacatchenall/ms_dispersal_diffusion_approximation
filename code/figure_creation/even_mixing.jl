using MetapopulationDynamics

rickerparams = (λ = collect(8), χ=0.03, R=0.9)
dispersalparams = (m = 0.0:0.01:1, α = 0:3:12)
metapop_generator = PoissonProcess(L = 30)

params = collect(rickerparams, dispersalparams, metapop_generator)

dispersalmodel = DiffusionDispersal
localmodel = RickerModel

treatments = createtreatments(metapop_generator, dispersalmodel, localmodel)
