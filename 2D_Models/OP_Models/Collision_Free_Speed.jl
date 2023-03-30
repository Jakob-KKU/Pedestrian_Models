function Calc_Heading_Velocity(a::agent, menge::crowd, geometrie::geometry, system_size)

    e_a = a.e_pref

    for i in 2:a.neighbors_agents[1]+1

        e_a = e_a .+ F(a, menge.agent[a.neighbors_agents[i]], system_size)

    end

    for i in 2:a.neighbors_geometry[1]+1

        e_a = e_a .+ F(a, geometrie.element[a.neighbors_geometry[i]], system_size)

    end

    normalize(e_a), OV(a, menge, geometrie, system_size)


end

function OV(a::agent, menge::crowd, geometrie::geometry, system_size::NTuple{2, Float64})


    distance = 999.9


    for i in 2:a.neighbors_agents[1]+1

        if Collision(a, menge.agent[a.neighbors_agents[i]], system_size) == true
            distance = min(d(a, menge.agent[a.neighbors_agents[i]], system_size), distance)
        end
    end

    for i in 2:a.neighbors_geometry[1]+1

        if Collision(a, geometrie.element[a.neighbors_geometry[i]], system_size) == true
            distance = min(d(a, geometrie.element[a.neighbors_geometry[i]], system_size), distance)
        end
    end

    clamp((distance-a.l)/(a.T2), 0.0, a.v_max)
end


function Collision(a::agent, b::agent, system_size::NTuple{2, Float64})

    if e_(a, b, system_size)⋅a.heading <= 0 && abs(⟂(a.heading)⋅e_(a, b, system_size)) <= l(a, b)/d(a,b, system_size)
        true
    else
        false
    end
end

function Collision(a::agent, b::element, system_size::NTuple{2, Float64})

    if e_(a, b, system_size)⋅a.heading <= 0 && abs(⟂(a.heading)⋅e_(a, b, system_size)) <= l(a, b)/d(a,b, system_size)
        true
    else
        false
    end
end


F(a::agent, b::agent, system_size) =  a.α*exp(-(d(a, b, system_size)-l(a, b))/a.r).*e_(a, b, system_size)
F(a::agent, b::element, system_size) =  0.1*a.α*exp(-(d(a, b, system_size)-l(a, b))/a.r).*e_(a, b, system_size)
