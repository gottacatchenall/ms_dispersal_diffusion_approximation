"""
    Population()
"""
Population(;number_of_dimensions=2) = Population(rand(Uniform(), number_of_dimensions))



"""
    Metapopulation()

    Constructs a Metapopulation.
"""
Metapopulation(;number_of_populations::Int=10) = Metapopulation([Population() for p in 1:number_of_populations])


"""
    Base Function Overloading
"""
Base.show(io::IO, pop::Population) = print(io,"Population at ", pop.coordinate)
Base.sizeof(mp::Metapopulation) = length(mp.populations)
Base.show(io::IO, mp::Metapopulation) = print(io,"Metapopulation with ", sizeof(mp), " populations")
