function Update_Pref_Velocity!(a::agent, menge::crowd, geometrie::geometry, system_size::NTuple{2, Float64})

    a.e_pref = Calc_e_pref(a, menge, geometrie, system_size)
    a.v_pref = Calc_V_pref(a, menge, geometrie, system_size)

end

function Calc_e_pref(a::agent, menge::crowd, geometrie::geometry, system_size::NTuple{2, Float64})


    x = a.pos .+ (0.0*a.l/2 + a.vel/2 ) .*a.heading

    ∇ρ = ∇ρ_gauss_ellipse(x, a, menge, geometrie, system_size)

    if abs(∇ρ) < a.r
        a.e_des
    else
        normalize(a.e_des .+ a.α .* ∇ρ)
        #normalize(∇ρ)
    end

end

function Calc_V_pref(a::agent, menge::crowd, geometrie::geometry, system_size::NTuple{2, Float64})

    #if a.e_pref == a.e_des
        #0.0
    #else
        x = a.pos .+ (0.0*a.l/2 + a.vel/2 ) .*a.heading

        max(0.0, min((1/sqrt(ρ_gauss_ellipse(x, a, menge, geometrie, system_size))-a.l)/a.T2, a.v_max))
    #end

end

function ρ_gauss_ellipse(x::NTuple{2, Float64}, a::agent, menge::crowd, geometrie::geometry, system_size::NTuple{2, Float64})

    ρ = 0.0

    for i in 2:a.neighbors_agents[1]+1

        ρ += ρ_gauss_ellipse_i(x, a, menge.agent[a.neighbors_agents[i]], system_size)

    end

    ρ

end

function ρ_gauss_ellipse_i(x::NTuple{2, Float64}, a::agent, b::agent, system_size::NTuple{2, Float64})

    d_tilde = d_vec_ellipse(x, a, b, system_size)

    if d_tilde[1] == 999.0

        0.0

    else

        1/(2*π*(1.5*b.l)^2)*exp(-(d_tilde[1]^2+d_tilde[2]^2)/(2*(1.5*b.l)^2))

    end

end



function ∇ρ_gauss_ellipse(x::NTuple{2, Float64}, a::agent, menge::crowd, geometrie::geometry, system_size::NTuple{2, Float64})

    ∇ρ = (0.0, 0.0)

    for i in 2:a.neighbors_agents[1]+1

        ∇ρ = ∇ρ .+ ∇ρ_gauss_ellipse_i(x, a, menge.agent[a.neighbors_agents[i]], system_size)

    end

    ∇ρ

end



function ∇ρ_gauss_ellipse_i(x::NTuple{2, Float64}, a::agent, b::agent, system_size::NTuple{2, Float64})

    d_ = d_vec(a, b, system_size)
    d_tilde = d_vec_ellipse2(x, a, b, system_size)

    if d_[1] == 999.0

        (0.0, 0.0)

    else

        ρ_gauss_ellips = 1/(2*π*(1.5*b.l)^2)*exp(-(d_tilde[1]^2+d_tilde[2]^2)/(2*(1.5*b.l)^2))

        normalize(d_) .* abs(d_tilde) .* (ρ_gauss_ellips/(1.5*b.l)^2)

    end

end

function d_ellipse(x::NTuple{2, Float64}, a::agent, b::agent, system_size::NTuple{2, Float64})

    d_ab = d_vec(x, b, system_size)

    if a.heading ⋅ d_ab ≥ 0.0

        999.0

    else

        d_para = (a.heading ⋅ d_ab).*a.heading
        d_perp = d_ab .- d_para

        abs(d_para.+d_para*L_ellipse(a)/w_ellipse(a))

    end
end

function d_vec_ellipse(x::NTuple{2, Float64}, a::agent, b::agent, system_size::NTuple{2, Float64})

    d_ab = d_vec(x, b, system_size)

    if a.heading ⋅ d_ab > 0.0

       (999.0, 999.0)

    else

        d_para = (d_ab ⋅ a.heading).*a.heading
        d_perp = d_ab .- d_para

        d_para .+ d_perp.*(L_ellipse(a)/w_ellipse(a))

    end
end

function d_vec_ellipse2(x::NTuple{2, Float64}, a::agent, b::agent, system_size::NTuple{2, Float64})

    d_ab = d_vec(x, b, system_size)


    d_para = (d_ab ⋅ a.heading).*a.heading
    d_perp = d_ab .- d_para

    d_para .+ d_perp.*(L_ellipse(a)/w_ellipse(a))

end

L_ellipse(a::agent) = a.l + a.vel*a.T2
w_ellipse(a::agent) = a.l + a.vel*a.T2/2
