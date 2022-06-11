#Score(a::agent, vel, ϕ) = -abs(vel-a.v_pref)+(v(vel, ϕ)⋅(a.v_pref.*a.desired_heading))
#Score(a::agent, vel, ϕ) = -abs(v(vel, ϕ).-a.v_pref.*a.desired_heading)+(v(vel, ϕ)⋅(a.v_pref.*a.desired_heading))

Score(a::agent, vel, ϕ) = -abs(v(vel, ϕ).-a.v_pref.*a.e_pref)
Score2(a::agent, vel, ϕ, ttc) =  -(1/ttc - Score(a, vel, ϕ))

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

    score_ = -999.9
    ϕ_best, vel_best = 0.0, 0.0
    ϕ_safest, vel_safest, score2 = 0.0, 0.0, -999.9

    for vel in 0:0.08:a.v_max

        for ϕ in 0:0.4:2π

            ttc_ = Min_TTC(a, vel, Heading(ϕ), menge, geometrie, system_size)

            if Score(a, vel, ϕ) > score_ && ttc_ > a.T
               ϕ_best, vel_best, score_ = ϕ, vel, Score(a, vel, ϕ)
            end

            if Score2(a, vel, ϕ, ttc_) > score2
                ϕ_safest, vel_safest, score2  =  ϕ, vel, Score2(a, vel, ϕ, ttc_)
            end
        end
    end

    if score_ == -999.9
        Heading(ϕ_safest), vel_safest
    else
        Heading(ϕ_best), vel_best
    end

end
