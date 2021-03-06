###### check the first inequalitiy #####
function ov_ttc_cond_1(a::agent, b::agent)

    if a.heading ⋅ e_(a, b) == 0.0
        (0.0, 0.0)
    elseif a.heading ⋅ e_(a, b) > 0.0
        (b.vel * (b.heading ⋅ e_(a, b))/(a.heading ⋅ e_(a, b)), 999.0)
    else
        (0.0, b.vel * (b.heading ⋅ e_(a, b))/(a.heading ⋅ e_(a, b)))
    end
end

function ov_ttc_cond_2(a::agent, b::agent)

    x = (1-(l(a, b)/d(a, b))^2)

    A = (e_(a, b) ⋅ a.heading)^2-x
    B = (a.heading ⋅ b.heading)*x-(e_(a, b) ⋅ a.heading)*(e_(a, b) ⋅ b.heading)
    C = x -(e_(a, b) ⋅ b.heading)^2

    if A == 0.0

        if B > 0.0
            return (0.0, C/(2*B)*b.vel), false
        else
            return (C/(2*B)*b.vel, 999.0), false
        end

    elseif C/A+(B/A)^2 < 0.0
        # not sure about this though!
        return (0.0, 0.0), false

    elseif A > 0.0
        return (b.vel*(-B/A-sqrt(C/A+(B/A)^2)),
         b.vel*(-B/A+sqrt(C/A+(B/A)^2))), false
    else
        return (0.0, b.vel*(-B/A-sqrt(C/A+(B/A)^2))),
         (b.vel*(-B/A+sqrt(C/A+(B/A)^2)), 999.0)
    end

end

function ov_ttc_cond_3(a::agent, b::agent)

    A = d(a, b)/a.T*(a.heading ⋅ e_(a, b))-(a.heading ⋅ v(b))
    B = (l(a, b)^2 - d(a, b)^2)/a.T^2
    C = -b.vel^2+2*d(a, b)/a.T*(v(b) ⋅ e_(a, b))

    if A^2+C+B<0.0
        (0.0, 0.0), false
    else
        v_max_1 = 999.0
        v_1, v_2 = -A+sqrt(A^2+C+B), -A-sqrt(A^2+C+B)

        if abs(ttc(a,b,v_1) - a.T)>0.001
            v_1 = 0.0
            v_max_1 = 0.0
        end

        if abs(ttc(a,b,v_2) - a.T)>0.001
            v_2 = 0.0
        end

        (0.0, v_2), (v_1, v_max_1)
    end

end

function calculate_velocities_ttc(menge::crowd, geometrie::geometry, temp_velocities)

    for (i,x) in enumerate(menge.agent)

         temp_velocities[i] = calculate_single_velocity_ttc(x, menge, geometrie)

    end

    return temp_velocities

end


function calculate_single_velocity_ttc(a::agent, menge::crowd, geometrie::geometry)

    if a.neighbors_agents[1] == 0 && a.neighbors_geometry[1] == 0

        a.v_max

    elseif a.neighbors_agents[1] == 0

        ov(a, minimum_distance_in_front(a, geometrie))

    elseif a.neighbors_geometry[1] == 0

        minimal_v_ttc(a, menge)

    else

        min(minimal_v_ttc(a, menge), ov(a, minimum_distance_in_front(a, geometrie)))

    end
end

function ov_ttc(a::agent, b::agent)

    ### check first condition ###
    v_max_1 = maximum(ov_ttc_cond_1(a, b) ∩ (0.0, a.v_max))

    ### check third condition
    interval_3, interval_4 = ov_ttc_cond_3(a, b)

    if interval_4 != false
        v_max_4 = maximum(interval_3 ∩ (0.0, a.v_max))
        v_max_5 = maximum(interval_4 ∩ (0.0, a.v_max))
    else
        v_max_4, v_max_5 = 0.0, 0.0
    end

    ### check second condition ###
    interval_1, interval_2 = ov_ttc_cond_2(a, b)

    if interval_4 != false
        if interval_2 == false

            v_max_2 =maximum(interval_1 ∩ (0.0, a.v_max))
            v_max_3 =0.0
        else

            v_max_2 =maximum(interval_1 ∩ (0.0, a.v_max))
            v_max_3 =maximum(interval_2 ∩ (0.0, a.v_max))
        end

    elseif (interval_2 == false && ttc(a, b, sum(interval_1)/2) > a.T) ||
          ttc(a, b, (interval_1[2]+interval_2[1])/2) > a.T

        v_max_3, v_max_2 = a.v_max, a.v_max
    else

        if interval_2 == false

            v_max_2 =maximum(interval_1 ∩ (0.0, a.v_max))
            v_max_3 =0.0
        else

            v_max_2 =maximum(interval_1 ∩ (0.0, a.v_max))
            v_max_3 =maximum(interval_2 ∩ (0.0, a.v_max))
        end
    end

    max(v_max_1, v_max_2, v_max_3, v_max_4, v_max_5)
end


function minimal_v_ttc(a::agent, menge::crowd)

    v = 999.9

    for x in 2:a.neighbors_agents[1]+1

        v = min(v, ov_ttc(a, menge.agent[a.neighbors_agents[x]]))

    end

    v
end


### with periodic boundaries ###

