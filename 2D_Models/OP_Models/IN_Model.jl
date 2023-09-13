ϕ(a::agent, menge::crowd, geometrie::geometry, system_size) = IN(a, menge, system_size) +
    0.1*IN(a, geometrie, system_size)

function Calc_Heading_Velocity(a::agent, menge::crowd, geometrie::geometry, system_size)

    v_new = a.v_pref .* a.e_pref .- a.α .* ∇r_ϕ(a, menge, geometrie, system_size)

    normalize(v_new), min(a.v_max, abs(v_new))

end
;
