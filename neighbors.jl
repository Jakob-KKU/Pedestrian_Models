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

function Update_Neighborhood!(menge::crowd, geometrie::geometry, system_size::NTuple{2, Float64},
     r::Float64)
    calculate_neighboring_agents(menge,system_size, r)
    calculate_neighboring_geometry(menge, geometrie, system_size, r)
end

function Update_Neighborhood!(menge::crowd, geometrie::geometry, r::Float64)
    calculate_neighboring_agents(menge, r)
    calculate_neighboring_geometry(menge, geometrie, r)
end

function Update_Pos_and_Heading!(menge::crowd, temp_headings::Array{NTuple{2, Float64},1},
     temp_velocities::Array{Float64,1}, dt::Float64)

     for (i, x) in enumerate(menge.agent)
         x.heading, x.vel = temp_headings[i], temp_velocities[i]
         x.pos = x.pos .+ dt .* x.heading .* x.vel
     end
end

function Update_Pos_and_Heading!(menge::crowd, temp_headings::Array{NTuple{2, Float64},1},
     temp_velocities::Array{Float64,1}, dt::Float64, system_size::NTuple{2, Float64})

     for (i, x) in enumerate(menge.agent)
         x.heading, x.vel = temp_headings[i], temp_velocities[i]
         x.pos = mod.(x.pos .+ dt .* x.heading .* x.vel, system_size)
     end
end

function Update_Desired_Headings!(menge::crowd)

    for x in menge.agent
        x.desired_heading = e_(x, x.goal).*(-1)
    end
end


;
