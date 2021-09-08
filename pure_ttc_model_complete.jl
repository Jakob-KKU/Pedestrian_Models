function Iterate_Pure_TTC!(menge::crowd, geometrie::geometry, temp_velocities::Array{Float64,1},
        temp_headings::Array{NTuple{2, Float64},1}, dt::Float64, r::Float64, system_size::NTuple{2, Float64})

    calculate_neighboring_agents(menge,system_size, r)
    calculate_neighboring_geometry(menge, geometrie, system_size, r)

    temp_velocities, temp_headings = Calc_Vs_and_Headings(menge, geometrie, temp_velocities, temp_headings,
        system_size)

    for (i, x) in enumerate(menge.agent)
        x.heading, x.vel = temp_headings[i], temp_velocities[i]
        x.pos = mod.(x.pos .+ dt .* x.heading .* x.vel, system_size)
    end
end

function Simulate_Pure_TTC!(menge::crowd, geometrie::geometry, t_relax::Float64, t_max::Float64, dt_save::Float64, dt::Float64,
        r::Float64, system_size::NTuple{2, Float64})

    N = length(menge.agent)

    #for saving positions and headings
    gespeicherte_schritte = Int(round((t_max-t_relax)/dt_save))-1
    positions = Array{NTuple{2, Float64}, 2}(undef, gespeicherte_schritte, N)
    headings = Array{NTuple{2, Float64}, 2}(undef, gespeicherte_schritte, N)

    #buffer vectors
    temp_velocities = Array{Float64,1}(undef,N)
    temp_headings = Array{NTuple{2, Float64},1}(undef,N)

    i, j = 0, 1

    while dt * i < t_max

        Iterate_Pure_TTC!(menge, geometrie, temp_velocities, temp_headings, dt,
            r, system_size)

        if dt*i>t_relax && mod(i, Int(round(dt_save/dt))) == 0

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