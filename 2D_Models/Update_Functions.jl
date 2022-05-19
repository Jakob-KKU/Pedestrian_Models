function Update_Neighborhood!(menge::crowd, geometrie::geometry, system_size::NTuple{2, Float64},
     r::Float64)
    calculate_neighboring_agents(menge,system_size, r)
    calculate_neighboring_geometry(menge, geometrie, system_size, r)
end

function Update_Neighborhood!(menge::crowd, geometrie::geometry, r::Float64)
    calculate_neighboring_agents(menge, r)
    calculate_neighboring_geometry(menge, geometrie, r)
end

function Update_Desired_Headings!(menge::crowd)

    for x in menge.agent
        x.desired_heading = e_(x, x.goal).*(-1)
    end
end

function Update_Desired_Velocity!(menge::crowd, geometrie::geometry, system_size::NTuple{2, Float64})

    for x in menge.agent
        x.v_des = Calc_v_des(x, menge, geometrie, system_size)
    end

end

function Calc_v_des(a::agent, menge::crowd, geometrie::geometry, system_size::NTuple{2, Float64})

    distance = 999.9


    for i in 2:a.neighbors_agents[1]+1

        if Collision_(a, menge.agent[a.neighbors_agents[i]], system_size) == true
            distance = min(d(a, menge.agent[a.neighbors_agents[i]], system_size), distance)
        end
    end

    for i in 2:a.neighbors_geometry[1]+1

        if Collision_(a, geometrie.element[a.neighbors_geometry[i]], system_size) == true
            distance = min(d(a, geometrie.element[a.neighbors_geometry[i]], system_size), distance)
        end
    end

    min(a.v_max, max(0.1, (distance-a.l)/(a.T2)))
end

function Update_Goal!(menge)

    for x in menge.agent

        if d(x, x.goal) < .5

            x.goal = (5.0, 8.0)

        end

    end

end
