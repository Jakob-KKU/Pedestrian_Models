function Simulate_2nd_Order_HW!(menge::crowd, dt, dt_save, t_sim, t_relax, L)

    gespeicherte_schritte = Int(round((t_sim-t_relax)/dt_save))-1
    N = length(menge.agent)

    Init_Predecessors!(menge)

    positions = Array{Float64, 2}(undef, gespeicherte_schritte, N)
    velocities = Array{Float64, 2}(undef, gespeicherte_schritte, N)

    temp_acc = Array{Float64,1}(undef,N)

    i, j = 0, 1

    while dt * i < t_sim

        Single_Iteration_2nd_Order_HW!(menge, dt, temp_acc, L)

        if i*dt > t_relax && mod(i, Int(round(dt_save/dt))) == 0

            Save_Pos_Vels!(menge, j, positions, velocities)
            j = j + 1

        end

        i = i + 1
    end

    positions, velocities
end

function Single_Iteration_2nd_Order_HW!(menge::crowd, dt::Float64, temp_acc, L)

    #Update_Predecessors!(menge, L)
    dx = Calc_Headways(menge, L)
    Calc_Acc_HW!(menge, dx, temp_acc, L, dt)
    Update_Pos_Vels_Acc_HW!(menge, temp_acc, L, dt)

end


function Calc_Acc_HW!(menge::crowd, dx, temp_acc, L, dt)

    for (i,x) in enumerate(menge.agent)

         temp_acc[i] = Calc_Single_Acc(menge, dx, i, L, dt)

    end
end

function Update_Pos_Vels_Acc_HW!(menge::crowd, temp_acc, L, dt)

    for (i, x) in enumerate(menge.agent)

        x.vel = x.vel + dt * temp_acc[i]
        x.pos = x.pos + dt * x.vel

    end
end

function Calc_Headways(menge, L)

    dx = fill(0.0, length(menge.agent))

    for i in 1:length(menge.agent)-1

        dx[i] = menge.agent[i+1].pos-menge.agent[i].pos

    end

    dx[end] = menge.agent[1].pos + L - menge.agent[end].pos

    dx
end

;
