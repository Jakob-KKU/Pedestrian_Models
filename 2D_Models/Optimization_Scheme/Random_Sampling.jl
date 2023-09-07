#Return the velocity that minimizes the function Score, optimization solved by random sampling
function Argmin_CostFunction_RandomSampling(a::agent, menge::crowd, geometrie::geometry, system_size, N = 500)

    score_, vel_, heading_ = 99999999.9, 0.0, (0.0, 0.0)

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
