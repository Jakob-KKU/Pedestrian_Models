Score(a::agent, a_vel, a_ϕ) = (a.v_max .* a.desired_heading) ⋅ v(a_vel, a_ϕ)


function Calc_Heading_Velocity(a::agent, menge::crowd, geometrie::geometry, system_size)

    score_ = -999.9
    ϕ_best, vel_best = 0.0, 0.0
    ϕ_safest, vel_safest, tgap_max = 0.0, 0.0, 0.0

    for vel in 0:0.04:a.v_max

        for ϕ in 0:0.2:2π

            tgap_ = Min_TimeGap_Ant(a, vel, Heading(ϕ), menge, geometrie, system_size)

            if Score(a, vel, ϕ) > score_ && tgap_ > a.T
               ϕ_best, vel_best, score_ = ϕ, vel, Score(a, vel, ϕ)
            end

            if tgap_ > tgap_max
                tgap_max, ϕ_safest, vel_safest  = tgap_, ϕ, vel
            end

        end

    end

    if score_ == -999.9
        Heading(ϕ_safest), vel_safest
    else
        Heading(ϕ_best), vel_best
    end
end
