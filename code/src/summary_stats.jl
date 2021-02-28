function pcc(traj::MetapopulationTrajectory)
    matrix = Matrix(traj)
    Nₚ = length(traj.trajectory[1])
    mean_cc::Float64 = 0.0
    s::Float64 =0.0
    for p1 in 1:Nₚ, p2 in (p1+1):Nₚ
        cc = crosscor(matrix[p1,:], matrix[p2,:],[0])
        s += cc[1]
    end
    mean_cc = s/(Nₚ*(Nₚ-1) * 0.5)
    return mean_cc
end