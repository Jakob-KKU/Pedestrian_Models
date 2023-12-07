Score(a::agent, menge::crowd, geometrie::geometry, system_size) = 1/0.0001*Θ(AV(a, menge, geometrie, system_size) - 1)+abs(a.vel .*a.heading .- a.e_pref .* a.v_pref)^2

function Calc_Heading_Velocity(a::agent, menge::crowd, geometrie::geometry, system_size)

    if Preferred_Velocity_Optmial(a, menge, geometrie, system_size) == true

        a.e_pref, a.v_pref

    else

        Argmin_CostFunction(a, menge, geometrie, system_size)

    end

end

function Preferred_Velocity_Optmial(a::agent, menge::crowd, geometrie::geometry, system_size)

    if Min_TTC(a, a.v_pref, a.e_pref, menge, geometrie, system_size) >= a.T
        true
    else
        false
    end
end

p = [2.0, 1.7, 3.0, 0.0, 0.3, 0.0, 0.0, 0.1, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
# ModelParameter: v_max, v_des, T, T2, l, step_time, τ_A, τ_R, α, β, ζ_h, ζ_v, r, ϕ
p_desc = "v_max, v_des, T, T2, l, step_time, τ_A, τ_R, α, β, ζ_h, ζ_v, r, λ"


println("Typical parameters would be:")
println(p)
println(p_desc)
