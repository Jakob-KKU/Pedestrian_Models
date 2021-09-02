function calculate_headings_distance(menge::crowd, geometrie::geometry, temp_headings::Array{NTuple{2, Float64},1})

    for (i, x) in enumerate(menge.agent)
         temp_headings[i] = calculate_single_heading_distance(x, menge, geometrie)
    end

    temp_headings

end

function calculate_headings_distance(menge::crowd, geometrie::geometry, temp_headings::Array{NTuple{2, Float64},1},
     system_size::NTuple{2, Float64})

    for (i, x) in enumerate(menge.agent)
         temp_headings[i] = calculate_single_heading_distance(x, menge, geometrie, system_size)
    end

    temp_headings

end

function calculate_single_heading_distance(a::agent, menge::crowd, geometrie::geometry)

    temp_heading = (0, 0)

    for i in 2:a.neighbors_agents[1]+1
        temp_heading = temp_heading.+ direction_distance(a, menge.agent[a.neighbors_agents[i]]).*
        e_(a, menge.agent[a.neighbors_agents[i]])
    end

    for i in 2:a.neighbors_geometry[1]+1
        temp_heading = temp_heading.+ direction_distance(a, geometrie.element[a.neighbors_geometry[i]]).*
        e_(a, geometrie.element[a.neighbors_geometry[i]])
    end

    normalize(temp_heading .+ a.desired_heading)
end

function calculate_single_heading_distance(a::agent, menge::crowd, geometrie::geometry,
        system_size::NTuple{2, Float64})

    temp_heading = (0, 0)

    for i in 2:a.neighbors_agents[1]+1

        temp_heading = temp_heading.+
        direction_distance(a, menge.agent[a.neighbors_agents[i]], system_size).*
        e_(a, menge.agent[a.neighbors_agents[i]], system_size)

    end

    for i in 2:a.neighbors_geometry[1]+1

        temp_heading = temp_heading.+
        direction_distance(a, geometrie.element[a.neighbors_geometry[i]], system_size).*
        e_(a, geometrie.element[a.neighbors_geometry[i]], system_size)

    end

    normalize(temp_heading .+ a.desired_heading)
end


direction_distance(a::agent, b::agent) = a.parameters.interaction_strength*exp((l(a, b)-d(a, b))/a.parameters.interaction_length)
direction_distance(a::agent, b::element) = a.parameters.interaction_strength*exp((l(a, b)-d(a, b))/a.parameters.interaction_length)

direction_distance(a::agent, b::agent, system_size::NTuple{2, Float64}) = a.parameters.interaction_strength*
exp((l(a, b)-d(a, b, system_size))/a.parameters.interaction_length)

direction_distance(a::agent, b::element, system_size::NTuple{2, Float64}) = a.parameters.interaction_strength*
exp((l(a, b)-d(a, b, system_size))/a.parameters.interaction_length)
;
