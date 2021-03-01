using MetapopulationDynamics

rickerparams = (λ = collect(2:0.5:10), χ=0.03, R=0.9)
dispersalparams = (m = 0.0:0.01:1, α = 3.0)

params = merge(rickerparams, dispersalparams)


treatments = TreatmentSet(
    PoissonProcess(numlocations = 30),
    DiffusionDispersal, 
    RickerModel,
    params
)

t = treatments.treatments[1]

simulate(t)

