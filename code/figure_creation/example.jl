using MetapopulationDynamics

# RickerModel Params
params = (λ = collect(2:0.5:10), χ=0.03, R=0.9)

# Dispersal Params 
(m = 0.0:0.01:1, α = 3.0)

# Spatial Graph Params
(L=20)