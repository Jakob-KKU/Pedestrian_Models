function Simulate!(menge::crowd, dt, dt_save, t_sim, t_relax, L)

    gespeicherte_schritte = Int(round((t_sim-t_relax)/dt_save))-1
    N = length(menge.agent)

    Init_Predecessors!(menge, L)

    positions = Array{Float64, 2}(undef, gespeicherte_schritte, N)
    velocities = Array{Float64, 2}(undef, gespeicherte_schritte, N)

    temp_velocities = Array{Float64,1}(undef,N)

    i, j = 0, 1

    while dt * i < t_sim

        Single_Iteration!(menge, dt, temp_velocities, L)

        if i*dt > t_relax && mod(i, Int(round(dt_save/dt))) == 0

            Save_Pos_Vels!(menge, j, positions, velocities)
            j = j + 1

        end

        i = i + 1
    end

    positions, velocities
end

function Single_Iteration!(menge::crowd, dt::Float64, temp_velocities, L)

    Update_Predecessors!(menge, L)
    Calc_Velocities!(menge, temp_velocities, L, dt)
    Update_Pos_Vels!(menge, temp_velocities, L, dt)

end


function Save_Pos_Vels!(menge::crowd, j::Int64, positions, velocities)

    for k in 1:length(menge.agent)
        positions[j, k] = menge.agent[k].pos
        velocities[j, k]  = menge.agent[k].vel
    end
end


function Calc_Velocities!(menge::crowd, temp_velocities, L, dt)

    for (i,x) in enumerate(menge.agent)

         temp_velocities[i] = Calc_Single_Velocity(menge, i, L, dt)

    end
end

function Update_Pos_Vels!(menge::crowd, temp_velocities, L, dt)

    for (i, x) in enumerate(menge.agent)

        x.vel = temp_velocities[i]
        x.pos = mod(x.pos + dt * x.vel, L)

    end
end
;
