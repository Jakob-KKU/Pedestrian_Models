#Return the velocity that minimizes the function Score, optimization solved by sampling a regular grid
function Argmin_CostFunction(a::agent, menge::crowd, geometrie::geometry, system_size)

    score_, vel_, ϕ_ = 999.9, 0.0, 0.0

    Δv = a.v_max / 25
    Δϕ = 2π / 25

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
