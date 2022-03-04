function variance(x::Matrix, x_mean)

    varianz = 0

    for i in 1:size(x)[2]

        for j in 1:size(x)[1]

            varianz += (x[j,i]-x_mean)^2

        end

    end

    return varianz/(size(x)[1]*size(x)[2])
end

function variance(x::Matrix)

    x_mean = mean(x)

    varianz = 0

    for i in 1:size(x)[2]

        for j in 1:size(x)[1]

            varianz += (x[j,i]-x_mean)^2

        end

    end

    return varianz/(size(x)[1]*size(x)[2])
end

function Corr(x::Matrix, x_mean, dt_x, t_ac)

    γ = 0

    Δj = Int(round(t_ac/dt_x))


    for i in 1:size(x)[2]

        for j in 1:size(x)[1]-Δj

            γ += (x[j,i]-x_mean)*(x[j+Δj,i]-x_mean)

        end

    end

    γ/(size(x)[2]*(size(x)[1]-Δj))

end

function Autocorrelation_V(menge::crowd, L, dt, dt_save, t_sim, t_relax, samples::Int, dt_ac, t_max_ac)

    t_ac = collect(0:dt_ac:t_max_ac)
    ac = fill(0.0, length(t_ac))
    σ_v = 0.0

    for i in 1:samples

        #println("Calculate sample ", i, " von ", samples, "... ")

        Random.seed!()

        Init_Hom_Positions!(menge, L)
        Init_Hom_Velocities!(menge, 0.0)
        Add_Max_Pertubation!(menge, 1, L)


        positions, velocities = Simulate_2nd_Order!(menge, dt, dt_save, t_sim, t_relax, L);

        v_mean = mean(velocities)
        σ_v += variance(velocities, v_mean)

        for (j,t) in enumerate(t_ac)

            ac[j] += Corr(velocities, v_mean, dt_save, t)

        end

    end

    t_ac, ac./samples, σ_v/samples

end

function Find_First_Max(x::Array)

    i_max = 0

    for i in 1:length(x)-2

        if x[i+1]-x[i] > 0 && x[i+2]-x[i+1] < 0

            i_max = i+1
            break

        end

    end

    if i_max == 0

        false

    else

        x[i_max]

    end



end
;
