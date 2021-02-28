function run_simulation()
    mp = Metapopulation(number_of_populations=30)
    diffusion_model = DiffusionDispersal(m=0.8, α=3, Φ=DispersalPotential(mp, ExpKernel(α)))
    local_model = RickerModel(RickerModelParameterValues(λ=8))
    model = (current, _) -> local_model(diffusion_model(current))
    traj = MetapopulationTrajectory(accumulate(model, MetapopulationTrajectory(); init=MetapopulationState(mp)))
end

function create_treatment(
    dispersal_model::DT,
    localdynamics_model::LT,
    dispersal_params::Tuple,
    localdynamics_params::Tuple 
) where {DT <: DispersalModel, LT <: LocalDynamicsModel}
    dispersal = dispersalmodel(dispersal_params...)
    localdyn = localdynamics(localdynamics_params)

    model = dispersal + localdyn

end


