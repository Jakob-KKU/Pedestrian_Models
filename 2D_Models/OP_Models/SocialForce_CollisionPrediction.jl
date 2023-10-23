function Calc_Heading_Velocity(a::agent, menge::crowd, geometrie::geometry, system_size)

    v_new = a.v_pref .* a.e_pref .+ F(a, menge, geometrie, system_size)

    if abs(v_new) == 0.0
        a.e_pref, 0.0
    else
        normalize(v_new), min(a.v_max, abs(v_new))
    end

end


F(a::agent, b::agent, tca_a, system_size) = a.α * (a.vel/tca_a) * exp(-d(a, b, system_size)/a.r) .*
            e_(a, b, tca_a, system_size)

F(a::agent, b::element, tca_a, system_size) = a.α * (a.vel/tca_a) * exp(-d(a, b, system_size)/a.r) .*
            e_(a, b, tca_a, system_size)


function F(a::agent, menge::crowd, geometrie::geometry, system_size)

    tca_a = Min_TCA_∠(a, menge, geometrie, system_size)

    if tca_a >= 999.0
        (0.0, 0.0)
    else
        F(a, menge, tca_a, system_size) .+ F(a, geometrie, tca_a, system_size)
    end

end

function F(a::agent, menge::crowd, tca_a, system_size)

    F_agents = (0.0, 0.0)

    for i in 2:a.neighbors_agents[1]+1

        b = menge.agent[a.neighbors_agents[i]]

        F_agents = F_agents .+ F(a, b, tca_a, system_size)

    end


    F_agents

end

function F(a::agent, geometrie::geometry, tca_a, system_size)

    F_geometry = (0.0, 0.0)

    for i in 2:a.neighbors_geometry[1]+1

        b = geometrie.element[a.neighbors_geometry[i]]

        F_geometry = F_geometry .+ F(a, b, tca_a, system_size)

    end

    F_geometry

end

p = [2.0, 1.7, 0.0, 0.0, 0.3, 0.0, 0.0, 0.66, 1.71, 0.0, 0.0, 0.0, 0.71, 0.0]
# ModelParameter: v_max, v_des, T, T2, l, step_time, τ_A, τ_R, α, β, ζ_h, ζ_v, r, ϕ
p_desc = "v_max, v_des, T, T2, l, step_time, τ_A, τ_R, α, β, ζ_h, ζ_v, r, ϕ"


println("The following parameters were given in zanlungo_SocialForceModel_2011:")
println(p)
println(p_desc)
