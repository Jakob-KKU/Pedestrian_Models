Score(a::agent, a_vel, a_ϕ) = (a.v_max .* a.e_des) ⋅ v(a_vel, a_ϕ)


#sampling based algorithm
function Calc_Heading_Velocity(a::agent, menge::crowd, geometrie::geometry, system_size)

    if v_des_possible(a, menge, geometrie, system_size) == true

        a.e_des, a.v_max

    else

        sample_best_v(a, menge, geometrie, system_size)

    end

end

function v_des_possible(a::agent, menge::crowd, geometrie::geometry, system_size)

    if Min_TTC(a, a.v_max, a.e_des, menge, geometrie, system_size) >= a.T
        true
    else
        false
    end
end

function sample_best_v(a::agent, menge::crowd, geometrie::geometry, system_size)

    score_ = -999.9
    ϕ_best, vel_best = 0.0, 0.0
    ϕ_safest, vel_safest, ttc_max = 0.0, 0.0, 0.0
    i = 1

    while ttc_max < a.T && i<=2

        for _ in 1:20

            vel = a.v_max*rand()
            ϕ = 2π*rand()

            ttc_ = Min_TTC(a, vel, Heading(ϕ), menge, geometrie, system_size)

            if Score(a, vel, ϕ) > score_ && ttc_ > a.T
               ϕ_best, vel_best, score_ = ϕ, vel, Score(a, vel, ϕ)
            end

            if ttc_ > ttc_max
                ttc_max, ϕ_safest, vel_safest  = ttc_, ϕ, vel
            end

        end

        i+=1

    end

    if score_ == -999.9
        Heading(ϕ_safest), vel_safest
    else
        Heading(ϕ_best), vel_best
    end

end
