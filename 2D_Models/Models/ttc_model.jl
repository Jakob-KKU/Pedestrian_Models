#Vel(ϕ, x, v_max) = x/(v_max*cos(ϕ))
function Calc_Heading_Velocity(a::agent, menge::crowd, geometrie::geometry, system_size)

    score_ = -999.9
    ϕ_best, vel_best = 0.0, 0.0
    ϕ_safest, vel_safest, ttc_max = 0.0, 0.0, 0.0



    for vel in 0:0.02:a.v_max

        for ϕ in 0:0.1:2π

            ttc_ = Min_TTC(a, vel, Heading(ϕ), menge, geometrie, system_size)

            if Score(a, vel, ϕ) > score_ && ttc_ > a.T
               ϕ_best, vel_best, score_ = ϕ, vel, Score(a, vel, ϕ)
            end

            if ttc_ > ttc_max
                ttc_max, ϕ_safest, vel_safest  = ttc_, ϕ, vel
            end

        end

    end

    if score_ == -999.9
        #println("problem")
        Heading(ϕ_safest), vel_safest
    else
        Heading(ϕ_best), vel_best
    end

end
