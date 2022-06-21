#calculate all distances and save the neighbouring agents
function calculate_neighboring_agents(menge::crowd, r=2.0::Float64)

    delete_values_agents(menge)

    for (i, agent) in enumerate(menge.agent)

        for j in i+1:length(menge.agent)

            if d(agent, menge.agent[j]) < r

                agent.neighbors_agents[agent.neighbors_agents[1]+2] = j
                agent.neighbors_agents[1] += 1

                menge.agent[j].neighbors_agents[menge.agent[j].neighbors_agents[1]+2] = i
                menge.agent[j].neighbors_agents[1] += 1

            end
        end
    end
end

# .... with periodic boundaries
function calculate_neighboring_agents(menge::crowd, system_size::NTuple{2, Float64}, r=2.0::Float64)

    delete_values_agents(menge)

    for (i, agent) in enumerate(menge.agent)

        for j in i+1:length(menge.agent)

            if d(agent, menge.agent[j], system_size) < r

                agent.neighbors_agents[agent.neighbors_agents[1]+2] = j
                agent.neighbors_agents[1] += 1

                menge.agent[j].neighbors_agents[menge.agent[j].neighbors_agents[1]+2] = i
                menge.agent[j].neighbors_agents[1] += 1

            end
        end
    end
end

#calculate the neighboring geometry

function calculate_neighboring_geometry(menge::crowd, geometrie::geometry, r=2.0::Float64)

    delete_values_geometry(menge)

    for (i, agent) in enumerate(menge.agent)

        for (j, element) in enumerate(geometrie.element)

            if d(agent, element) < r

                agent.neighbors_geometry[agent.neighbors_geometry[1]+2] = j
                agent.neighbors_geometry[1] += 1

            end
        end
    end
end

# ... with periodic boundaries
function calculate_neighboring_geometry(menge::crowd, geometrie::geometry, system_size::NTuple{2, Float64},
        r=2.0::Float64)

    delete_values_geometry(menge)

    for (i, agent) in enumerate(menge.agent)

        for (j, element) in enumerate(geometrie.element)

            if d(agent, element, system_size) < r

                agent.neighbors_geometry[agent.neighbors_geometry[1]+2] = j
                agent.neighbors_geometry[1] += 1

            end
        end
    end
end


function delete_values_agents(menge::crowd)

    for x in menge.agent
        for i in 1:x.neighbors_agents[1]
            x.neighbors_agents[i] = 0
        end
    end
end

function delete_values_geometry(menge::crowd)

    for x in menge.agent
        for i in 1:x.neighbors_geometry[1]
            x.neighbors_geometry[i] = 0
        end
    end
end

function Collision_(a::agent, b::element, system_size::NTuple{2, Float64})

    if e_(a, b, system_size)⋅a.heading <= 0 && abs(⟂(a.heading)⋅e_(a, b, system_size)) <= l(a, b)/d(a,b, system_size)
        true
    else
        false
    end
end


function Collision_(a::agent, b::agent, system_size::NTuple{2, Float64})

    if e_(a, b, system_size)⋅a.heading <= 0 && abs(⟂(a.heading)⋅e_(a, b, system_size)) <= l(a, b)/d(a,b, system_size)
        true
    else
        false
    end
end


function V_pref(a::agent, menge::crowd, geometrie::geometry, system_size::NTuple{2, Float64})


    distance = 999.9


    for i in 2:a.neighbors_agents[1]+1

        if Collision_pref(a, menge.agent[a.neighbors_agents[i]], system_size) == true
            distance = min(d(a, menge.agent[a.neighbors_agents[i]], system_size), distance)
        end
    end

    min(a.v_max, max(0.1, (distance-a.l)/(a.T2)))
end


function Collision_pref(a::agent, b::agent, system_size::NTuple{2, Float64})

    if e_(a, b, system_size)⋅a.e_pref <= 0 && abs(⟂(a.e_pref)⋅e_(a, b, system_size)) <= l(a, b)/d(a,b, system_size)
        true
    else
        false
    end
end



#use the voronoi density to calculate the desired velocity
#function Calc_v_des(a::agent, menge::crowd, geometrie::geometry, system_size::NTuple{2, Float64})
#    min(a.v_max, max(0.1, (a.voronoi_dens^(-1/2)-a.l)/(0.5*a.T)))
#end




;
