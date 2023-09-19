TCA(a::agent, b::agent, system_size) = Δv(a, b) == (0.0, 0.0) ? 999.0 :
                max(0, -1 .* Δv(a, b)⋅d_vec(a, b, system_size)/abs(Δv(a, b))^2)

TCA(a::agent, b::element, system_size) = v(a) == (0.0, 0.0) ? 999.0 :
                max(0, -1 .* v(a)⋅d_vec(a, b, system_size)/a.vel^2)


function Min_TCA(a::agent, menge::crowd, geometrie::geometry, system_size)

    tca_geo = Min_TCA_Geometry(a, geometrie, system_size)
    tca_agents = Min_TCA_Agents(a, menge, system_size)

    min(tca_geo, tca_agents)

end


function Min_TCA_Agents(a::agent, menge::crowd, system_size::NTuple{2, Float64})

    tca_min = 999.0

    for i in 2:a.neighbors_agents[1]+1

        b = menge.agent[a.neighbors_agents[i]]
        tca_min = min(tca_min, TCA(a, b, system_size))

    end

    tca_min
end

function Min_TCA_Geometry(a::agent, geometrie::geometry, system_size::NTuple{2, Float64})

    tca_min = 999.0

    for i in 2:a.neighbors_geometry[1]+1

        b = geometrie.element[a.neighbors_geometry[i]]
        tca_min = min(tca_min, TCA(a, b, system_size))

    end

    tca_min
end

TCA_∠(a::agent, b::agent, system_size) = ∠(Δv(a, b), d_vec(a, b, system_size)) <= 3*π/4 ? 999.0 : TCA(a, b, system_size)

TCA_∠(a::agent, b::element, system_size) = ∠(v(a), d_vec(a, b, system_size)) <= 3*π/4 ? 999.0 : TCA(a, b, system_size)

function Min_TCA_∠(a::agent, menge::crowd, geometrie::geometry, system_size)

    tca_geo = Min_TCA_∠_geometry(a, geometrie, system_size)
    tca_agents = Min_TCA_∠_Agents(a, menge, system_size)

    min(tca_geo, tca_agents)

end


function Min_TCA_∠_Agents(a::agent, menge::crowd, system_size::NTuple{2, Float64})

    tca_min = 999.0

    for i in 2:a.neighbors_agents[1]+1

        b = menge.agent[a.neighbors_agents[i]]
        tca_min = min(tca_min, TCA_∠(a, b, system_size))

    end

    tca_min
end

function Min_TCA_∠_geometry(a::agent, geometrie::geometry, system_size::NTuple{2, Float64})

    tca_min = 999.0

    for i in 2:a.neighbors_geometry[1]+1

        b = geometrie.element[a.neighbors_geometry[i]]
        tca_min = min(tca_min, TCA_∠(a, b, system_size))

    end

    tca_min
end
