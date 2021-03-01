function simulate(treatment::Treatment)
    mp::Metapopulation = treatment.metapopulation()
    localdynamics::LocalDynamicsModel = treatment.localdynamics
    dispersal::DispersalModel = treatment.dispersal

    potential::DispersalPotential = DispersalPotential(mp, ExpKernel(dispersal.α))

    model = (current, _) -> localdynamics(dispersal(current, potential, dispersal.m))
    traj = MetapopulationTrajectory(accumulate(model, MetapopulationTrajectory(); init=MetapopulationState(mp)))
    
    
    return traj
end

