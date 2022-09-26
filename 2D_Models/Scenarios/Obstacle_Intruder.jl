function Init_Nth_Agent_as_Moving_Obstacle!(menge, system_size, l, vel)

    menge.agent[end].l = l
    menge.agent[end].pos = (system_size[1], system_size[2]/2)
    menge.agent[end].vel = vel
    menge.agent[end].heading = (-1.0, 0.0)
    menge.agent[end].step = 0.0


end



function Update_Pos_and_Heading!(menge::crowd, temp_headings::Array{NTuple{2, Float64},1},
     temp_velocities::Array{Float64,1}, dt::Float64, system_size::NTuple{2, Float64})

    for (i, x) in enumerate(menge.agent[1:end-1])
        #println("v_pref = ", x.v_pref)

        #println("v_calc = ", temp_velocities[i])
        x.heading = R(x.ζ_h*randn()*sqrt(dt), normalize(x.heading.*(1-dt/x.τ_R).+dt/x.τ_R.*temp_headings[i]))
        x.vel = x.vel*(1-dt/x.τ_R) + dt/x.τ_R * temp_velocities[i] + x.ζ_v*randn()*sqrt(dt)
        #println("v_t = ", x.vel)
        x.pos = mod.(x.pos .+ dt .* x.heading .* x.vel, system_size)
    end

    menge.agent[end].step += dt

    if menge.agent[end].step > 5.0

        menge.agent[end].pos = mod.(menge.agent[end].pos .+ dt .* menge.agent[end].heading .* menge.agent[end].vel, system_size)

    end

end

function Iterate!(menge::crowd, geometrie::geometry, temp_headings::Array{NTuple{2, Float64},1},
        temp_velocities, dt::Float64, r::Float64, system_size::NTuple{2, Float64})

    Update_Neighborhood!(menge, geometrie, system_size, r)

    #if menge.agent[end].step < 5.0
        Update_Pref_Velocities!(menge, geometrie, system_size)
    #else
    #    Update_Pref_Velocities_!(menge, geometrie, system_size)
    #end


    Calc_Temp_Headings_and_Velocities!(menge, geometrie, temp_headings,
     temp_velocities, system_size, dt)

    Update_Pos_and_Heading!(menge, temp_headings, temp_velocities, dt, system_size)

end

function Update_Pref_Velocities_!(menge::crowd, geometrie::geometry, system_size::NTuple{2, Float64})

    for x in menge.agent
        x.e_pref = x.e_des
        x.v_pref = 0.0
    end

end


;
