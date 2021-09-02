include("/home/jakob/Dokumente/Promotion/Julia_Notebook/Library_new/struct.jl")
include("/home/jakob/Dokumente/Promotion/Julia_Notebook/Library_new/vectors.jl")
include("/home/jakob/Dokumente/Promotion/Julia_Notebook/Library_new/initialize_system.jl")
include("/home/jakob/Dokumente/Promotion/Julia_Notebook/Library_new/neighbors.jl")
include("/home/jakob/Dokumente/Promotion/Julia_Notebook/Library_new/initialize_geometry.jl")
include("/home/jakob/Dokumente/Promotion/Julia_Notebook/Library_new/mengen.jl")
include("/home/jakob/Dokumente/Promotion/Julia_Notebook/Library_new/plot_functions.jl")

include("/home/jakob/Dokumente/Promotion/Julia_Notebook/Library_new/observables.jl")



include("/home/jakob/Dokumente/Promotion/Julia_Notebook/Library_new/distance_based_model_base_functions.jl")
include("/home/jakob/Dokumente/Promotion/Julia_Notebook/Library_new/distance_based_model_direction.jl")
include("/home/jakob/Dokumente/Promotion/Julia_Notebook/Library_new/distance_based_model_velocity.jl")
include("/home/jakob/Dokumente/Promotion/Julia_Notebook/Library_new/distance_based_model_complete.jl")

include("/home/jakob/Dokumente/Promotion/Julia_Notebook/Library_new/ttc.jl")
include("/home/jakob/Dokumente/Promotion/Julia_Notebook/Library_new/ttc_based_model_velocity.jl")
include("/home/jakob/Dokumente/Promotion/Julia_Notebook/Library_new/ttc_based_model_complete.jl")

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
