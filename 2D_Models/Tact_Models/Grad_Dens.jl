function Calc_e_pref(a::agent, menge::crowd, geometrie::geometry, system_size::NTuple{2, Float64})

    x = a.pos .+ a.e_des

    ∇ρ = ∇ρ_gauss(x, a, menge, geometrie, system_size)

    if abs(∇ρ) < 0.004

        a.e_des

    else

        normalize(a.e_des .+ a.α .* ∇ρ)

    end

end

function Calc_V_pref(a::agent, menge::crowd, geometrie::geometry, system_size::NTuple{2, Float64})

    if a.e_pref == (0.0, 0.0)

        0.0

    else

        x = a.pos .+ a.e_pref

        max(0.05, min((1/sqrt(ρ_gauss(x, a, menge, geometrie, system_size))-a.l)/a.T2, a.v_max))

    end

end

function Update_Pref_Velocity!(a::agent, menge::crowd, geometrie::geometry, system_size::NTuple{2, Float64})

    a.e_pref = Calc_e_pref(a, menge, geometrie, system_size)
    a.v_pref = Calc_V_pref(a, menge, geometrie, system_size)

end
