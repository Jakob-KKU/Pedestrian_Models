function Calc_Temp_Headings_and_Velocities!(menge::crowd, geometrie::geometry, temp_headings, temp_velocities,
        system_size::NTuple{2, Float64}, dt)

    for (i,x) in enumerate(menge.agent)

            if step!(x, dt) == true
                    temp_headings[i], temp_velocities[i]  =
                     Calc_Heading_Velocity(x, menge, geometrie, system_size)
            end
    end
end

function step!(a::agent, dt)

    if a.step <= dt
        a.step = a.dt_step
        true
    else
        a.step += -dt
        false
    end
end
