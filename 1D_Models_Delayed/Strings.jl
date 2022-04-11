function Simulate_String!(menge::crowd, dt, dt_save, t_sim)

    gespeicherte_schritte = Int(round((t_sim)/dt_save))
    N = length(menge.agent)

    Init_Predecessors!(menge)

    positions = Array{Float64, 2}(undef, gespeicherte_schritte, N)
    velocities = Array{Float64, 2}(undef, gespeicherte_schritte, N)

    temp_velocities = Array{Float64,1}(undef,N)

    i, j = 0, 1

    while dt * i < t_sim

        Single_Iteration_String!(menge, dt * i, dt, temp_velocities)

        if mod(i, Int(round(dt_save/dt))) == 0

            Save_Pos_Vels!(menge, j, positions, velocities)
            j = j + 1

        end

        i = i + 1
    end

    positions, velocities
end




function Single_Iteration_String!(menge::crowd, t::Float64, dt, temp_velocities)

    #Update_Predecessors!(menge, L)

    Calc_Velocities_String!(menge, temp_velocities, dt, t)

    Update_Pos_Vels_String!(menge, temp_velocities, dt)

    Update_Histories!(menge, t)


end


function Calc_Velocities_String!(menge::crowd, temp_velocities, dt, t)

    temp_velocities[end] = Calc_Leader_Velocity(menge.agent[end], dt, t)


    for (i,x) in enumerate(menge.agent[1:end-1])

         temp_velocities[i] = Calc_Single_Velocity(menge, i, 100.0, t)

    end
end

function Update_Pos_Vels_String!(menge::crowd, temp_velocities, dt)

    for (i, x) in enumerate(menge.agent)

        x.vel = temp_velocities[i]
        x.pos = x.pos + dt * x.vel

    end
end



function Calc_Leader_Velocity(a::agent, dt, t)

    T_a = 1.0
    acc = a.vel/T_a

    if t < T_a
        a.vel
    elseif t < 2*T_a
        a.vel-dt*acc
    elseif t <= 3*T_a
        a.vel+dt*acc
    else
        a.vel
    end

end

#to check for overdamping!
function Simulate_String_OD!(menge::crowd, dt, t_sim)

    N = length(menge.agent)

    Init_Predecessors!(menge)



    temp_velocities = Array{Float64,1}(undef,N)

    i= 0

    while dt * i < t_sim

        Single_Iteration_String!(menge, dt * i, dt, temp_velocities)


        if round(menge.agent[1].vel - (1.0-menge.agent[1].l)/menge.agent[1].T, digits = 10) > 0.0000000001
        #if menge.agent[1].vel < 0.0
            return false

            break
       end

        i = i + 1
    end

    return true

end



;
