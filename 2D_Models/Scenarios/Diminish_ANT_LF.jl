function Calc_Temp_Headings_and_Velocities!(menge::crowd, geometrie::geometry, temp_headings
        , temp_velocities, system_size::NTuple{2, Float64}, dt)

    N_dim = 3

    for (i,x) in enumerate(menge.agent[1:N-N_dim])
            temp_headings[i], temp_velocities[i]  = Calc_Heading_Velocity(x, menge, geometrie, system_size)
    end

    for (i,x) in enumerate(menge.agent[N-N_dim+1:end])
            temp_headings[N-N_dim+i], temp_velocities[N-N_dim+i]  = Calc_Heading_Velocity_TG(x, menge, geometrie, system_size)
    end

end

Score_TG(a::agent, a_vel, a_ϕ) = (a.v_max .* a.e_des) ⋅ v(a_vel, a_ϕ)


function Calc_Heading_Velocity_TG(a::agent, menge::crowd, geometrie::geometry, system_size)

    if v_des_possible_TG(a, menge, geometrie, system_size) == true

        a.e_des, a.v_max

    else

        find_best_v_TG(a, menge, geometrie, system_size)

    end

end

function v_des_possible_TG(a::agent, menge::crowd, geometrie::geometry, system_size)

    if Min_TimeGap(a, a.v_max, a.e_des, menge, geometrie, system_size) >= a.T
        true
    else
        false
    end
end

function find_best_v_TG(a::agent, menge::crowd, geometrie::geometry, system_size)

    score_ = -999.9
    ϕ_best, vel_best = 0.0, 0.0
    ϕ_safest, vel_safest, tgap_max = 0.0, 0.0, 0.0


    for vel in 0:0.08:a.v_max

        for ϕ in 0:0.4:2π

            tgap_ = Min_TimeGap(a, vel, Heading(ϕ), menge, geometrie, system_size)

            if Score_TG(a, vel, ϕ) > score_ && tgap_ > a.T
               ϕ_best, vel_best, score_ = ϕ, vel, Score_TG(a, vel, ϕ)
            end

            if tgap_ > tgap_max
                tgap_max, ϕ_safest, vel_safest  = tgap_, ϕ, vel
            end

        end

    end

    if score_ == -999.9
        Heading(ϕ_safest), vel_safest
    else
        Heading(ϕ_best), vel_best
    end

end

function Two_Approaching_Crowds_Dim(menge::crowd, geometrie::geometry, w_c, x_min_dim, x_max_dim, N_dim::Int, system_size)

    N = length(menge.agent)
    N1 = Int(round(N/2))
    N2 = Int(round(N_dim/2))

    if ρ_global(N1, (w_c, system_size[2])) > 7.5
        println("The density is too high!")
    elseif ρ_global(length(menge.agent) - N1, (w_c, system_size[2])) > 7.5
        println("The density is too high!")
    else

        #assign normal agents on the left
        Random_Pos_In_Rectangle((0.0, 0.0), (w_c, system_size[2]), 1, N1-N2, menge, (1, 0), system_size, geometrie)

        #assign normal agents on the right
        Random_Pos_In_Rectangle((system_size[1]-w_c, 0.0), (system_size[1],system_size[2]), N1-N2+1, N-N_dim, menge, (-1, 0), system_size, geometrie)

        #assign dim agents on the left
        Random_Pos_In_Rectangle((x_min_dim, 0.0), (x_max_dim, system_size[2]), N-N_dim+1, N-N2, menge, (1, 0), system_size, geometrie)

        #assign dim agents on the right
        P1 = (system_size[1]-x_max_dim, 0.0)
        P2 = (system_size[1]-x_min_dim, system_size[2])
        Random_Pos_In_Rectangle(P1, P2, N-N2+1, N, menge::crowd, (-1, 0), system_size, geometrie)

    end
end

function Two_Approaching_Crowds_Dim_OneSide(menge::crowd, geometrie::geometry, w_c, x_min_dim, x_max_dim, N_dim::Int, system_size)

    N = length(menge.agent)
    N1 = Int(round(N/2))
    N2 = Int(round(N_dim/2))

    if ρ_global(N1, (w_c, system_size[2])) > 7.5
        println("The density is too high!")
    elseif ρ_global(length(menge.agent) - N1, (w_c, system_size[2])) > 7.5
        println("The density is too high!")
    else

        #assign normal agents on the left
        Random_Pos_In_Rectangle((0.0, 0.0), (w_c, system_size[2]), 1, N1-N2, menge, (1, 0), system_size, geometrie)

        #assign normal agents on the right
        Random_Pos_In_Rectangle((system_size[1]-w_c, 0.0), (system_size[1],system_size[2]), N1-N2+1, N-N_dim, menge, (-1, 0), system_size, geometrie)

        #assign dim agents on the left
        Random_Pos_In_Rectangle((x_min_dim, 0.0), (x_max_dim, system_size[2]), N-N_dim+1, N, menge, (1, 0), system_size, geometrie)

    end
end

;
