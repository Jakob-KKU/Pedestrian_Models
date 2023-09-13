#calculate all distances and save the neighbouring agents
function Update_Neighboring_Agents!(menge::crowd, r=2.0::Float64)

    Delete_Old_Neighbours_Agents!(menge)

    for (i, a) in enumerate(menge.agent)

        for j in i+1:length(menge.agent)

            b = menge.agent[j]

            if d(a, b) < r

                if Perceivable(a, b, menge, geometrie) == true
                    a.neighbors_agents[a.neighbors_agents[1]+2] = j
                    a.neighbors_agents[1] += 1
                end

                if Perceivable(a, b, menge, geometrie) == true
                    b.neighbors_agents[b.neighbors_agents[1]+2] = i
                    b.neighbors_agents[1] += 1
                end

            end
        end
    end
end

# .... with periodic boundaries
function Update_Neighboring_Agents!(menge::crowd, geometrie::geometry, system_size::NTuple{2, Float64}, r=2.0::Float64)

    Delete_Old_Neighbours_Agents!(menge)

    for (i, a) in enumerate(menge.agent)

        for j in i+1:length(menge.agent)

            b = menge.agent[j]

            if d(a, b, system_size) < r

                if Perceivable(a, b, menge, geometrie, system_size) == true
                    a.neighbors_agents[a.neighbors_agents[1]+2] = j
                    a.neighbors_agents[1] += 1
                end

                if Perceivable(b, a, menge, geometrie, system_size) == true
                    b.neighbors_agents[b.neighbors_agents[1]+2] = i
                    b.neighbors_agents[1] += 1
                end

            end
        end
    end
end

#calculate the neighboring geometry
function Update_Neighboring_Geometry!(menge::crowd, geometrie::geometry, r=2.0::Float64)

    Delete_Old_Neighbours_Geometry!(menge)

    for (i, a) in enumerate(menge.agent)

        for (j, b) in enumerate(geometrie.element)

            if d(a, b) < r

                if Perceivable(a, b, menge, geometrie) == true
                    a.neighbors_geometry[a.neighbors_geometry[1]+2] = j
                    a.neighbors_geometry[1] += 1
                end

            end
        end
    end
end


# ... with periodic boundaries
function Update_Neighboring_Geometry!(menge::crowd, geometrie::geometry, system_size::NTuple{2, Float64},
        r=2.0::Float64)

    Delete_Old_Neighbours_Geometry!(menge)

    for (i, a) in enumerate(menge.agent)

        for (j, b) in enumerate(geometrie.element)

            if d(a, b, system_size) < r

                if Perceivable(a, b, menge, geometrie, system_size) == true
                    a.neighbors_geometry[a.neighbors_geometry[1]+2] = j
                    a.neighbors_geometry[1] += 1
                end

            end
        end
    end
end

function Delete_Old_Neighbours_Agents!(menge::crowd)

    for x in menge.agent
        for i in 1:x.neighbors_agents[1]
            x.neighbors_agents[i] = 0
        end
    end
end

function Delete_Old_Neighbours_Geometry!(menge::crowd)

    for x in menge.agent
        for i in 1:x.neighbors_geometry[1]
            x.neighbors_geometry[i] = 0
        end
    end
end
;
