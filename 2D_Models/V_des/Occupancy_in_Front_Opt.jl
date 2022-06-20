function Update_Pref_Velocity!(a::agent, menge::crowd, geometrie::geometry, system_size::NTuple{2, Float64})

    ϕ_max, Δϕ = π/4, π/16
    opt, v_pref, e_pref = 999.0, 0.0, (0.0, 0.0)

    for ϕ in -ϕ_max:Δϕ:ϕ_max

        a.e_pref = R(ϕ)⋅a.e_des
        a.v_pref = V_cone(a, menge, system_size)

        opt_ = abs(a.e_des .*5.0 .- a.v_pref*a.τ_A.*a.e_pref)

        if opt_ < opt

            opt, v_pref, e_pref = opt_, a.v_pref, a.e_pref
        end

    end

    a.e_pref, a.v_pref = e_pref, v_pref
end

function V_cone(a::agent, menge::crowd, system_size)
    min(a.v_max, max(0.05, (sqrt(1/ρ_Cone(a, menge, system_size))-a.l)/(a.T2)))
end
