function Calc_Heading_Velocity(a::agent, menge::crowd, geometrie::geometry, system_size)

    v_ = a.e_pref .* a.v_pref .- a.α .* ∇r_ϕ(a, menge, geometrie, system_size)

    normalize(v_), min(a.v_max, abs(v_))

end

ϕ(a::agent, b::element) = a.α * a.r * exp(-Effective_Distance(a, b)/(a.r*l(a,b)))
ϕ(a::agent, b::element, system_size) = a.α * a.r * exp(-Effective_Distance(a, b, system_size)/(a.r*l(a,b)))

ϕ(a::agent, b::agent, system_size) = a.α * a.r * exp(-Effective_Distance(a, b, system_size)/(a.r*l(a,b)))
ϕ(a::agent, b::agent) = a.α * a.r * exp(-Effective_Distance(a, b)/(a.r*l(a,b)))

Effective_Distance(a::agent, b::element) = 0.5*sqrt((d(a,b) + abs((a.pos.-b.pos).+v(a).*a.τ_A))^2-
            abs(v(a).*a.τ_A)^2)

Effective_Distance(a::agent, b::element, system_size) = 0.5*sqrt((d(a,b,system_size) +
        abs(d_vec(a, b, system_size).+v(a).*a.τ_A))^2 - abs(v(a).*a.τ_A)^2)

Effective_Distance(a::agent, b::agent) = 0.5*sqrt((d(a,b) + abs((a.pos.-b.pos).-(v(b).-v(a)).*a.τ_A))^2-
        abs((v(b).-v(a)).*a.τ_A)^2)

Effective_Distance(a::agent, b::agent, system_size) = 0.5*sqrt((d(a,b,system_size) +
        abs(d_vec(a, b, system_size).-(v(b).-v(a)).*a.τ_A))^2 - abs((v(b).-v(a)).*a.τ_A)^2)



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

p = [2.0, 1.7, 0.0, 0.0, 0.0, 0.0, 1.74, 1.2, 0.67, 0.0, 0.0, 0.0, 0.62, 0.19]
# ModelParameter: v_max, v_des, T, T2, l, step_time, τ_A, τ_R, α, β, ζ_h, ζ_v, r, ϕ
p_desc = "v_max, v_des, T, T2, l, step_time, τ_A, τ_R, α, β, ζ_h, ζ_v, r, λ"


println("The following parameters were given in zanlungo_SocialForceModel_2011:")
println(p)
println(p_desc)
