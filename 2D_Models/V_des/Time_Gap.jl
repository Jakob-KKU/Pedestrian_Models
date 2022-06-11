function Update_Pref_Velocity!(a::agent, menge::crowd, geometrie::geometry, system_size::NTuple{2, Float64})

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

    a.v_pref = min(a.v_max, max(0.1, (distance-a.l)/(a.T2)))
end
