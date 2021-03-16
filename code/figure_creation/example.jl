using MetapopulationDynamics
using Plots


mp = PoissonProcess(numlocations=10)
t = Treatment(mp, DiffusionDispersal(0, 0.7), RickerModel(15, 0.03, 0.9))


t = Treatment(mp, StochasticDispersal(0,0.9), RickerModel(15, 0.03, 0.9))
traj = simulate(t)

traj.trajectory

plot(subsample(traj,10)')
PCC(10)(traj)
