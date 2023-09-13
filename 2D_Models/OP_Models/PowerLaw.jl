### POWERLAW MODEL ###
f(x) = x^2*exp(-1/x)

function ϕ(a::agent, menge::crowd, geometrie::geometry, system_size)

    ϕ_ = 0.0

    for i in 2:a.neighbors_geometry[1]+1

        b = geometrie.element[a.neighbors_geometry[i]]

        ϕ_ += f(AV(a, b, system_size))

    end

    for i in 2:a.neighbors_agents[1]+1

        b = menge.agent[a.neighbors_agents[i]]

        ϕ_ += f(AV(a, b, system_size))

    end

    ϕ_

end

function Calc_Heading_Velocity(a::agent, menge::crowd, geometrie::geometry, system_size)

    v_new = a.v_pref .* a.e_pref .- a.α .* ∇r_ϕ(a, menge, geometrie, system_size)

    normalize(v_new), min(a.v_max, abs(v_new))

end
;
