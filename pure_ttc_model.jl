function Heading_From_TTC(a::agent, b::agent, system_size::NTuple{2, Float64})

    a_heading_p = a.desired_heading
    Δϕ_p = 0.0

    while ttc(a, b, a_heading_p, system_size) < a.T

        a_heading_p = normalize(R(0.1)⋅a_heading_p)
        Δϕ_p += 0.1

        if Δϕ_p >= pi
            break
        end
    end

    a_heading_m = a.desired_heading
    Δϕ_m = 0.0

    while ttc(a, b, a_heading_m, system_size) < a.T

        a_heading_m = R(-0.1)⋅a_heading_m
        Δϕ_m -= 0.1

        if Δϕ_m <= -pi
            break
        end
    end

    if abs(Δϕ_m) > Δϕ_p
        a_heading_p,Δϕ_p
    else
        a_heading_m,Δϕ_m
    end
end

function Heading_From_TTC(a::agent, b::element, system_size::NTuple{2, Float64})

    a_heading_p = a.desired_heading
    Δϕ_p = 0.0

    while ttc(a, b, a_heading_p, system_size) < a.T

        a_heading_p = normalize(R(0.1)a_heading_p)
        Δϕ_p += 0.1
    end

    a_heading_m = a.desired_heading
    Δϕ_m = 0.0

    while ttc(a, b, a_heading_m, system_size) < a.T

        a_heading_m = R(-0.1)⋅a_heading_m
        Δϕ_m -= 0.1

        if Δϕ_m <= -pi
            break
        end
    end

    if abs(Δϕ_m) > Δϕ_p
        a_heading_p,Δϕ_p
    else
        a_heading_m,Δϕ_m
    end
end


function Min_TTC_Agents(a::agent, menge::crowd, system_size::NTuple{2, Float64})

    index = 0
    ttc_min = 999.0

    for i in 2:a.neighbors_agents[1]+1

        ttc_help = ttc(a, menge.agent[a.neighbors_agents[i]], system_size)

        if ttc_help < ttc_min
            ttc_min = min(ttc_help, ttc_min)
            index = a.neighbors_agents[i]
        end
    end

    index, ttc_min
end

function Min_TTC_Geometry(a::agent, geometrie::geometry, system_size::NTuple{2, Float64})

    index = 0
    ttc_min = 999.0

    for i in 2:a.neighbors_geometry[1]+1

        ttc_help = ttc(a, geometry.element[a.neighbors_geometry[i]], system_size)

        if ttc_help < ttc_min
            ttc_min = min(ttc_help, ttc_min)
            index = a.neighbors_geometry[i]
        end
    end

    index, ttc_min
end

function Calc_Heading_TTC(a::agent, menge::crowd, geometrie::geometry, system_size::NTuple{2, Float64})

    i_geo, ttc_geo = Min_TTC_Geometry(a, geometrie, system_size)
    i_ag, ttc_ag = Min_TTC_Agents(a, menge, system_size)
    #println("ttc_geo = ", ttc_geo, " and ttc_ag = ", ttc_ag)
    if ttc_geo > a.T && ttc_ag > a.T

        a.desired_heading, 0.0

    elseif ttc_ag > a.T || ttc_geo < ttc_ag

        Heading_From_TTC(a, geometrie.element[i_geo], system_size)

    else

        Heading_From_TTC(a, menge.agent[i_ag], system_size)

    end
end

function Calc_V_and_Heading(a, menge, geometrie, system_size)

    a_heading, Δϕ = Calc_Heading_TTC(a, menge, geometrie, system_size)
    a_vel = calculate_single_velocity_ttc(a, menge, geometrie, system_size)
    Δv = a.v_max - a_vel
    #println("Δϕ = ", Δϕ, " and Δv = ", Δv)

    if abs(Δϕ) == 0 && Δv == 0
        a.v_max, a.desired_heading
    elseif 0*abs(Δϕ) > Δv
        a_vel, a.heading
    else
        a.vel, a_heading
    end
end

function Calc_Vs_and_Headings!(menge::crowd, geometrie::geometry, temp_velocities, temp_headings,
        system_size::NTuple{2, Float64})

    for (i,x) in enumerate(menge.agent)

         temp_velocities[i], temp_headings[i]  = Calc_V_and_Heading(x, menge, geometrie, system_size)

    end

    temp_velocities, temp_headings

end
