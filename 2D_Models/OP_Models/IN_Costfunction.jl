function Score(a::agent, v, menge::crowd, geometrie::geometry, system_size, dt = 0.01)

    #save current position
    a_pos_temp = a.pos

    #initialize test position x+v*dt
    a.pos = a.pos .+ v .* dt

    #calculate associated INTRUSION
    IN_v = IN(a, menge, geometrie, system_size)

    #reset position
    a.pos = a_pos_temp

    #return Score
    a.α*IN_v+a.β*abs(v .- a.e_pref .* a.v_pref)^2

end

function Calc_Heading_Velocity(a::agent, menge::crowd, geometrie::geometry, system_size)

    if Preferred_Velocity_Optmial(a, menge, geometrie, system_size) == true

        a.e_pref, a.v_pref

    else

        Argmin_CostFunction_RandomSampling(a, menge, geometrie, system_size)

    end

end

function Preferred_Velocity_Optmial(a::agent, menge::crowd, geometrie::geometry, system_size)

    #println(Score(a, a.v_pref .* a.e_pref, menge, geometrie, system_size))
    #take v_pref as optimal if no one else is in in Radius of 3*R_soc
    if Min_R(a, menge, geometrie, system_size) > 3*a.r

        true
    else

        false
    end
end
