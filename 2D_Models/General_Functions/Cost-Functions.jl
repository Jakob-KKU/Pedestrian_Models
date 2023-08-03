#Score(ϕ, v, v_max) = v*v_max*cos(ϕ)
Vel(ϕ, x, v_max) = x/(v_max*cos(ϕ))


#follow lines with the same score, not used yet
function Find_ϕ_and_v_to(x, v_max)

    dϕ = 0.1

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

function Calc_CostFunctionMatrix(a::agent, menge::crowd, geometrie::geometry, system_size)

    v_xs = collect(-a.v_max:0.01:a.v_max)
    v_ys = collect(-a.v_max:0.01:a.v_max)
    cost = fill(0.0, length(v_ys), length(v_xs))

    for (i, v_x) in enumerate(v_xs)

        for (j, v_y) in enumerate(v_ys)

            cost[j, i] = Score(a, (v_x, v_y), menge, geometrie, system_size)

        end
    end

    v_xs, v_ys, cost
end


#Return the velocity that minimizes the function Score
function Argmin_CostFunction(a::agent, menge::crowd, geometrie::geometry, system_size)

    score_, vel_, ϕ_ = 999.9, 0.0, 0.0

    for vel ∈ 0:0.08:a.v_max

        for ϕ ∈ 0:0.4:2π

            #println( vel .* Heading(ϕ))

            score_help = Score(a, vel .* Heading(ϕ), menge, geometrie, system_size)

            if score_help <= score_
                ϕ_, vel_, score_ = ϕ, vel, score_help
            end

        end
    end

    Heading(ϕ_), vel_
end


;
