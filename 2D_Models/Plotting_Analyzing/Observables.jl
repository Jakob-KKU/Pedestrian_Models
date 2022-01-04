L_mean(menge::crowd) = sum([x.l for x in menge.agent])/N_(menge)
L_mean(geometrie::geometry) = sum([x.l for x in geometrie.element])/N_(geometrie)
A_mean(menge::crowd) = L_mean(menge)^2*pi/4
A_mean(geometrie::geometry) = L_mean(geometrie)^2*pi/4
N_(menge::crowd) = length(menge.agent)
N_(geometrie::geometry) = length(geometrie.element)

ρ_global(menge::crowd, system_size::NTuple{2, Float64}, geometrie::geometry) = N_(menge)/(system_size[1]*system_size[2] - N_(geometrie)*A_mean(geometrie))
ρ_global(menge::crowd, system_size::NTuple{2, Float64}) = N_(menge)/(system_size[1]*system_size[2])
ρ_global(N, system_size::NTuple{2, Float64}) = N/(system_size[1]*system_size[2])

ρ_max(system_size, menge) = 0.74/L_mean(menge)^2

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

function st_dev(matrix)

    varianz, mean = 0, mean(matrix)

    for x in matrix
        varianz = varianz + (mean-x)^2
    end

    return sqrt(varianz)/length(matrix)^2
end

function st_dev(matrix, mean)

    varianz = 0



    for x in matrix
        varianz = varianz + (mean-x)^2
    end

    return sqrt(varianz)/length(matrix)^2
end

function calc_ttc_timeseries(positions, headings, geometrie, dt, system_size)

    velocities = v(positions, sim_p[3], system_size)
    ttcs = zeros(size(positions)[1]-1, size(positions)[2])

    #for each agent
    for i in 1:size(positions)[2]

        #for each time-step
        for j in 1:size(positions)[1]-1

            ttcs[j, i] = min_ttc(i, j, positions, headings, velocities, geometrie, system_size)
        end
    end

    ttcs

end


function min_ttc(i, j, positions, headings, velocities, geometrie, system_size)

     ttc_i_min = 999.9

    for k in 1:size(positions)[2]

        if k != i

            for l in 1:size(positions)[1]-1

                ttc_i_min = min(ttc_i_min, ttc(positions[j, i], headings[j, i].*velocities[j, i],
                        positions[l, k], headings[l, k].*velocities[l, k], system_size))

            end

        end

    end

    ttc_i_min
end



function ttc(a_pos::NTuple{2, Float64}, a_vel::NTuple{2, Float64}, b_pos::NTuple{2, Float64}, b_vel::NTuple{2, Float64},
    system_size::NTuple{2, Float64})

    cos_α = e_(a_pos,b_pos,system_size)⋅e_v(a_vel, b_vel)
    A = ((cos_α)^2-1)*d(a_pos,b_pos,system_size)^2+0.3^2

    if A < 0 || -(cos_α)*d(a_pos,b_pos,system_size)-sqrt(A) < 0
       999
    else
        (-(cos_α)*d(a_pos,b_pos,system_size)-sqrt(A))/abs(Δv(a_vel,b_vel))
    end
end

#calculates the values for a contour plot ttc(ϕ, v)
function calc_v_ϕ_plane(a::agent, menge::crowd, geometrie::geometry, system_size, step_v, step_ϕ)


    ϕ_s = collect(0.0:step_ϕ:2π)
    v_s = collect(0.0:step_v:a.v_max)
    ttc_ = fill(0.0, length(v_s), length(ϕ_s))

    a_heading, a_vel  = a.heading, a.vel

    for (i, v) in enumerate(v_s)

        a.vel = v

        for (j, ϕ) in enumerate(ϕ_s)

            a.heading = Heading(ϕ)

            if Min_TTC(a, menge, geometrie, system_size) >= a.T

                ttc_[i, j] = 1.0
            end
        end
    end

    a.heading, a.vel = a_heading, a_vel

    ϕ_s, v_s, ttc_
end

#smooth a vector over n steps
function Smooth(a, n_steps::Int)

    a_ = fill(0.0, length(a)-n_steps)

    for i in 1:length(a_)
        a_[i] = sum(a[i:i+n_steps-1])/n_steps
    end

    a_
end

#order parameter: mean of the projection of the actual heading on the desired heading
function Order_Parameter(menge::crowd, headings)

    saved_steps = size(headings)[1]
    χ = fill(0.0, saved_steps)

    for j in 1:saved_steps

        for (i, x) in enumerate(menge.agent)

            χ[j] += x.desired_heading ⋅ headings[j, i]

        end

    end

    χ./length(menge.agent)

end
