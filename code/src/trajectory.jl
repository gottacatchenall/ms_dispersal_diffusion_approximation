
MetapopulationTrajectory(;numlocations::Int=10, numtimesteps::Int=300) = MetapopulationTrajectory(zeros(numlocations, numtimesteps))

Base.show(io::IO, traj::MetapopulationTrajectory) = print(io,"Trajectory with ", length(traj.trajectory), " timesteps")
Base.length(trajectory::MetapopulationTrajectory) = length(trajectory.trajectory[1,:])
Base.getindex(traj::MetapopulationTrajectory, ::Colon, i::Int64) = traj.trajectory[:,i]
Base.getindex(traj::MetapopulationTrajectory, i::Int64, ::Colon) = traj.trajectory[i,:]
Base.setindex!(traj::MetapopulationTrajectory, value, ::Colon, i::Int64) = Base.setindex!(traj.trajectory, value, :, i)
