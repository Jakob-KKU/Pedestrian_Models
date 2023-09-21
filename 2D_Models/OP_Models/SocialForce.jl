function Calc_Heading_Velocity(a::agent, menge::crowd, geometrie::geometry, system_size)

    #v_ = a.e_pref .* a.v_pref .+ SF(a, menge, system_size) .+ SF(a, geometrie, system_size)
    v_ = a.e_pref .* a.v_pref .- a.α .* ∇r_ϕ(a, menge, geometrie, system_size)

    normalize(v_), abs(v_)

end

ϕ(a::agent, b::agent, system_size) = a.α * a.r * exp(-(d(a, b, system_size)-l(a, b))/a.r)
ϕ(a::agent, b::element, system_size) = a.α * a.r * exp(-(d(a, b, system_size)-l(a,b))/a.r)


#DEFINITION OF POTENTIAL
function  ϕ(a::agent, menge::crowd, geometrie::geometry, system_size)

     ϕ(a, menge, system_size) +  ϕ(a, geometrie, system_size)

end

function ϕ(a::agent, menge::crowd, system_size)

    ϕ_ = 0.0

    for i in 2:a.neighbors_agents[1]+1

        b = menge.agent[a.neighbors_agents[i]]

        ϕ_ += ϕ(a, b, system_size)

    end

    ϕ_

end

function ϕ(a::agent, geometrie::geometry, system_size)

    ϕ_ = 0.0

    for i in 2:a.neighbors_geometry[1]+1

        b = geometrie.element[a.neighbors_geometry[i]]

        ϕ_ += ϕ(a, b, system_size)

    end

    ϕ_

end
;
