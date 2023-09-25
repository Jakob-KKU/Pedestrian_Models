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

p = [2.0, 1.7, 0.0, 0.0, 0.6, 0.0, 0.0, 0.5, 50.0, 0.0, 0.0, 0.0, 0.08, 0.0]
# ModelParameter: v_max, v_des, T, T2, l, step_time, τ_A, τ_R, α, β, ζ_h, ζ_v, r, ϕ
p_desc = "v_max, v_des, T, T2, l, step_time, τ_A, τ_R, α, β, ζ_h, ζ_v, r, ϕ"


println("The following parameters were given in helbing_SimulatingDynamicalFeatures_2000a:")
println(p)
println(p_desc)


p = [2.0, 1.7, 0.0, 0.0, 0.16, 0.0, 0.0, 0.2, 50.0, 0.0, 0.0, 0.0, 0.34, 1.0]
# ModelParameter: v_max, v_des, T, T2, l, step_time, τ_A, τ_R, α, β, ζ_h, ζ_v, r, ϕ
p_desc = "v_max, v_des, T, T2, l, step_time, τ_A, τ_R, α, β, ζ_h, ζ_v, r, λ"


println("The following parameters were given in zanlungo_SocialForceModel_2011:")
println(p)
println(p_desc)
;
