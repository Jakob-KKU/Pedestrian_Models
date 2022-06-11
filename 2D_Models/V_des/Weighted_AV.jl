function Update_Pref_Velocity!(a::agent, menge::crowd, geometrie::geometry, system_size::NTuple{2, Float64})

    a.v_pref = min(a.v_max, max(0.05, (d_eff(a, menge, system_size)-a.l)/(a.T2)))

end

function d_eff(a::agent, menge::crowd, system_size)

    d_eff = 0.0
    w_ = 0.0

    for i in 2:a.neighbors_agents[1]+1

        b = menge.agent[a.neighbors_agents[i]]

        d_eff += w_ϕ(a, b, system_size)
        w_ += w_ϕ(a, b, system_size)/d(a, b, system_size)

    end

    if d_eff == 0

        99.0

    else

        d_eff/w_

    end

end

w_ϕ(a::agent, b::agent, system_size) = (cos(∠_h(a, b, system_size))^2+1)/2