###### check the first inequalitiy #####
function ov_ttc_cond_1(a::agent, b::agent, system_size::NTuple{2, Float64})

    if a.heading ⋅ e_(a, b, system_size) == 0.0
        (0.0, 0.0)
    elseif a.heading ⋅ e_(a, b, system_size) > 0.0
        (b.vel * (b.heading ⋅ e_(a, b, system_size))/(a.heading ⋅ e_(a, b, system_size)), 999.0)
    else
        (0.0, b.vel * (b.heading ⋅ e_(a, b, system_size))/(a.heading ⋅ e_(a, b, system_size)))
    end
end

function ov_ttc_cond_2(a::agent, b::agent, system_size::NTuple{2, Float64})

    x = (1-(l(a, b)/d(a, b, system_size))^2)

    A = (e_(a, b, system_size) ⋅ a.heading)^2-x
    B = (a.heading ⋅ b.heading)*x-(e_(a, b, system_size) ⋅ a.heading)*(e_(a, b, system_size) ⋅ b.heading)
    C = x -(e_(a, b, system_size) ⋅ b.heading)^2

    if A == 0.0

        if B > 0.0
            return (0.0, C/(2*B)*b.vel), false
        else
            return (C/(2*B)*b.vel, 999.0), false
        end

    elseif C/A+(B/A)^2 < 0.0
        # not sure about this though!
        return (0.0, 0.0), false

    elseif A > 0.0
        return (b.vel*(-B/A-sqrt(C/A+(B/A)^2)),
         b.vel*(-B/A+sqrt(C/A+(B/A)^2))), false
    else
        return (0.0, b.vel*(-B/A-sqrt(C/A+(B/A)^2))),
         (b.vel*(-B/A+sqrt(C/A+(B/A)^2)), 999.0)
    end

end

function ov_ttc_cond_3(a::agent, b::agent, system_size::NTuple{2, Float64})

    A = d(a, b, system_size)/a.T*(a.heading ⋅ e_(a, b, system_size))-(a.heading ⋅ v(b))
    B = (l(a, b)^2 - d(a, b, system_size)^2)/a.T^2
    C = -b.vel^2+2*d(a, b, system_size)/a.T*(v(b) ⋅ e_(a, b, system_size))

    if A^2+C+B<0.0
        (0.0, 0.0), false
    else
        v_max_1 = 999.0
        v_1, v_2 = -A+sqrt(A^2+C+B), -A-sqrt(A^2+C+B)

        if abs(ttc(a,b,v_1,system_size) - a.T)>0.001
            v_1 = 0.0
            v_max_1 = 0.0
        end

        if abs(ttc(a,b,v_2,system_size) - a.T)>0.001
            v_2 = 0.0
        end

        (0.0, v_2), (v_1, v_max_1)
    end

end

function calculate_velocities_ttc(menge::crowd, geometrie::geometry, temp_velocities,
        system_size::NTuple{2, Float64})

    for (i,x) in enumerate(menge.agent)

         temp_velocities[i] = calculate_single_velocity_ttc(x, menge, geometrie, system_size)

    end

    return temp_velocities

end


function calculate_single_velocity_ttc(a::agent, menge::crowd, geometrie::geometry,
        system_size::NTuple{2, Float64})

    if a.neighbors_agents[1] == 0 && a.neighbors_geometry[1] == 0

        a.v_max

    elseif a.neighbors_agents[1] == 0

        ov(a, minimum_distance_in_front(a, geometrie, system_size))

    elseif a.neighbors_geometry[1] == 0

        minimal_v_ttc(a, menge, system_size)

    else

        min(minimal_v_ttc(a, menge, system_size), ov(a, minimum_distance_in_front(a, geometrie, system_size)))

    end
end

function ov_ttc(a::agent, b::agent, system_size::NTuple{2, Float64})

    ### check first condition ###
    v_max_1 = maximum(ov_ttc_cond_1(a, b, system_size) ∩ (0.0, a.v_max))

    ### check third condition
    interval_3, interval_4 = ov_ttc_cond_3(a, b, system_size)

    if interval_4 != false
        v_max_4 = maximum(interval_3 ∩ (0.0, a.v_max))
        v_max_5 = maximum(interval_4 ∩ (0.0, a.v_max))
    else
        v_max_4, v_max_5 = 0.0, 0.0
    end

    ### check second condition ###
    interval_1, interval_2 = ov_ttc_cond_2(a, b, system_size)

    if interval_4 != false
        if interval_2 == false

            v_max_2 =maximum(interval_1 ∩ (0.0, a.v_max))
            v_max_3 =0.0
        else

            v_max_2 =maximum(interval_1 ∩ (0.0, a.v_max))
            v_max_3 =maximum(interval_2 ∩ (0.0, a.v_max))
        end

    elseif (interval_2 == false && ttc(a, b, sum(interval_1)/2, system_size) > a.T) ||
          ttc(a, b, (interval_1[2]+interval_2[1])/2, system_size) > a.T

        v_max_3, v_max_2 = a.v_max, a.v_max
    else

        if interval_2 == false

            v_max_2 =maximum(interval_1 ∩ (0.0, a.v_max))
            v_max_3 =0.0
        else

            v_max_2 =maximum(interval_1 ∩ (0.0, a.v_max))
            v_max_3 =maximum(interval_2 ∩ (0.0, a.v_max))
        end
    end

    max(v_max_1, v_max_2, v_max_3, v_max_4, v_max_5)
end


function minimal_v_ttc(a::agent, menge::crowd, system_size::NTuple{2, Float64})

    v = 999.9

    for x in 2:a.neighbors_agents[1]+1

        v = min(v, ov_ttc(a, menge.agent[a.neighbors_agents[x]], system_size))

    end

    v
end
