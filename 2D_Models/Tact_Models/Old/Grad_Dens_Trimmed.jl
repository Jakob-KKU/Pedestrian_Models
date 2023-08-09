function Calc_e_pref(a::agent, menge::crowd, geometrie::geometry, system_size::NTuple{2, Float64})

    x = a.pos
    ∇ρ = ∇ρ_gauss(x, a, menge, geometrie, system_size)

    if abs(∇ρ) < a.r
        a.e_des
    else
        normalize(∇ρ)
    end

end

function Calc_V_pref(a::agent, menge::crowd, geometrie::geometry, system_size::NTuple{2, Float64})

    if a.e_pref == a.e_des
        0.0
    else
        0.25
    end

end

function Update_Pref_Velocity!(a::agent, menge::crowd, geometrie::geometry, system_size::NTuple{2, Float64})

    a.e_pref = Calc_e_pref(a, menge, geometrie, system_size)
    a.v_pref = Calc_V_pref(a, menge, geometrie, system_size)

end
