ϕ(a::agent, menge::crowd, geometrie::geometry, system_size) = IN(a, menge, system_size) +
    0.1*IN(a, geometrie, system_size)

function Calc_Heading_Velocity(a::agent, menge::crowd, geometrie::geometry, system_size)

    v_new = a.v_pref .* a.e_pref .- a.α .* ∇r_ϕ(a, menge, geometrie, system_size)

    normalize(v_new), min(a.v_max, abs(v_new))

end

p = [2.0, 1.7, 0.0, 0.0, 0.3, 0.0, 0.0, 0.1, 0.03, 0.0, 0.0, 0.0, 0.5, 0.0]
# ModelParameter: v_max, v_des, T, T2, l, step_time, τ_A, τ_R, α, β, ζ_h, ζ_v, r, ϕ
p_desc = "v_max, v_des, T, T2, l, step_time, τ_A, τ_R, α, β, ζ_h, ζ_v, r, λ"


println("Typical parameters would be:")
println("p = ", p)
println(p_desc)
;
