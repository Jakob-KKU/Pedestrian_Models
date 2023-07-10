function Update_Neighborhood!(menge::crowd, geometrie::geometry, system_size::NTuple{2, Float64},
     r::Float64)
    calculate_neighboring_agents(menge,system_size, r)
    calculate_neighboring_geometry(menge, geometrie, system_size, r)
end

function Update_Neighborhood!(menge::crowd, geometrie::geometry, r::Float64)
    calculate_neighboring_agents(menge, r)
    calculate_neighboring_geometry(menge, geometrie, r)
end

function Update_Desired_Headings!(menge::crowd, system_size)

    for x in menge.agent
        x.e_des = e_(x, x.goal).*(-1)

        x.v_des = clamp(d(x.pos, x.goal, system_size), 0.001, x.v_des)
        x.v_max = clamp(d(x.pos, x.goal, system_size), 0.001, x.v_max)


    end
end

function Update_Pref_Velocities!(menge::crowd, geometrie::geometry, system_size::NTuple{2, Float64})

    for x in menge.agent
        Update_Pref_Velocity!(x, menge, geometrie, system_size)
    end

end

function Update_Goal!(menge)

    for x in menge.agent

        if d(x, x.goal) < .5

            x.goal = (5.0, 8.0)

        end

    end

end
