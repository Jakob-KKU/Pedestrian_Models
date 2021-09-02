include("./struct.jl")
include("./vectors.jl")
include("./initialize_system.jl")
include("./neighbors.jl")
include("./initialize_geometry.jl")
include("./mengen.jl")
include("./plot_functions.jl")

include("./observables.jl")

include("./distance_based_model_base_functions.jl")
include("./distance_based_model_direction.jl")
include("./distance_based_model_velocity.jl")
include("./distance_based_model_complete.jl")

include("./ttc.jl")
include("./ttc_based_model_velocity.jl")
include("./ttc_based_model_complete.jl")

function start_simulation(menge, geometrie, sim_p, velocity_model, boundaries, system_size=(0,0))

    model = string("simulate_model_" ,velocity_model)
    u = getfield(Main, Symbol(model))

    if boundaries == "periodic"

        if system_size == (0,0)
            println("For periodic boundaries a system size is needed.")
            return false, false
        else
            u(menge, geometrie, sim_p[1],sim_p[2],sim_p[3],sim_p[4],sim_p[5], system_size)
        end

    else
        u(menge, geometrie, sim_p[1],sim_p[2],sim_p[3],sim_p[4],sim_p[5])
    end
end
;
