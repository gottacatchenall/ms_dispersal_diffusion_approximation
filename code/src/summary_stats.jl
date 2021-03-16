function subsample(traj::MetapopulationTrajectory, frequency::Int)
    subsamplelength::Int = floor(length(traj) / frequency)

    traj_matrix = traj.trajectory
    Nₚ = length(traj_matrix[:,1])
    samp = zeros( Nₚ, subsamplelength)

    for t in 1:subsamplelength
        samp[:, t] = traj_matrix[:, t*frequency]
    end
    return samp
end

function (pcc::PCC)(traj::MetapopulationTrajectory)
    #matrix = subsample(traj, pcc.subsample_frequency)
    matrix = traj.trajectory
    Nₚ = length(matrix[:,1])
    mean_cc::Float64 = 0.0
    s::Float64 =0.0
    ct = 0

    for p1 in 1:Nₚ 
        for p2 in 1:Nₚ
            if (p1 != p2)
                cc = crosscor(matrix[p1,:], matrix[p2,:],[0])
                s += cc[1]
                ct += 1
            end
        end
    end
    mean_cc = s/ct
    return mean_cc
end