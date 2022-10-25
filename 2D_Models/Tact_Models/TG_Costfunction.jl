Score(a::agent, v, tg) = Θ(a.T2/tg - 1)/0.001+abs(v .- a.e_des .* a.v_max)^2

function Update_Pref_Velocity!(a::agent, menge::crowd, geometrie::geometry, system_size::NTuple{2, Float64})

    if v_des_Possible_TG(a, menge, geometrie, system_size) == true

        a.v_pref, a.e_pref = a.v_max,  a.e_des

    else

        a.e_pref, a.v_pref = Sample_Best_v_TG(a, menge, geometrie, system_size)

    end

end

function v_des_Possible_TG(a::agent, menge::crowd, geometrie::geometry, system_size)

    if Min_TimeGap(a, a.v_max, a.e_des, menge, geometrie, system_size) >= a.T2
        true
    else
        false
    end
end

function Sample_Best_v_TG(a::agent, menge::crowd, geometrie::geometry, system_size)

    score_, vel_, ϕ_ = 999.9, 0.0, 0.0

    for vel in 0:0.08:a.v_max

        for ϕ in 0:0.4:2π

            tg_ = Min_TimeGap(a, vel, Heading(ϕ), menge, geometrie, system_size)

            if Score(a, v(vel, ϕ), tg_) <= score_
                ϕ_, vel_, score_ = ϕ, vel, Score(a, v(vel, ϕ), tg_)
            end

        end
    end

    Heading(ϕ_), vel_
end
