"""
    Population()
"""
Population(;number_of_dimensions=2) = Population(rand(Uniform(), number_of_dimensions))



"""
    Metapopulation()

    Constructs a Metapopulation.
"""
Metapopulation(;numlocations::Int=10) = Metapopulation([Population() for p in 1:numlocations])


struct PoissonProcess <: MetapopulationGenerator
    numlocations::Int
    PoissonProcess(;numlocations::Number=20) = new(numlocations)
end
(proc::PoissonProcess)() = Metapopulation(numlocations=proc.numlocations)


"""
    Base Function Overloading
"""
Base.show(io::IO, pop::Population) = print(io,"Population at ", pop.coordinate)
Base.sizeof(mp::Metapopulation) = length(mp.populations)
Base.show(io::IO, mp::Metapopulation) = print(io,"Metapopulation with ", sizeof(mp), " populations")
