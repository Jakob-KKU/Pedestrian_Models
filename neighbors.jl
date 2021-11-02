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




;
