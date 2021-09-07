function calculate_velocities_distance(menge::crowd, geometrie::geometry, temp_velocities::Array{Float64,1})

    for (i,x) in enumerate(menge.agent)
         temp_velocities[i] = ov(x, minimum_distance_in_front(x, menge, geometrie))
    end

    temp_velocities
end

function calculate_velocities_distance(menge::crowd, geometrie::geometry, temp_velocities::Array{Float64,1}, system_size::NTuple{2, Float64})

    for (i,x) in enumerate(menge.agent)
         temp_velocities[i] = ov(x, minimum_distance_in_front(x, menge, geometrie, system_size))
    end

    temp_velocities
end

ov(a::agent, dist::Float64) = min(a.v_max, max((dist-a.l)/a.T, 0.0))
ov(a::agent, dist::Int64) = min(a.v_max, max((dist-a.l)/a.T, 0.0))
ov(a::agent, b::agent) = min(a.v_max, max((d(a, b)-a.l)/a.T, 0.0))
;
