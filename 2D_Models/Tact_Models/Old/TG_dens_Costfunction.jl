Score(a::agent, v, tg) = Θ(a.T2/tg - 1)/0.001+abs(v .- a.e_des .* a.v_max)^2

function Update_Pref_Velocity!(a::agent, menge::crowd, geometrie::geometry, system_size::NTuple{2, Float64})

    if v_des_Possible_TG(a, menge, geometrie, system_size) == true

        a.v_pref, a.e_pref = a.v_max,  a.e_des

    else

        a.e_pref, a.v_pref = Sample_Best_v_TG(a, menge, geometrie, system_size)

    end

end

function v_des_Possible_TG(a::agent, menge::crowd, geometrie::geometry, system_size)

    if TimeGap(a, a.v_max.*a.e_des, menge, geometrie, system_size) >= a.T2
        true
    else
        false
    end
end

function Sample_Best_v_TG(a::agent, menge::crowd, geometrie::geometry, system_size)

    score_, vel_, ϕ_ = 999.9, 0.0, 0.0

    for vel in 0:0.08:a.v_max

        for ϕ in 0:0.4:2π

            tg_ = TimeGap(a, v(vel, ϕ), menge, geometrie, system_size)

            if Score(a, v(vel, ϕ), tg_) <= score_
                ϕ_, vel_, score_ = ϕ, vel, Score(a, v(vel, ϕ), tg_)
            end

        end
    end

    Heading(ϕ_), vel_
end


function TimeGap_ρ(a::agent, v, menge::crowd, geometrie::geometry, system_size::NTuple{2, Float64})

    x = a.pos .+ a.T2/2 .* v
    if abs(v) == 0.0
        999.9
    else
        (1/sqrt(ρ_gauss_ellipse(x, a, menge, geometrie, system_size))-a.l)/abs(v)
    end

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
