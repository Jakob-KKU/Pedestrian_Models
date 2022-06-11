Score(a::agent, a_vel, a_ϕ) = (a.v_pref .* a.e_pref) ⋅ v(a_vel, a_ϕ)


#the ttc model including Physical Restrictrions
function Calc_Heading_Velocity(a::agent, menge::crowd, geometrie::geometry, system_size)

    score_ = -999.9
    ϕ_best, vel_best = 0.0, 0.0
    ϕ_safest, vel_safest, ttc_max = 0.0, 0.0, 0.0



    for vel in 0:0.08:a.v_max

        for ϕ in 0:0.4:2π

            ttc_ = Min_TTC(a, vel, Heading(ϕ), menge, geometrie, system_size)

            if Score(a, vel, ϕ) > score_ && ttc_ > a.T && physically_attainable(a, vel, ϕ) == true
               ϕ_best, vel_best, score_ = ϕ, vel, Score(a, vel, ϕ)
            end

            if ttc_ > ttc_max && physically_attainable(a, vel, ϕ) == true
                ttc_max, ϕ_safest, vel_safest  = ttc_, ϕ, vel
            end

        end

    end

    if score_ == -999.9
        Heading(ϕ_safest), vel_safest
    else
        Heading(ϕ_best), vel_best
    end

end

max_v(a::agent , ϕ) = min(a.v_max, 0.5*abs(π-mod(ϕ-ϕ_(a), 2π)))
max_v(a::agent , ϕ::Vector) = [max_v(a ,x) for x in ϕ]

function physically_attainable(a::agent, vel::Float64, ϕ::Float64)

    if vel > max_v(a, ϕ)
        false
    else
        true
    end

end
