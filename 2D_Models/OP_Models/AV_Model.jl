Score(a::agent, menge::crowd, geometrie::geometry, system_size) = AV(a, menge, geometrie, system_size)+a.β*abs(a.vel .*a.heading .- a.e_pref .* a.v_pref)^2

function Calc_Heading_Velocity(a::agent, menge::crowd, geometrie::geometry, system_size)

    if Preferred_Velocity_Optmial(a, menge, geometrie, system_size) == true

        a.e_pref, a.v_pref

    else

        Argmin_CostFunction(a, menge, geometrie, system_size)

    end

end

function Preferred_Velocity_Optmial(a::agent, menge::crowd, geometrie::geometry, system_size)

    if Min_TTC(a, a.v_pref, a.e_pref, menge, geometrie, system_size) >= 2*a.T
        true
    else
        false
    end
end
