### the functions to calculate the ttc are defined ###

#simple ttc between two agents a and b
function ttc(a::agent, b::agent)

    cos_α = e_(a, b)⋅e_v(a, b)
    A = ((cos_α)^2-1)*d(a,b)^2+l(a, b)^2

    if d(a,b) < l(a, b)
        0.0
    elseif A < 0.0 || -(cos_α)*d(a,b)-sqrt(A) < 0.0 || abs(Δv(a,b)) == 0
        999.9
    else
        (-(cos_α)*d(a,b)-sqrt(A))/abs(Δv(a,b))
    end
end

function ttc(a::agent, b::agent, v_a::Float64)

    cos_α = e_(a, b)⋅e_v(a, b, v_a)
    A = ((cos_α)^2-1)*d(a,b)^2+l(a, b)^2

    if d(a,b) < l(a, b)
        0.0
    elseif A < 0.0 || -(cos_α)*d(a,b)-sqrt(A) < 0.0
        999.9
    else
        (-(cos_α)*d(a,b)-sqrt(A))/abs(Δv(a,b,v_a))
    end
end

function ttc(a::agent, b::agent, v_a::Float64, v_b::Float64)

    cos_α = e_(a, b)⋅e_v(a, b, v_a, v_b)
    A = ((cos_α)^2-1)*d(a,b)^2+l(a, b)^2

    if A < 0 || -(cos_α)*d(a,b)-sqrt(A) < 0.0
        999.9
    else
        (-(cos_α)*d(a,b)-sqrt(A))/abs(Δv(a, b, v_a, v_b))
    end
end

function ttc(a::agent, b::agent, a_heading::NTuple{2, Float64}, a_vel::Float64)

    cos_α = e_(a,b)⋅e_v(a, b, a_heading, a_vel)
    A = (cos_α^2-1)*d(a,b)^2+l(a, b)^2


    if A < 0 || -cos_α*d(a,b)-sqrt(A) < 0 || abs(Δv(a,b, a_heading, a_vel)) == 0
        999.9
    else
        (-cos_α*d(a,b)-sqrt(A))/abs(Δv(a,b, a_heading, a_vel))
    end
end

#simple ttc between two agents a and b in a periodic system
function ttc(a::agent, b::agent, system_size::NTuple{2, Float64})

    cos_α = e_(a,b,system_size)⋅e_v(a, b)
    A = ((cos_α)^2-1)*d(a,b,system_size)^2+l(a, b)^2

    if A < 0 || -(cos_α)*d(a,b,system_size)-sqrt(A) < 0 || abs(Δv(a,b)) == 0
        999.9
    else
        (-(cos_α)*d(a,b,system_size)-sqrt(A))/abs(Δv(a,b))
    end
end

function ttc(a::agent, b::agent, a_heading::NTuple{2, Float64}, system_size::NTuple{2, Float64})

    cos_α = e_(a,b,system_size)⋅e_v(a, b, a_heading)
    A = (cos_α^2-1)*d(a,b,system_size)^2+l(a, b)^2


    if A < 0 || -cos_α*d(a,b,system_size)-sqrt(A) < 0 || abs(Δv(a,b, a_heading)) == 0
        999.9
    else
        (-cos_α*d(a,b,system_size)-sqrt(A))/abs(Δv(a,b, a_heading))
    end
end

function ttc(a::agent, b::agent, v_a::Float64, system_size::NTuple{2, Float64})

    cos_α = e_(a, b, system_size)⋅e_v(a, b, v_a)
    A = ((cos_α)^2-1)*d(a,b,system_size)^2+l(a, b)^2

    if A < 0 || -(cos_α)*d(a,b,system_size)-sqrt(A) < 0
        999
    else
        (-(cos_α)*d(a,b,system_size)-sqrt(A))/abs(Δv(a,b,v_a))
    end
end

function ttc(a::agent, b::agent, a_heading::NTuple{2, Float64}, a_vel::Float64, system_size::NTuple{2, Float64})

    cos_α = e_(a,b,system_size)⋅e_v(a, b, a_heading, a_vel)
    A = (cos_α^2-1)*d(a,b,system_size)^2+l(a, b)^2

    if A < 0 || -cos_α*d(a,b,system_size)-sqrt(A) < 0 || abs(Δv(a,b, a_heading, a_vel)) == 0
        999.9
    else
        (-cos_α*d(a,b,system_size)-sqrt(A))/abs(Δv(a,b, a_heading, a_vel))
    end
