#Score(a::agent, vel, ϕ) = -abs(v(vel, ϕ).-a.v_max.*a.e_des)
#Score2(a::agent, vel, ϕ, ttc) =  -(1/ttc - Score(a, vel, ϕ))
Score(a::agent, v, ttc) = a.T/ttc+abs(v .- a.e_pref .* a.v_pref)

function Calc_Heading_Velocity(a::agent, menge::crowd, geometrie::geometry, system_size)

    score_ = 999.9
    ϕ_best, vel_best = 0.0, 0.0

    for vel in 0:0.02:a.v_max

        for ϕ in 0:0.1:2π

            ϕ_, vel_ = w_mean_rvo(a, vel, ϕ)

            ttc_ = Min_TTC(a, vel_, Heading(ϕ_), menge, geometrie, system_size)

            if Score(a, Heading(ϕ_).*vel_, ttc_) < score_
               ϕ_best, vel_best, score_ = ϕ, vel, Score(a, Heading(ϕ_).*vel_, ttc_)
            end

        end
    end

    Heading(ϕ_best), vel_best

end


function w_mean_rvo(a::agent, vel, ϕ)

    #c = (Heading(ϕ).*vel .+ a.heading.*a.vel)./2
    c = Heading(ϕ).*(vel/a.α) .+ a.heading.*(a.vel*(1-1/a.α))

    ϕ_(c), abs(c)

end
