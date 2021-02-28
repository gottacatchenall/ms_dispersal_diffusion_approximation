function run_simulation()
    mp = Metapopulation(number_of_populations=30)
    diffusion_model = DiffusionDispersal(m=0.8, Φ=DispersalPotential(mp, ExpKernel(3)))
    local_model = RickerModel(RickerModelParameterValues(λ=8))
    model = (current, _) -> local_model(diffusion_model(current))
    traj = MetapopulationTrajectory(accumulate(model, MetapopulationTrajectory(); init=MetapopulationState(mp)))
end
