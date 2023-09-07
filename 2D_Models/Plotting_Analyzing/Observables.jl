L_mean(menge::crowd) = sum([x.l for x in menge.agent])/N_(menge)
L_mean(geometrie::geometry) = sum([x.l for x in geometrie.element])/N_(geometrie)
A_mean(menge::crowd) = L_mean(menge)^2*pi/4
A_mean(geometrie::geometry) = L_mean(geometrie)^2*pi/4
N_(menge::crowd) = length(menge.agent)
N_(geometrie::geometry) = length(geometrie.element)
ρ_global(menge::crowd, system_size::NTuple{2, Float64}, geometrie::geometry) = N_(menge)/(system_size[1]*system_size[2] - N_(geometrie)*A_mean(geometrie))
ρ_global(menge::crowd, system_size::NTuple{2, Float64}) = N_(menge)/(system_size[1]*system_size[2])
ρ_global(N, system_size::NTuple{2, Float64}) = N/(system_size[1]*system_size[2])
ρ_max(system_size, menge) = 0.74/L_mean(menge)^2;


function ρ_Cone(a::agent, menge::crowd, system_size)

    N = a.ϕ/2π

    for i in 2:a.neighbors_agents[1]+1

        if In_Cone(a, menge.agent[a.neighbors_agents[i]], system_size) == true
            N = N + 1.0
        end
    end

    N/A_Cone(a)
end

v(x_t1::NTuple{2, Float64}, x_t2::NTuple{2, Float64}, dt) = abs(x_t1 .- x_t2)/dt
v(x_t1::NTuple{2, Float64}, x_t2::NTuple{2, Float64}, dt, system_size) = d(x_t1, x_t2, system_size)/dt


function v(positions::Matrix{Tuple{Float64, Float64}}, dt, system_size)

    velocities = Array{Float64,2}(undef, size(positions)[1]-1, size(positions)[2])

    for i in 1:size(positions)[1]-1

        for j in 1:size(positions)[2]

            velocities[i, j] = v(positions[i, j], positions[i+1, j], dt, system_size)
        end
    end

    velocities
end
;
