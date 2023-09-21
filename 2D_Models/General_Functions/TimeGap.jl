function TimeGap(a::agent, b::agent, system_size::NTuple{2, Float64})

    cos_α = e_(a,b,system_size)⋅a.heading
    A = ((cos_α)^2-1)*d(a,b,system_size)^2+l(a, b)^2

    if A < 0 || -(cos_α)*d(a,b,system_size)-sqrt(A) < 0.0
        999.0
    else
        (-(cos_α)*d(a,b,system_size)-sqrt(A))/a.vel
    end
end

function TimeGap(a::agent, b::element, system_size::NTuple{2, Float64})

    cos_α = e_(a,b,system_size)⋅e_v(a)
    A = ((cos_α)^2-1)*d(a,b,system_size)^2+l(a, b)^2

    if A < 0 || -(cos_α)*d(a,b,system_size)-sqrt(A) < 0.0
        999.0
    else
        (-(cos_α)*d(a,b,system_size)-sqrt(A))/a.vel
    end
end

function TimeGap(a::agent, b::agent, a_heading::NTuple{2, Float64}, a_vel::Float64, system_size::NTuple{2, Float64})

    cos_α = e_(a,b,system_size)⋅a_heading
    A = ((cos_α)^2-1)*d(a,b,system_size)^2+l(a, b)^2

    if A < 0 || -(cos_α)*d(a,b,system_size)-sqrt(A) < 0.0
        999.0
    else

        (-(cos_α)*d(a,b,system_size)-sqrt(A))/a_vel
    end
end

function TimeGap(a::agent, b::element, a_heading::NTuple{2, Float64}, a_vel::Float64, system_size::NTuple{2, Float64})

    cos_α = e_(a,b,system_size)⋅a_heading
    A = ((cos_α)^2-1)*d(a,b,system_size)^2+l(a, b)^2

    if A < 0 || -(cos_α)*d(a,b,system_size)-sqrt(A) < 0.0
        999.0
    else

        (-(cos_α)*d(a,b,system_size)-sqrt(A))/a_vel
    end
end


function Min_TimeGap(a::agent, a_vel::Float64, a_heading::NTuple{2, Float64}, menge::crowd, geometrie::geometry,
        system_size::NTuple{2, Float64})

    tgap_geo = Min_TimeGap_Geometry(a, a_vel, a_heading, geometrie, system_size)
    tgap_agents = Min_TimeGap_Agents(a, a_vel, a_heading, menge, system_size)

    min(tgap_geo, tgap_agents)

end

function Min_TimeGap_Agents(a::agent, a_vel::Float64, a_heading::NTuple{2, Float64}, menge::crowd,
        system_size::NTuple{2, Float64})

    tgap_min = 999.0

    for i in 2:a.neighbors_agents[1]+1

        tgap_help = TimeGap(a, menge.agent[a.neighbors_agents[i]], a_heading, a_vel, system_size)

        tgap_min = min(tgap_help, tgap_min)
    end

    tgap_min
end

function Min_TimeGap_Geometry(a::agent, a_vel::Float64, a_heading::NTuple{2, Float64}, geometrie::geometry,
        system_size::NTuple{2, Float64})

    tgap_min = 999.0

    for i in 2:a.neighbors_geometry[1]+1

        tgap_help = TimeGap(a, geometrie.element[a.neighbors_geometry[i]], a_heading, a_vel, system_size)

        tgap_min = min(tgap_help, tgap_min)
    end
    tgap_min
end


function Min_TimeGap(a::agent, menge::crowd, geometrie::geometry, system_size::NTuple{2, Float64})

    TG_Geo = Min_TimeGap_Geometry(a, geometrie, system_size)
    TG_Agents = Min_TimeGap_Agents(a, menge, system_size)

    min(TG_Geo, TG_Agents)

end

function Min_TimeGap_Agents(a::agent, menge::crowd,
        system_size::NTuple{2, Float64})

    TG_ = 999.0

    for i in 2:a.neighbors_agents[1]+1

        b = menge.agent[a.neighbors_agents[i]]

        TG_ = min(TimeGap(a, b, system_size), TG_)

    end

    TG_
end

function Min_TimeGap_Geometry(a::agent, geometrie::geometry, system_size::NTuple{2, Float64})

    TG_ = 999.0

    for i in 2:a.neighbors_geometry[1]+1

        b = geometrie.element[a.neighbors_geometry[i]]

        TG_ = min(TimeGap(a, b, system_size), TG_)

    end

    TG_
end
