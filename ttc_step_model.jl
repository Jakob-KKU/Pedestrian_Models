Score(a::agent, a_vel, a_ϕ) = (a.v_max .* a.desired_heading) ⋅ v(a_vel, a_ϕ)
Score(ϕ, v, v_max) = v*v_max*cos(ϕ)

Vel(ϕ, x, v_max) = x/(v_max*cos(ϕ))


function Calc_V_Heading_TTC_Complete(a::agent, menge::crowd, geometrie::geometry, system_size)

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


#follow lines with the same score, not used yet
function Find_ϕ_and_v_to(x, v_max)

    dϕ = 0.01

    v_values = []
    ϕ_values = []

    if x > 0



        for Δϕ in 0.0:dϕ:acos(x/v_max^2)

            push!(ϕ_values, Δϕ)
            push!(v_values, Vel(Δϕ, x, v_max))
        end

        for Δϕ in 2π-acos(x/v_max^2):dϕ:2π

            push!(ϕ_values, Δϕ)
            push!(v_values, Vel(Δϕ, x, v_max))
        end


    else

        for Δϕ in acos(x/v_max^2):dϕ:2π-acos(x/v_max^2)

            push!(ϕ_values, Δϕ)
            push!(v_values, Vel(Δϕ, x, v_max))

        end
    end

    v_values, ϕ_values

end

function score_maxtrix(ϕs, vs, v_max)

    xs = fill(0.0, length(vs), length(ϕs))

    for i in 1:length(ϕs)

        for j in 1:length(vs)

            xs[j, i] = Score(ϕs[i], vs[j], v_max)

        end

    end

    xs
end
