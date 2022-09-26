Score(a::agent, vel, ϕ) = -abs(v(vel, ϕ).-a.v_max.*a.e_des)
Score2(a::agent, vel, ϕ, ttc) =  -(1/ttc - Score(a, vel, ϕ))

function Calc_Heading_Velocity(a::agent, menge::crowd, geometrie::geometry, system_size)

    score_ = -999.9
    ϕ_best, vel_best = 0.0, 0.0
    ϕ_safest, vel_safest, score2 = 0.0, 0.0, -999.9

    for vel in 0:0.04:a.v_max

        for ϕ in 0:0.2:2π

            ϕ_, vel_ = w_mean_rvo(a, vel, ϕ)

            ttc_ = Min_TTC(a, vel_, Heading(ϕ_), menge, geometrie, system_size)

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


function w_mean_rvo(a::agent, vel, ϕ)

    #c = (Heading(ϕ).*vel .+ a.heading.*a.vel)./2
    c = Heading(ϕ).*(vel/a.α) .+ a.heading.*(a.vel*(1-1/a.α))

    ϕ_(c), abs(c)

end
