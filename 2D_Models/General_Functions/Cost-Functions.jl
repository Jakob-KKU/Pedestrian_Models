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


#Return the velocity that minimizes the function Score, optimization solved by sampling a regular grid
function Argmin_CostFunction(a::agent, menge::crowd, geometrie::geometry, system_size)

    score_, vel_, ϕ_ = 999.9, 0.0, 0.0

    Δv = a.v_max / 500
    Δϕ = 2π / 500

    for vel ∈ 0:Δv:a.v_max

        for ϕ ∈ 0:Δϕ:2π

            score_help = Score(a, vel .* Heading(ϕ), menge, geometrie, system_size)

            if score_help <= score_
                ϕ_, vel_, score_ = ϕ, vel, score_help
            end

        end
    end

    Heading(ϕ_), vel_
end

#Return the velocity that minimizes the function Score, optimization solved by random sampling
function Argmin_CostFunction_RandomSampling(a::agent, menge::crowd, geometrie::geometry, system_size)

    score_, vel_, heading_ = 99999999.9, 0.0, (0.0, 0.0)

    N = 5000

    for i in 1:N

        #This samples a random velocity in the circle with radius a.v_max, the sqrt ensures a uniform sampling in the v_x v_y space
        heading, vel = Random_Velocity(a)

        score_help = Score(a, vel .* heading, menge, geometrie, system_size)

        if score_help <= score_
            heading_, vel_, score_ = heading, vel, score_help
        end

    end

    heading_, vel_
end

#This samples a random velocity in the circle with radius a.v_max, the sqrt ensures a uniform sampling in the v_x v_y space
function Random_Velocity(a::agent)

    Heading(2π*rand()), sqrt(rand())*a.v_max

end



;
