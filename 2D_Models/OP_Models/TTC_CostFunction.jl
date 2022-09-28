Score(a::agent, v, ttc) = Θ(a.T/ttc - 1)/0.01+abs(v .- a.e_pref .* a.v_pref)^2


function Calc_Heading_Velocity(a::agent, menge::crowd, geometrie::geometry, system_size)

    if v_des_Possible(a, menge, geometrie, system_size) == true

        a.e_pref, a.v_pref

    else

        Sample_Best_v(a, menge, geometrie, system_size)

    end

end

function v_des_Possible(a::agent, menge::crowd, geometrie::geometry, system_size)

    if Min_TTC(a, a.v_pref, a.e_pref, menge, geometrie, system_size) >= a.T
        true
    else
        false
    end
end

function Sample_Best_v(a::agent, menge::crowd, geometrie::geometry, system_size)

    score_, vel_, ϕ_ = 999.9, 0.0, 0.0

    for vel in 0:0.08:a.v_max

        for ϕ in 0:0.4:2π

            ttc_ = Min_TTC(a, vel, Heading(ϕ), menge, geometrie, system_size)

            if Score(a, v(vel, ϕ), ttc_) <= score_
                ϕ_, vel_, score_ = ϕ, vel, Score(a, v(vel, ϕ), ttc_)
                println(vel_)
            end

        end
    end

    Heading(ϕ_), vel_
end
