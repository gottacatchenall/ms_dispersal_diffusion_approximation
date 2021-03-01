function metadata(params::NamedTuple)
    names = []
    vals = []
    md = DataFrame(treatment = [])

    for (param_name, param_values) in zip(keys(params), params)
        push!(names, param_name)
        push!(vals, param_values)
        md[!,  Symbol(param_name)] = []
    end
    ct = 1

    for p in Iterators.product(vals...)
        for (i, val) in enumerate(p)
            param = names[i]
            push!(md[!, Symbol(param)], val)
        end
        push!(md.treatment, ct)
        ct += 1
    end
    return(md)
end


function TreatmentSet(
    metapop::Union{Metapopulation, MetapopulationGenerator},
    dispersal::DT,
    localdynamics::LT,
    params::NamedTuple
) where {DT <: typeof(DispersalModel), LT <: typeof(LocalDynamicsModel)}

    md = metadata(params)
    vector::Array{Union{typeof(nothing), Treatment}} = [nothing for i in 1:length(md[:,1]) ]

    for (i,row) in enumerate(eachrow(md))
        params = NamedTuple(row)

        disp::DispersalModel = dispersal(params)
        localdyn::LocalDynamicsModel = localdynamics(params)

        vector[i] = Treatment(metapop, disp, localdyn)
    end
    TreatmentSet(md, vector)
end
Base.getindex(ts::TreatmentSet, index::Int) = ts.treatments[index]
Base.show(io::IO, ts::TreatmentSet) = print(io,"treatment set containing ", length(ts.treatments), " treatments")
