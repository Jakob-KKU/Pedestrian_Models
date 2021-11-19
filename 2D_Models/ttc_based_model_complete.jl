include("./ttc_based_model_velocity.jl")

function single_iteration_ttc(menge::crowd, geometrie::geometry, temp_velocities::Array{Float64,1},
        temp_headings::Array{NTuple{2, Float64},1}, dt::Float64, r::Float64)

    calculate_neighboring_agents(menge, r)
    calculate_neighboring_geometry(menge, geometrie, r)

    Update_Desired_Headings!(menge)
    Update_Voronoi_Dens!(menge, system_size)

    temp_headings = calculate_headings_distance(menge, geometrie, temp_headings)
    temp_velocities = calculate_velocities_ttc(menge, geometrie, temp_velocities)

    for (i, x) in enumerate(menge.agent)
        x.heading, x.vel = temp_headings[i], temp_velocities[i]
        x.pos = x.pos .+ dt .* x.heading .* x.vel
    end
end

function simulate_model_ttc(menge::crowd, geometrie::geometry, t_relax::Float64, t_max::Float64,
     dt_save::Float64, dt::Float64, r::Float64)

    i, j = 0, 1

    gespeicherte_schritte = Int(round((t_max-t_relax)/dt_save))-1
    N = length(menge.agent)

    positions = Array{NTuple{2, Float64}, 2}(undef, gespeicherte_schritte, N)
    headings = Array{NTuple{2, Float64}, 2}(undef, gespeicherte_schritte, N)

    temp_velocities = Array{Float64,1}(undef,N)
    temp_headings = Array{NTuple{2, Float64},1}(undef,N)

    while dt * i < t_max

        single_iteration_ttc(menge, geometrie, temp_velocities, temp_headings, dt, r)

        if i*dt > t_relax && mod(i, Int(round(dt_save/dt))) == 0

            for k in 1:N
                positions[j, k] = menge.agent[k].pos
                headings[j, k]  = menge.agent[k].heading
            end

            j = j + 1
        end

        i = i + 1
    end

    positions, headings

end


function single_iteration_ttc(menge::crowd, geometrie::geometry,temp_velocities::Array{Float64,1},
        temp_headings::Array{NTuple{2, Float64},1}, dt::Float64, r::Float64, system_size::NTuple{2, Float64})

    Update_Neighborhood!(menge, geometrie, system_size, r)
    Update_Desired_Headings!(menge)

    temp_headings = calculate_headings_distance(menge, geometrie, temp_headings, system_size)
    temp_velocities = calculate_velocities_ttc(menge, geometrie, temp_velocities, system_size)

    Update_Pos_and_Heading!(menge, temp_headings, temp_velocities, dt, system_size)

end

function simulate_model_ttc(menge::crowd, geometrie::geometry, t_relax::Float64, t_max::Float64, dt_save::Float64, dt::Float64,
        r::Float64, system_size::NTuple{2, Float64})

    i, j = 0, 1

    gespeicherte_schritte = Int(round((t_max-t_relax)/dt_save))-1
    N = length(menge.agent)

    positions = Array{NTuple{2, Float64}, 2}(undef, gespeicherte_schritte, N)
    headings = Array{NTuple{2, Float64}, 2}(undef, gespeicherte_schritte, N)

    temp_velocities = Array{Float64,1}(undef,N)
    temp_headings = Array{NTuple{2, Float64},1}(undef,N)

    while dt * i < t_max

        single_iteration_ttc(menge, geometrie, temp_velocities, temp_headings, dt, r, system_size)

        if i*dt > t_relax && mod(i, Int(round(dt_save/dt))) == 0

            for k in 1:N
            positions[j, k] = menge.agent[k].pos
            headings[j, k]  = menge.agent[k].heading
            end

            j = j + 1
        end

        i = i + 1
    end

    positions, headings

end

;
