#COMPLETE NONESENSE!
#Score(a::agent, v, tg) = Θ(a.T2/tg - 1, 2)/0.1+abs(v .- a.e_des .* a.v_max)^2
Score(a::agent, v, tg) = 10*(a.T2/tg) + abs(v .- a.e_des .* a.v_max)^2
function Update_Pref_Velocity!(a::agent, menge::crowd, geometrie::geometry, system_size::NTuple{2, Float64})

    v_ = Calc_v_pref(a, menge, geometrie, system_size)

    a.e_pref = normalize(v_)
    a.v_pref = max(0.0, min(a.v_max, abs(v_)))
end

function Calc_v_pref(a::agent, menge::crowd, geometrie::geometry, system_size::NTuple{2, Float64})

    v_p =  a.e_pref .* a.v_pref

    v_p .- a.α .* ∇Score(a, v_p, menge, geometrie, system_size)
end

function ∇Score(a::agent, v, menge::crowd, geometrie::geometry, system_size::NTuple{2, Float64})

    h = 0.0001

    tg_ = TimeGap_ρ(a, v, menge, geometrie, system_size)
    score_ = Score(a, v, tg_)

    v_x = v .+ h.*(1.0, 0.0)
    tg_x = TimeGap_ρ(a, v_x, menge, geometrie, system_size)
    score_x = Score(a, v_x, tg_x)

    v_y = v .+ h.*(0.0, 1.0)
    tg_y = TimeGap_ρ(a, v_y, menge, geometrie, system_size)
    score_y = Score(a, v_y, tg_y)

    ((score_x, score_y) .- score_)./h
end

function TimeGap_ρ(a::agent, v, menge::crowd, geometrie::geometry, system_size::NTuple{2, Float64})

    x = a.pos .+  v .* a.T2 ./2
    if abs(v) == 0.0
        999.9
    else
        (1/sqrt(ρ_gauss(x, a, menge, geometrie, system_size))-a.l)/abs(v)
    end

end
