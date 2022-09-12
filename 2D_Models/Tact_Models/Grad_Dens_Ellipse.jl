function Calc_e_pref(a::agent, menge::crowd, geometrie::geometry, system_size::NTuple{2, Float64})

    ∇ρ = ∇ρ_gauss_ellipse(a, menge, geometrie, system_size)

    if abs(∇ρ) < a.r
        a.e_des
    else
        normalize(a.e_des .+ a.α .* ∇ρ)
    end

end

function Calc_V_pref(a::agent, menge::crowd, geometrie::geometry, system_size::NTuple{2, Float64})

    if a.e_pref == (0.0, 0.0)
        0.0
    else
        max(0.0, min((1/sqrt(ρ_gauss_ellipse(a, menge, geometrie, system_size))-a.l)/a.T2, a.v_max))
    end

end

function Update_Pref_Velocity!(a::agent, menge::crowd, geometrie::geometry, system_size::NTuple{2, Float64})

    a.e_pref = Calc_e_pref(a, menge, geometrie, system_size)
    a.v_pref = Calc_V_pref(a, menge, geometrie, system_size)

end

function ρ_gauss_ellipse_i(a::agent, b::agent, system_size::NTuple{2, Float64})

    d_tilde = d_vec_ellipse(a, b, system_size)

    if d_tilde[1] == 999.0

        0.0

    else

        1/(2*π*(1.5*b.l)^2)*exp(-(d_tilde[1]^2+d_tilde[2]^2)/(2*(1.5*b.l)^2))

    end

end

function ∇ρ_gauss_ellipse_i(a::agent, b::agent, system_size::NTuple{2, Float64})

    d_tilde = d_vec_ellipse(a, b, system_size)

    if d_tilde[1] == 999.0

        (0.0, 0.0)

    else

        d_tilde .* (ρ_gauss_ellipse_i(a, b, system_size)/(1.5*b.l)^2)

    end

end


function ρ_gauss_ellipse(a::agent, menge::crowd, geometrie::geometry, system_size::NTuple{2, Float64})

    ρ = 0.0

    for i in 2:a.neighbors_agents[1]+1

        ρ += ρ_gauss_ellipse_i(a, menge.agent[a.neighbors_agents[i]], system_size)

    end

    ρ

end

function ∇ρ_gauss_ellipse(a::agent, menge::crowd, geometrie::geometry, system_size::NTuple{2, Float64})

    ∇ρ = (0.0, 0.0)

    for i in 2:a.neighbors_agents[1]+1

        ∇ρ = ∇ρ .+ ∇ρ_gauss_ellipse_i(a, menge.agent[a.neighbors_agents[i]], system_size)

    end

    ∇ρ

end

function d_ellipse(a::agent, b::agent, system_size::NTuple{2, Float64})

    d_ab = d_vec(a, b, system_size)

    if a.heading ⋅ d_ab > 0.0

        999.0

    else

        d_para = (a.heading ⋅ d_ab).*a.heading
        d_perp = d_ab .- d_para

        abs(d_para.+d_para*L_ellipse(a)/w_ellipse(a))

    end
end

function d_vec_ellipse(a::agent, b::agent, system_size::NTuple{2, Float64})

    d_ab = d_vec(a, b, system_size)

    if a.heading ⋅ d_ab > 0.0

        (999.0, 999.0)

    else

        d_para = (d_ab ⋅ a.heading).*a.heading
        d_perp = d_ab .- d_para

        d_para .+ d_perp.*(L_ellipse(a)/w_ellipse(a))

    end
end

L_ellipse(a::agent) = a.l + a.vel*a.T2
w_ellipse(a::agent) = a.l + a.vel*a.T2/3
