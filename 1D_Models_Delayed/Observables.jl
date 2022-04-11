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

function variance(x::Vector)

    x_mean = sum(x)/length(x)
    varianz = 0

    for val in x

            varianz += (val-x_mean)^2

    end

    return varianz/(length(x))
end

function variance(x::Matrix, x_mean)

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

function Autocorrelation_V(menge::crowd, T, l, L, dt, dt_save, t_sim, t_relax, samples::Int, dt_ac, t_max_ac)

    t_ac = collect(0:dt_ac:t_max_ac)
    ac = fill(0.0, length(t_ac))
    σ_v = 0.0

    for i in 1:samples

        #println("Calculate sample ", i, " von ", samples, "... ")

        Random.seed!()

        Init_Hom_History!(menge, (L/N-l)/T, L, dt)
        Add_History_Pertubation!(menge, 1, L, dt);


        positions, velocities = Simulate!(menge, dt, dt_save, t_sim, t_relax, L);

        v_mean = mean(velocities)
        σ_v += variance(velocities, v_mean)

        for (j,t) in enumerate(t_ac)

            ac[j] += Corr(velocities, v_mean, dt_save, t)

        end

    end

    t_ac, ac./samples, σ_v/samples

end
;
