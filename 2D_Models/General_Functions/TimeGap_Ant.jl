function Min_TimeGap_Ant(a::agent, a_vel::Float64, a_heading::NTuple{2, Float64}, menge::crowd, geometrie::geometry,
        system_size::NTuple{2, Float64})

    tgap_geo = Min_TimeGap_Ant_Geometry(a, a_vel, a_heading, geometrie, system_size)
    tgap_agents = Min_TimeGap_Ant_Agents(a, a_vel, a_heading, menge, system_size)

    min(tgap_geo, tgap_agents)

end

function Min_TimeGap_Ant_Agents(a::agent, a_vel::Float64, a_heading::NTuple{2, Float64}, menge::crowd,
        system_size::NTuple{2, Float64})

    tgap_min = 999.0

    for i in 2:a.neighbors_agents[1]+1

        tgap_help = TimeGap_Ant(a, a_heading, a_vel, menge.agent[a.neighbors_agents[i]], system_size)

        tgap_min = min(tgap_help, tgap_min)
    end

    tgap_min
end

function Min_TimeGap_Ant_Geometry(a::agent, a_vel::Float64, a_heading::NTuple{2, Float64}, geometrie::geometry,
        system_size::NTuple{2, Float64})

    tgap_min = 999.0

    for i in 2:a.neighbors_geometry[1]+1

        tgap_help = TimeGap_Ant(a, a_heading, a_vel, geometrie.element[a.neighbors_geometry[i]], system_size)

        tgap_min = min(tgap_help, tgap_min)
    end
    tgap_min
end


function TimeGap_Ant(a::agent, b::agent, system_size::NTuple{2, Float64})

    cos_α = e_Ant(a,b,system_size)⋅a.heading
    A = ((cos_α)^2-1)*d_Ant(a,b,system_size)^2+l(a, b)^2

    if A < 0 || -(cos_α)*d_Ant(a,b,system_size)-sqrt(A) < 0.0
        999.0
    else
        (-(cos_α)*d_Ant(a,b,system_size)-sqrt(A))/a.vel
    end
end

function TimeGap_Ant(a::agent, b::element, system_size::NTuple{2, Float64})

    cos_α = e_Ant(a,b,system_size)⋅e_v(a)
    A = ((cos_α)^2-1)*d_Ant(a,b,system_size)^2+l(a, b)^2

    if A < 0 || -(cos_α)*d_Ant(a,b,system_size)-sqrt(A) < 0.0
        999.0
    else
        (-(cos_α)*d_Ant(a,b,system_size)-sqrt(A))/a.vel
    end
end

function TimeGap_Ant(a::agent, a_heading::NTuple{2, Float64}, a_vel::Float64, b::agent, system_size::NTuple{2, Float64})

    cos_α = e_Ant(a, a_heading, a_vel , b, system_size)⋅a_heading
    A = ((cos_α)^2-1)*d_Ant(a, a_heading, a_vel, b, system_size)^2+l(a, b)^2

    if A < 0 || -(cos_α)*d_Ant(a, a_heading, a_vel, b, system_size)-sqrt(A) < 0.0
        999.9
    else
        (-(cos_α)*d_Ant(a, a_heading, a_vel, b, system_size)-sqrt(A))/a_vel
    end
end


function TimeGap_Ant(a::agent, a_heading::NTuple{2, Float64}, a_vel::Float64, b::element, system_size::NTuple{2, Float64})

    cos_α = e_Ant(a, a_heading, a_vel, b, system_size)⋅a_heading
    A = ((cos_α)^2-1)*d_Ant(a, a_heading, a_vel, b, system_size)^2+l(a, b)^2

    if A < 0 || -(cos_α)*d_Ant(a, a_heading, a_vel, b, system_size)-sqrt(A) < 0.0
        999.0
    else
        (-(cos_α)*d_Ant(a, a_heading, a_vel, b, system_size)-sqrt(A))/a.vel
    end
end

e_Ant(a::agent, b::agent) = normalize(a.pos .- b.pos .+ a.τ_A .* Δv(a, b))
e_Ant(a::agent, b::element) = normalize(a.pos .- b.pos .+ a.τ_A .* v(a))

function e_Ant(a::agent, b::agent, system_size::NTuple{2, Float64})

    d_ = a.pos.-b.pos .+ a.τ_A .* Δv(a, b)
    d_ =wrap_vector!(d_, system_size)

    normalize(d_)
end

function e_Ant(a::agent, a_heading, a_vel, b::agent, system_size::NTuple{2, Float64})

    d_ = a.pos.-b.pos .+ a.τ_A .* Δv(a_vel .* a_heading, b)
    d_ = wrap_vector!(d_, system_size)

    normalize(d_)
end

function e_Ant(a::agent, b::element, system_size::NTuple{2, Float64})

    d_ = a.pos.-b.pos .+ a.τ_A .* v(a)
    d_ = wrap_vector!(d_, system_size)

    normalize(d_)
end

function e_Ant(a::agent, a_heading, a_vel, b::element, system_size::NTuple{2, Float64})

    d_ = a.pos.-b.pos .+ a.τ_A * a_vel .* a_heading
    d_ = wrap_vector!(d_, system_size)

    normalize(d_)
end

d_Ant(a::agent, b::agent) = abs(a.pos .- b.pos .+ a.τ_A .* Δv(a, b))
d_Ant(a::agent, b::element) = abs(a.pos .- b.pos .+ a.τ_A .* v(a))

function d_Ant(a::agent, b::agent, system_size::NTuple{2, Float64})

    d_ = abs.(a.pos.-b.pos .+ a.τ_A .* Δv(a, b))
    d_ = wrap_normed_vector!(d_, system_size)

    abs(d_)
end

function d_Ant(a::agent, a_heading, a_vel, b::agent, system_size::NTuple{2, Float64})

    d_ = abs.(a.pos.-b.pos .+ a.τ_A .* Δv(a_vel .* a_heading, b))
    d_ = wrap_normed_vector!(d_, system_size)

    abs(d_)
end


function d_Ant(a::agent, b::element, system_size::NTuple{2, Float64})

    d_ = abs.(a.pos .-b.pos .+ a.τ_A * a.vel .* a.heading)
    d_ = wrap_normed_vector!(d_, system_size)

    abs(d_)
end


function d_Ant(a::agent, a_heading, a_vel, b::element, system_size::NTuple{2, Float64})

    d_ = abs.(a.pos .-b.pos .+ a.τ_A * a_vel .* a_heading)
    d_ = wrap_normed_vector!(d_, system_size)

    abs(d_)
end
