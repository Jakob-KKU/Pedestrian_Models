function Score(a::agent, v, menge::crowd, geometrie::geometry, system_size)

    #save current position
    a_vel_temp = a.vel
    a_head_temp = a.heading

    #initialize test velocity
    a.vel = abs(v)
    a.heading = normalize(v)

    #calculate associated AVOIDANCE
    AV_v = AV(a, menge, geometrie, system_size)

    #reset position
    a.vel = a_vel_temp
    a.heading = a_head_temp


    #return Score
    AV_v+a.β*abs(v .- a.e_pref .* a.v_pref)^2

end


function Calc_Heading_Velocity(a::agent, menge::crowd, geometrie::geometry, system_size)

    if Preferred_Velocity_Optmial(a, menge, geometrie, system_size) == true

        a.e_pref, a.v_pref

    else

        #Argmin_CostFunction(a, menge, geometrie, system_size)
        Argmin_CostFunction_RandomSampling(a, menge, geometrie, system_size)

    end

end

function Preferred_Velocity_Optmial(a::agent, menge::crowd, geometrie::geometry, system_size)

    if Min_TTC(a, a.v_pref, a.e_pref, menge, geometrie, system_size) >= 2*a.T
        true
    else
        false
    end
end
