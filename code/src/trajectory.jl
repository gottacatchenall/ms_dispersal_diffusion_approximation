

MetapopulationState(; number_of_populations::Int=10, min::Int=10, max::Int=100) = MetapopulationState(rand(DiscreteUniform(min,max), (number_of_populations)))
MetapopulationState(mp::Metapopulation; min::Int=10, max::Int=100) = MetapopulationState(rand(DiscreteUniform(min,max), sizeof(mp)))

MetapopulationTrajectory(;number_of_populations::Int=10, number_of_timesteps::Int=30) = MetapopulationTrajectory([zeros(MetapopulationState(number_of_populations=number_of_populations)) for t in 1:number_of_timesteps ])


Matrix(traj::MetapopulationTrajectory) = begin
    Nₚ = length(traj.trajectory[1])
    Nₜ = length(traj)
    matrix = zeros(Nₚ, Nₜ)
    for (i,st) in enumerate(traj)
        matrix[:,i] = st.abundances
    end
    return matrix
end



Base.iterate(state::MetapopulationState) = iterate(state.abundances)
Base.iterate(state::MetapopulationState, i::Int) = iterate(state.abundances, i)
Base.iterate(trajectory::MetapopulationTrajectory) = iterate(trajectory.trajectory)
Base.iterate(trajectory::MetapopulationTrajectory, i::Int) = iterate(trajectory.trajectory, i)


Base.:*(mat::Matrix, st::MetapopulationState) = mat * st.abundances
Base.zeros(state::MetapopulationState; number_of_populations::Int=10) = MetapopulationState([0 for p in 1:number_of_populations])

Base.show(io::IO, traj::MetapopulationTrajectory) = print(io,"Trajectory with ", length(traj.trajectory), " timesteps")
Base.length(trajectory::MetapopulationTrajectory) = length(trajectory.trajectory)
Base.length(state::MetapopulationState) = length(state.abundances)