end

function ttc(a::agent, b::agent, a_heading::NTuple{2, Float64}, a_vel::Float64, dia_effective, system_size::NTuple{2, Float64})

    cos_α = e_(a,b,system_size)⋅e_v(a, b, a_heading, a_vel)
    A = (cos_α^2-1)*d(a,b,system_size)^2+dia_effective^2

    if A < 0 || -cos_α*d(a,b,system_size)-sqrt(A) < 0 || abs(Δv(a,b, a_heading, a_vel)) == 0
        999.9
    else
        (-cos_α*d(a,b,system_size)-sqrt(A))/abs(Δv(a, b, a_heading, a_vel))
    end
end

function ttc(a::agent, b::agent, v_a::Float64, v_b::Float64,  system_size::NTuple{2, Float64})

    cos_α = e_(a, b, system_size)⋅e_v(a, b, v_a, v_b)
    A = ((cos_α)^2-1)*d(a,b,system_size)^2+l(a, b)^2

    if A < 0 || -(cos_α)*d(a,b,system_size)-sqrt(A) < 0
        999
    else
        (-(cos_α)*d(a,b,system_size)-sqrt(A))/abs(Δv(a,b,v_a, v_b))
    end
end


#simple ttc between agent a and geometry element b

function ttc(a::agent, b::element)

    cos_α = e_(a, b)⋅a.heading
    A = (cos_α^2-1)*d(a,b)^2+l(a,b)^2

    if  A < 0 || (-cos_α*d(a,b) - sqrt(A)) < 0
        return 999
    else
        return (-cos_α*d(a,b) - sqrt(A))/a.vel
    end
end

function ttc(a::agent, b::element, v_a::Float64)


    cos_α = e_(a, b)⋅a.heading
    A = (cos_α^2-1)*d(a,b)^2+l(a,b)^2

    if  A < 0 || (-cos_α*d(a,b) - sqrt(A)) < 0
        return 999
    else
        return (-cos_α*d(a,b) - sqrt(A))/v_a
    end
end


#simple ttc between agent a and geometry element b in a periodic system
function ttc(a::agent, b::element, system_size::NTuple{2, Float64})

    cos_α = e_(a, b, system_size)⋅a.heading
    A = (cos_α^2-1)*d(a,b,system_size)^2+l(a,b)^2

    if  A < 0 || (-cos_α*d(a,b,system_size) - sqrt(A)) < 0
        return 999
    else
        return (-cos_α*d(a,b,system_size) - sqrt(A))/a.vel
    end
end

function ttc(a::agent, b::element, a_heading::NTuple{2, Float64}, system_size::NTuple{2, Float64})

    cos_α = e_(a,b,system_size)⋅v(a, a_heading)
    A = ((cos_α)^2-1)*d(a,b,system_size)^2+l(a, b)^2

    if A < 0 || -(cos_α)*d(a,b,system_size)-sqrt(A) < 0
        999.9
    else

        (-(cos_α)*d(a,b,system_size)-sqrt(A))/a.vel
    end
end

function ttc(a::agent, b::element, v_a::Float64, system_size::NTuple{2, Float64})

    cos_α = e_(a, b ,system_size)⋅a.heading
    A = (cos_α^2-1)*d(a,b,system_size)^2+l(a,b)^2

    if  A < 0 || (-cos_α*d(a,b,system_size) - sqrt(A)) < 0
        return 999
    else
        return (-cos_α*d(a,b,system_size) - sqrt(A))/v_a
    end
end

function ttc(a::agent, b::element, a_heading::NTuple{2, Float64}, a_vel::Float64, system_size::NTuple{2, Float64})

    cos_α = e_(a,b,system_size)⋅a_heading
    A = ((cos_α)^2-1)*d(a,b,system_size)^2+l(a, b)^2

    if A < 0 || -(cos_α)*d(a,b,system_size)-sqrt(A) < 0
        999.9
    else

        (-(cos_α)*d(a,b,system_size)-sqrt(A))/a_vel
    end
end

#calculates the minimal TTC with different Variables

function Min_TTC(a::agent, menge::crowd, geometrie::geometry, system_size::NTuple{2, Float64})

    ttc_geo = Min_TTC_Geometry(a, geometrie, system_size)
    ttc_agents = Min_TTC_Agents(a, menge, system_size)

    min(ttc_geo, ttc_agents)

end

