function Calc_Heading_Velocity(a::agent, menge::crowd, geometrie::geometry, system_size)

    v_ = a.e_pref .* a.v_pref .+ SF(a, menge, system_size) .+ SF(a, geometrie, system_size)

    normalize(v_), abs(v_)

end

function SF(a::agent, menge::crowd, system_size::NTuple{2, Float64})

    F_ = (0.0, 0.0)

    for i in 2:a.neighbors_agents[1]+1

        F_ = F_ .+ SF(a, menge.agent[a.neighbors_agents[i]], system_size)

    end

    F_

end

function SF(a::agent, geometrie::geometry, system_size::NTuple{2, Float64})

    F_ = (0.0, 0.0)

    for i in 2:a.neighbors_geometry[1]+1

        F_ = F_ .+ SF(a, geometrie.element[a.neighbors_geometry[i]], system_size)

    end

    F_

end

SF(a::agent, b::agent, system_size) = a.α .* exp(-(d(a, b, system_size)-l(a, b))/a.r) .* e_(a, b, system_size)
SF(a::agent, b::element, system_size) = a.α .* exp(-(d(a, b, system_size)-l(a, b))/a.r) .* e_(a, b, system_size)
