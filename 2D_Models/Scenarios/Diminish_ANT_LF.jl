function Calc_Temp_Headings_and_Velocities!(menge::crowd, geometrie::geometry, temp_headings
        , temp_velocities, system_size::NTuple{2, Float64}, dt)

    N_dim = 0

    for (i,x) in enumerate(menge.agent)

        if i in 27-N_dim+1:27
            temp_headings[i], temp_velocities[i]  = Calc_Heading_Velocity_TG(x, menge, geometrie, system_size)
        else
            temp_headings[i], temp_velocities[i]  = Calc_Heading_Velocity(x, menge, geometrie, system_size)
        end
    end

end

#Score_TG(a::agent, a_vel, a_ϕ) = (a.v_max .* a.e_des) ⋅ v(a_vel, a_ϕ)
Score_TG(a::agent, vel, ϕ) = -abs(v(vel, ϕ).-a.v_pref.*a.e_pref)


function Calc_Heading_Velocity_TG(a::agent, menge::crowd, geometrie::geometry, system_size)

    if v_des_possible_TG(a, menge, geometrie, system_size) == true

        a.e_pref, a.v_pref

    else

        find_best_v_TG(a, menge, geometrie, system_size)

    end

end

function v_des_possible_TG(a::agent, menge::crowd, geometrie::geometry, system_size)

    if Min_TimeGap(a, a.v_pref, a.e_pref, menge, geometrie, system_size) >= a.T
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

        #if N_dim >0
        #    for a in menge.agent[N-N_dim+1:end]
        #        #a.T = 0.5
        #    end
        #end
    end
end

function Two_Approaching_Crowds(menge::crowd, geometrie::geometry, system_size, condition)

    N = length(menge.agent)

    if N != 54

        println("N has to be 54!")

    else


        if condition == "BaseLine"

            Assign_BL!(menge, system_size)

        elseif condition == "Front"

            Assign_Front!(menge, system_size)

        end
    end


end


function Assign_BL!(menge, system_size)

    r = 0.5
    r2 = 1.0

    for i in 0:8

        ind = i*3

        menge.agent[ind+1].pos = (1.5*i+r2*rand(), system_size[2]/4+r*rand())
        menge.agent[ind+2].pos = (1.5*i+r2*rand(), 2*system_size[2]/4+r*rand())
        menge.agent[ind+3].pos = (1.5*i+r2*rand(), 3*system_size[2]/4+r*rand())

        menge.agent[27+ind+1].pos = (26+1.5*i+r2*rand(), system_size[2]/4+r*rand())
        menge.agent[27+ind+2].pos = (26+1.5*i+r2*rand(), 2*system_size[2]/4+r*rand())
        menge.agent[27+ind+3].pos = (26+1.5*i+r*rand(), 3*system_size[2]/4+r*rand())

    end

    for i in 1:27
        menge.agent[i].e_des, menge.agent[i].heading = (1.0, 0.0), (1.0, 0.0)
        menge.agent[i].vel = 1.0
    end

    for i in 28:N
        menge.agent[i].e_des, menge.agent[i].heading = (-1.0, 0.0), (-1.0, 0.0)
        menge.agent[i].vel = -1.0
    end

end

function Assign_Front!(menge, system_size)

    for i in 0:7

        ind = i*3

        menge.agent[ind+1].pos = (1.5*i+0.0, system_size[2]/4+rand())
        menge.agent[ind+2].pos = (1.5*i+0.0, 2*system_size[2]/4+rand()*0.1)
        menge.agent[ind+3].pos = (1.5*i+0.0, 3*system_size[2]/4+rand()*0.1)

        menge.agent[27+ind+1].pos = (26+1.5*i, system_size[2]/4+rand()*0.1)
        menge.agent[27+ind+2].pos = (26+1.5*i, 2*system_size[2]/4+rand()*0.1)
        menge.agent[27+ind+3].pos = (26+1.5*i, 3*system_size[2]/4+rand()*0.1)

    end


    for i in 1:27
        menge.agent[i].e_des, menge.agent[i].heading = (1.0, 0.0), (1.0, 0.0)
        menge.agent[i].vel = 1.0
    end

    for i in 28:N
        menge.agent[i].e_des, menge.agent[i].heading = (-1.0, 0.0), (-1.0, 0.0)
        menge.agent[i].vel = -1.0
    end

end

function Init_Mobile_Users!(menge::crowd, v_max, T, dia, N_dim)

    for a in menge.agent[27-N_dim+1:27]

        a.v_max = v_max
        a.T = T
        #a.l = dia

    end

end

;