function Min_TTC(a::agent, a_heading::NTuple{2, Float64}, menge::crowd, geometrie::geometry, system_size::NTuple{2, Float64})

    ttc_geo = Min_TTC_Geometry(a, a_heading, geometrie, system_size)
    ttc_agents = Min_TTC_Agents(a, a_heading, menge, system_size)

    min(ttc_geo, ttc_agents)
end

function Min_TTC(a::agent, a_vel::Float64, a_heading::NTuple{2, Float64}, menge::crowd, geometrie::geometry,
        system_size::NTuple{2, Float64})

    ttc_geo = Min_TTC_Geometry(a, a_vel, a_heading, geometrie, system_size)
    ttc_agents = Min_TTC_Agents(a, a_vel, a_heading, menge, system_size)

    min(ttc_geo, ttc_agents)

end

function Min_TTC(a::agent, a_vel::Float64, a_heading::NTuple{2, Float64}, r_soc::Float64, menge::crowd, geometrie::geometry,
        system_size::NTuple{2, Float64})

    ttc_geo = Min_TTC_Geometry(a, a_vel, a_heading, geometrie, system_size)
    ttc_agents = Min_TTC_Agents(a, a_vel, a_heading, r_soc, menge, system_size)

    min(ttc_geo, ttc_agents)

end

#calculates the minimal TTC with the other Agents with different Variables

    function Min_TTC_Agents(a::agent, menge::crowd, system_size::NTuple{2, Float64})

        ttc_min = 999.0

        for i in 2:a.neighbors_agents[1]+1

            ttc_help = ttc(a, menge.agent[a.neighbors_agents[i]], system_size)
            ttc_min = min(ttc_help, ttc_min)
        end
        ttc_min
    end

function Min_TTC_Agents(a::agent, a_heading::NTuple{2, Float64}, menge::crowd, system_size::NTuple{2, Float64})

    ttc_min = 999.0

    for i in 2:a.neighbors_agents[1]+1

        ttc_help = ttc(a, menge.agent[a.neighbors_agents[i]], a_heading, system_size)

        ttc_min = min(ttc_help, ttc_min)
    end

    ttc_min
end

function Min_TTC_Agents(a::agent, a_vel::Float64, a_heading::NTuple{2, Float64}, menge::crowd,
        system_size::NTuple{2, Float64})

    ttc_min = 999.0

    for i in 2:a.neighbors_agents[1]+1

        ttc_help = ttc(a, menge.agent[a.neighbors_agents[i]], a_heading, a_vel, system_size)

        ttc_min = min(ttc_help, ttc_min)

    end

    ttc_min
end

function Min_TTC_Agents(a::agent, a_vel::Float64, a_heading::NTuple{2, Float64}, r_soc, menge::crowd,
        system_size::NTuple{2, Float64})

    ttc_min = 999.0

    for i in 2:a.neighbors_agents[1]+1

        #the other agent
        b = menge.agent[a.neighbors_agents[i]]

        #the social diameter
        dia_effective = 2*min(r_soc, d(a, b, system_size)/4)




        ttc_help = ttc(a, b, a_heading, a_vel, dia_effective, system_size)

        ttc_min = min(ttc_help, ttc_min)
    end

    ttc_min
end

#calculates the minimal TTC with the Geometry with different Variables

function Min_TTC_Geometry(a::agent, geometrie::geometry, system_size::NTuple{2, Float64})

    ttc_min = 999.0

    for i in 2:a.neighbors_geometry[1]+1

        ttc_help = ttc(a, geometrie.element[a.neighbors_geometry[i]], system_size)

        ttc_min = min(ttc_help, ttc_min)
    end
    ttc_min
end

function Min_TTC_Geometry(a::agent, a_heading::NTuple{2, Float64}, geometrie::geometry, system_size::NTuple{2, Float64})

    ttc_min = 999.0

    for i in 2:a.neighbors_geometry[1]+1

        ttc_help = ttc(a, geometrie.element[a.neighbors_geometry[i]], a_heading, system_size)

        ttc_min = min(ttc_help, ttc_min)
    end
    ttc_min
end

function Min_TTC_Geometry(a::agent, a_vel::Float64, a_heading::NTuple{2, Float64}, geometrie::geometry,
        system_size::NTuple{2, Float64})

    ttc_min = 999.0

    for i in 2:a.neighbors_geometry[1]+1

        ttc_help = ttc(a, geometrie.element[a.neighbors_geometry[i]], a_heading, a_vel, system_size)

        ttc_min = min(ttc_help, ttc_min)
    end
    ttc_min
end

;
