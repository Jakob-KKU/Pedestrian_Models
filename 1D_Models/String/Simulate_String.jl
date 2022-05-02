function Simulate_2nd_Order_String!(menge::crowd, dt, dt_save, t_sim, t_relax)

    gespeicherte_schritte = Int(round((t_sim-t_relax)/dt_save))-1
    N = length(menge.agent)

    Init_Predecessors!(menge)

    positions = Array{Float64, 2}(undef, gespeicherte_schritte, N)
    velocities = Array{Float64, 2}(undef, gespeicherte_schritte, N)
    acc = Array{Float64, 2}(undef, gespeicherte_schritte, N)


    temp_acc = Array{Float64,1}(undef,N)

    i, j = 0, 1

    while dt * i < t_sim

        Single_Iteration_2nd_Order_String!(menge, dt*i, dt, temp_acc)

        if i*dt > t_relax && mod(i, Int(round(dt_save/dt))) == 0

            Save!(menge, temp_acc, j, positions, velocities, acc)
            j = j + 1

        end

        i = i + 1
    end

    positions, velocities, acc
end

function Single_Iteration_2nd_Order_String!(menge::crowd, t, dt::Float64, temp_acc)

    #Update_Predecessors!(menge, L)
    Calc_Acc_String!(menge, t, temp_acc, dt)
    Update_Pos_Vels_Acc_String!(menge, temp_acc, dt)

end


function Calc_Acc_String!(menge::crowd, t, temp_acc, dt)

    temp_acc[end] = Calc_Leader_Acc(menge, t, dt)

    for (i,x) in enumerate(menge.agent[1:end-1])

         temp_acc[i] = Calc_Single_Acc(menge, i, 100.0, dt)

    end
end

function Update_Pos_Vels_Acc_String!(menge::crowd, temp_acc, dt)

    for (i, x) in enumerate(menge.agent)

        x.vel = x.vel + dt * temp_acc[i]
        x.pos = x.pos + dt * x.vel

    end
end


function Calc_Leader_Acc(menge, t, dt)

    T_a = 2.0
    a = 0.2/T_a

    if t < 1*T_a
        0
    elseif t < 2*T_a
        -a
    elseif t < 3*T_a
        +a
    else
        0
    end

end

function Save!(menge::crowd, temp_acc, j::Int, positions, velocities, acc)

    for k in 1:length(menge.agent)
        positions[j, k] = menge.agent[k].pos
        velocities[j, k]  = menge.agent[k].vel
        acc[j, k]  = temp_acc[k]
    end

end

function Overdamped_(dx_t, Δx)

    y = 0

    for x in dx_t

        if round(x, digits=10) > Δx
            y = 1
            break
        end

    end

    y

end
;
