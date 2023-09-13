Score(a::agent, menge::crowd, geometrie::geometry, system_size) =  a.α*IN(a, menge, geometrie, system_size)+a.β*abs(a.vel .*a.heading .- a.e_pref .* a.v_pref)^2

function Calc_Heading_Velocity(a::agent, menge::crowd, geometrie::geometry, system_size)

    if Preferred_Velocity_Optmial(a, menge, geometrie, system_size) == true

        a.e_pref, a.v_pref

    else

        Argmin_CostFunction(a, menge, geometrie, system_size)

    end

end

function Preferred_Velocity_Optmial(a::agent, menge::crowd, geometrie::geometry, system_size)

    #take v_pref as optimal if no one else is in in Radius of 3*R_soc
    if Min_R(a, menge, geometrie, system_size) > 3*a.r
        true
    else

        false
    end
end
