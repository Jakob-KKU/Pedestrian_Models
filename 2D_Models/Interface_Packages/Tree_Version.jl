### model defined using a kdTree ###
### CAUTION: The KDTREE includes the agent itself in the nearest agents!! ###

function calculate_Tree_agents(menge::crowd)
    BallTree([x.pos[i] for i in 1:2, x in menge.agent])
end

function calculate_Tree_geometry(geometrie::geometry)
    BallTree([x.pos[i] for i in 1:2, x in geometrie.element])
end


function neighbors_of(a::agent, tree::BallTree, r=2.0::Float64)
    inrange(tree, [a.pos[1], a.pos[2]], r, true)
end

function calculate_headings_distance(menge::crowd, geometrie::geometry, temp_headings::Array{NTuple{2, Float64},1}, agent_tree::BallTree, geo_tree::BallTree)

    for (i, x) in enumerate(menge.agent)
         temp_headings[i] = calculate_single_heading_distance(x, menge, geometrie, agent_tree, geo_tree)
    end

    temp_headings

end

function calculate_single_heading_distance(a::agent, menge::crowd, geometrie::geometry, agent_tree::BallTree, geo_tree::BallTree)

    temp_heading = (0, 0)

    for x in neighbors_of_(a, agent_tree)
        temp_heading = temp_heading.+ direction_distance(a, menge.agent[x]).*e_(a, menge.agent[x])
    end

    for x in neighbors_of_(a, geo_tree)
        temp_heading = temp_heading.+ direction_distance(a, geometrie.element[x]).*e_(a, geometrie.element[x])
    end

    normalize(temp_heading .+ a.e_des)
end

function calculate_velocities_distance(menge::crowd, geometrie::geometry, temp_velocities::Array{Float64,1}, agent_tree::BallTree, geo_tree::BallTree)

    for (i,x) in enumerate(menge.agent)
         temp_velocities[i] = ov(x, minimum_distance_in_front(x, menge, geometrie, agent_tree, geo_tree))
    end

    return temp_velocities
end

function minimum_distance_in_front(a::agent, menge::crowd, geometrie::geometry, agent_tree::BallTree, geo_tree::BallTree)

    distance = 999

    for x in neighbors_of_(a, agent_tree)

        if auf_kollision(a, menge.agent[x]) == true
            distance = min(d(a, menge.agent[x]), distance)
        end
    end

    for x in neighbors_of_(a, geo_tree)

        if auf_kollision(a, geometrie.element[x]) == true
            distance = min(d(a, geometrie.element[x]), distance)
        end
    end

    distance
end


function simulate_model_tree(menge::crowd, geometrie::geometry, t_max::Float64, dt_save::Float64, dt::Float64, r::Float64)

    i, j = 0, 1

    gespeicherte_schritte = Int(round(t_max/dt_save))
    N = length(menge.agent)

    positions = Array{NTuple{2, Float64}, 2}(undef, gespeicherte_schritte, N)
    headings = Array{NTuple{2, Float64}, 2}(undef, gespeicherte_schritte, N)

    temp_velocities = Array{Float64,1}(undef,N)
    temp_headings = Array{NTuple{2, Float64},1}(undef,N)

    while dt * i < t_max

        single_iteration_tree(menge, geometrie, temp_velocities, temp_headings, dt, r)

        if mod(i, Int(round(dt_save/dt))) == 0

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

function single_iteration_tree(menge::crowd, geometrie::geometry, temp_velocities::Array{Float64,1}, temp_headings::Array{NTuple{2, Float64},1}, dt::Float64, r::Float64)
    #println("this method")
    agent_tree = calculate_Tree_agents(menge)
    geo_tree = calculate_Tree_geometry(geometrie)

    temp_headings = calculate_headings_distance(menge, geometrie, temp_headings, agent_tree, geo_tree)
    temp_velocities = calculate_velocities_distance(menge, geometrie, temp_velocities, agent_tree, geo_tree)

    for (i, x) in enumerate(menge.agent)
        x.heading, x.vel = temp_headings[i], temp_velocities[i]
        x.pos = x.pos .+ dt .* x.heading .* x.vel
    end
end
