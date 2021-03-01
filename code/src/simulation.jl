function simulate(treatment::Treatment)
    mp::Metapopulation = treatment.metapopulation()
    localdynamics::LocalDynamicsModel = treatment.localdynamics
    dispersal::DispersalModel = treatment.dispersal

    potential::DispersalPotential = DispersalPotential(mp, ExpKernel(dispersal.α))

    model = (current, _) -> localdynamics(dispersal(current, potential, dispersal.m))
    traj = MetapopulationTrajectory(accumulate(model, MetapopulationTrajectory(); init=MetapopulationState(mp)))
    
    
    return traj
end

function simulate(treatment_set::TreatmentSet; summary_stat::SummaryStat = PCC(), numreplicates::Int=50)
    numrows = numreplicates * length(treatment_set)
    data = DataFrame(
        treatment = [i for i in 1:numrows], 
        stat = zeros(numrows)
    )
    
    row = 1
    @showprogress for (t, treatment) in enumerate(treatment_set)
        for r in 1:numreplicates
            traj::MetapopulationTrajectory = simulate(treatment)
            data[row, :stat] = summary_stat(traj)
            data[row, :treatment] = t
            row += 1
        end
    end

    return data
end