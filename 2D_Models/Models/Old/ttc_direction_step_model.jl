function Calc_Headings_step!(menge::crowd, geometrie::geometry, temp_headings, t, t_step,
        system_size::NTuple{2, Float64})

    for (i,x) in enumerate(menge.agent)

        if abs(t-t_step[i])<=0.01

            temp_headings[i]  = Calc_Heading_TTC(x, menge, geometrie, system_size)
            t_step[i] += 0.5

        end


    end

    temp_headings

end


function Iterate_TTC_direction_step!(menge::crowd, geometrie::geometry, temp_headings::Array{NTuple{2, Float64},1},
     dt::Float64, i::Int64, r::Float64, t_step, system_size::NTuple{2, Float64})

    Update_Neighborhood!(menge, geometrie, system_size, r)

    #Update_Desired_Headings!(menge)

    Calc_Headings_step!(menge, geometrie, temp_headings, i*dt, t_step, system_size)

    Update_Pos_and_Heading!(menge, temp_headings, dt, system_size)



end

function Simulate_TTC_Direction_step!(menge::crowd, geometrie::geometry, t_relax::Float64, t_max::Float64, dt_save::Float64, dt::Float64,
        r::Float64, system_size::NTuple{2, Float64})

    N = length(menge.agent)

    t_step = round.(0.4.*rand(N).+0.01, digits = 3)
    println(t_step)

    #for saving positions and headings
    gespeicherte_schritte = Int(round((t_max-t_relax)/dt_save))-1
    positions = Array{NTuple{2, Float64}, 2}(undef, gespeicherte_schritte, N)
    headings = Array{NTuple{2, Float64}, 2}(undef, gespeicherte_schritte, N)
    ttcs = Array{Float64, 2}(undef, gespeicherte_schritte, N)

    #buffer vectors

    temp_headings = Array{NTuple{2, Float64},1}(undef,N)

    for i in 1:N
        temp_headings[i] = menge.agent[i].desired_heading
    end


    i, j = 0, 1

    while dt * i < t_max

        Iterate_TTC_direction_step!(menge, geometrie, temp_headings, dt, i,
            r, t_step, system_size)

        if dt*i>t_relax && mod(i, Int(round(dt_save/dt))) == 0

            for k in 1:N

                ttcs[j, k] = Min_TTC(menge.agent[k], menge, geometrie, system_size)
                positions[j, k] = menge.agent[k].pos
                headings[j, k]  = menge.agent[k].heading
            end

            j = j + 1
        end

        i = i + 1
    end

    positions, headings, ttcs
end
