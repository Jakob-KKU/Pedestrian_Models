# check if two agents are colliding
function auf_kollision(a::agent, b::agent)

    if e_(a, b)⋅a.heading <= 0 && abs(⟂(a.heading)⋅e_(a, b)) <= l(a, b)/d(a,b)
        true
    else
        false
    end
end

function auf_kollision(a::agent, b::element)

    if e_(a, b)⋅a.heading <= 0 && abs(⟂(a.heading)⋅e_(a, b)) <= l(a, b)/d(a,b)
        true
    else
        false
    end
end

function auf_kollision(a::agent, b::agent, system_size::NTuple{2, Float64})

    if e_(a, b, system_size)⋅a.heading <= 0 && abs(⟂(a.heading)⋅e_(a, b, system_size)) <= l(a, b)/d(a,b, system_size)
        true
    else
        false
    end
end

function auf_kollision(a::agent, b::element, system_size::NTuple{2, Float64})

    if e_(a, b, system_size)⋅a.heading <= 0 && abs(⟂(a.heading)⋅e_(a, b, system_size)) <= l(a, b)/d(a,b, system_size)
        true
    else
        false
    end
end

function minimum_distance_in_front(a::agent, menge::crowd, geometrie::geometry)

    distance = 999.9

    for i in 2:a.neighbors_agents[1]+1

        if auf_kollision(a, menge.agent[a.neighbors_agents[i]]) == true
            distance = min(d(a, menge.agent[a.neighbors_agents[i]]), distance)
        end
    end

    for i in 2:a.neighbors_geometry[1]+1

        if auf_kollision(a, geometrie.element[a.neighbors_geometry[i]]) == true
            distance = min(d(a, geometrie.element[a.neighbors_geometry[i]]), distance)
        end
    end

    distance
end

function minimum_distance_in_front(a::agent, menge::crowd, geometrie::geometry, system_size::NTuple{2, Float64})

    distance = 999.9

    for i in 2:a.neighbors_agents[1]+1

        if auf_kollision(a, menge.agent[a.neighbors_agents[i]], system_size) == true
            distance = min(d(a, menge.agent[a.neighbors_agents[i]], system_size), distance)
        end
    end

    for i in 2:a.neighbors_geometry[1]+1

        if auf_kollision(a, geometrie.element[a.neighbors_geometry[i]], system_size) == true
            distance = min(d(a, geometrie.element[a.neighbors_geometry[i]], system_size), distance)
        end
    end

    distance
end

function minimum_distance_in_front(a::agent, geometrie::geometry)

    distance = 999.9

    for i in 2:a.neighbors_geometry[1]+1

        if auf_kollision(a, geometrie.element[a.neighbors_geometry[i]]) == true
            distance = min(d(a, geometrie.element[a.neighbors_geometry[i]]), distance)
        end
    end

    distance
end

function minimum_distance_in_front(a::agent, geometrie::geometry, system_size::NTuple{2, Float64})

    distance = 999.9

    for i in 2:a.neighbors_geometry[1]+1

        if auf_kollision(a, geometrie.element[a.neighbors_geometry[i]], system_size) == true
            distance = min(d(a, geometrie.element[a.neighbors_geometry[i]], system_size), distance)
        end
    end

    distance
end

;
