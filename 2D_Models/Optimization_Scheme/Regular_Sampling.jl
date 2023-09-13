#Return the velocity that minimizes the function Score, optimization solved by sampling a regular grid
function Argmin_CostFunction(a::agent, menge::crowd, geometrie::geometry, system_size, N = 500)

    score_, vel_, ϕ_ = 999.9, 0.0, 0.0

    n1 = Int(round(N))

    Δv = a.v_max / n1
    Δϕ = 2π / n1

    for vel ∈ 0:Δv:a.v_max

        for ϕ ∈ 0:Δϕ:2π

            score_help = Calc_Score(a, vel .* Heading(ϕ), menge, geometrie, system_size)

            if score_help <= score_
                ϕ_, vel_, score_ = ϕ, vel, score_help
            end

        end
    end

    Heading(ϕ_), vel_
end
