using MetapopulationDynamics
using Plots

computelw(α, m, dist) =  min(10exp(-α*dist) + m, 3)
computela(α, m, dist) = min(exp(-α*dist) + 0.1m, 0.8)

function plotmp(mp; α=10, m =0.01)
    plt = plot(frame=:box, aspectratio=1, legend=nothing)
    xlims!(0,1)
    ylims!(0,1)
    coords = zeros(sizeof(mp), 2)
    for (i,p) in enumerate(mp.populations)
        coords[i,:] = p.coordinate 
    end

    for p1 in 1:sizeof(mp)
        for p2 in 1:sizeof(mp)
            if p1 != p2
                x,y = [coords[p1,1], coords[p2,1]], [coords[p1,2], coords[p2,2]]

                dist = sqrt(sum((coords[p1,:] .- coords[p2,:]).^2))

                lw = computelw(α, m, dist)
                la = computela(α, m, dist)
                plot!(plt, x,y, lw=lw, la=la, lc=:grey)
            end
        end
    end
    scatter!(coords[:,1], coords[:,2], ms = 7.5)

    plt
end


mp = PoissonProcess(numlocations = 20)

λ = 15
χ = 0.03
R = 1

lowsync = Treatment(mp, DiffusionDispersal(9, 0.01), RickerModel(λ, χ, R))
midsync = Treatment(mp, DiffusionDispersal(6, 0.25), RickerModel(λ, χ, R))
hisync = Treatment(mp, DiffusionDispersal(0, 0.7), RickerModel(λ, χ, R))

lowplt = plot(subsample(simulate(lowsync), 10)', frame=:box, xlabel=("Sample Time"), ylabel="Abundance", legend=:none)
midplt = plot(subsample(simulate(midsync), 10)', frame=:box, xlabel=("Sample Time"), ylabel="Abundance", legend=:none)
hiplt = plot(subsample(simulate(hisync), 10)', frame=:box, xlabel=("Sample Time"), ylabel="Abundance", legend=:none)
lowmpplt = plotmp(mp(), α=10, m=0.01)
midmpplt = plotmp(mp(), α=5, m=0.1)
himpplot = plotmp(mp(), α=3, m=0.25)

plts = [lowmpplt, midmpplt, himpplot, lowplt,midplt,hiplt]

combinedplt = plot(plts..., layout=(2,3), size=(1500, 800))

savefig(combinedplt, "metapops_synchrony_example.png")