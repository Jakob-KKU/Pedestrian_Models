function Calc_Heading_Velocity(a::agent, menge::crowd, geometrie::geometry, system_size)

    v_new = a.v_pref .* a.e_pref .+ F(a, menge, geometrie, system_size)

    normalize(v_new), min(a.v_max, abs(v_new))

end

α_rot(a::agent, b::agent) = a.λ*∠(a.heading, b.heading)

F_Rot(a::agent, b::agent, system_size) = R(α_rot(a, b), F(a, b, system_size))

F(a::agent, b::agent, system_size) = a.α .* exp(-(d(a, b, system_size)-l(a, b))/a.r) .* e_(a, b, system_size)
F(a::agent, b::element, system_size) = a.α .* exp(-(d(a, b, system_size)-l(a, b))/a.r) .* e_(a, b, system_size)

function F(a::agent, menge::crowd, geometrie::geometry, system_size)

    F_Rot(a, menge, system_size) .+ F(a, geometrie, system_size)

end

function F_Rot(a::agent, menge::crowd, system_size)

    F_agents = (0.0, 0.0)

    for i in 2:a.neighbors_agents[1]+1

        b = menge.agent[a.neighbors_agents[i]]

        F_agents = F_agents .+ F_Rot(a, b, system_size)

    end

    F_agents

end

function F(a::agent, geometrie::geometry, system_size)

    F_geometry = (0.0, 0.0)

    for i in 2:a.neighbors_geometry[1]+1

        b = geometrie.element[a.neighbors_geometry[i]]

        F_geometry = F_geometry .+ F(a, b, system_size)

    end

    F_geometry

end

p = [2.0, 1.7, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 500.0, 0.0, 0.0, 0.0, 1.5, -0.25]
# ModelParameter: v_max, v_des, T, T2, l, step_time, τ_A, τ_R, α, β, ζ_h, ζ_v, r, ϕ
p_desc = "v_max, v_des, T, T2, l, step_time, τ_A, τ_R, α, β, ζ_h, ζ_v, r, λ"


println("The following parameters were given in totzeck_AnisotropicInteractionModel_2020:")
println(p)
println(p_desc)
