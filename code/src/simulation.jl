
function simulate(
    dispersal::DT,
    Φ::DispersalPotential,
    st::Vector) where {DT <: DispersalModel}
    dispersal(st, Φ)
end

function simulate(localdynamics::LT,
    st::Vector) where {LT <: LocalDynamicsModel}
    localdynamics(st)
end

function simulate(
    treatment::Treatment; 
    mp::Metapopulation = treatment.metapopulation(),
    trajectory = MetapopulationTrajectory(numlocations=sizeof(mp), numtimesteps=300)
)
    localdynamics::LocalDynamicsModel = treatment.localdynamics
    dispersal::DispersalModel = treatment.dispersal

    Φ::DispersalPotential = DispersalPotential(mp; kernel=ExpKernel(dispersal.α))
    trajectory[:,1] = rand(DiscreteUniform(30, 100), sizeof(mp))

    for t = 2:length(trajectory)
        st = deepcopy(trajectory[:,t-1])
        st = simulate(dispersal, Φ, st)
        st = simulate(localdynamics, st)
        trajectory[:,t] = st
    end

    return trajectory
end

function simulate(treatment_set::TreatmentSet; summary_stats::Vector{SummaryStat} = [MeanAbundance(10),PCC(10)], numreplicates::Int=50)
    numrows = numreplicates * length(treatment_set)
    data = DataFrame(
        treatment = [i for i in 1:numrows],
    )
    for s in summary_stats
        data[!, Symbol(s)] = zeros(numrows)
    end

    row = 1
    @showprogress for (t, treatment) in enumerate(treatment_set)
        for r in 1:numreplicates
            traj::MetapopulationTrajectory = simulate(treatment)
            for s in summary_stats
                data[row, Symbol(s)] = s(traj)
            end
            data[row, :treatment] = t
            row += 1
        end
    end

    return data
end
