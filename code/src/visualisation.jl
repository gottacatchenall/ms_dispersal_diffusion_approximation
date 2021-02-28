using Plots

Plots.plot(traj::MetapopulationTrajectory) = begin
    matrix = Matrix(traj)
    plot(matrix)
end