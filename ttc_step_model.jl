Score(a::agent, a_vel, a_ϕ) = (a.v_max .* a.desired_heading) ⋅ v(a_vel, a_ϕ)
Vel(ϕ, x, v_max) = x/(v_max*cos(ϕ))


function Calc_V_Heading_TTC_Complete(a::agent, menge::crowd, geometrie::geometry, system_size)

    score_ = -999.9
    ϕ_best, vel_best = 0.0, 0.0


    for vel in 0:0.1:a.v_max

        for ϕ in 0:0.01:2π

            if Score(a, vel, ϕ) > score_ &&
                Min_TTC(a, vel, Heading(ϕ), menge, geometrie, system_size) > a.T #&&
                #Physically_Attainable(a, vel, ϕ) == true
               score_ =  Score(a, vel, ϕ)
               ϕ_best, vel_best = ϕ, vel

            end

        end

    end

    if score_ == -999.9
        println("Collision Problem")
        a.desired_heading, 0
    else
        Heading(ϕ_best), vel_best
    end

end


#follow lines with the same score, not used yet
function Find_ϕ_and_v_to(x)

    dϕ = 0.025

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
