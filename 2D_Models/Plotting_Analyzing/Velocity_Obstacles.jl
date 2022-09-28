function Calc_Vel_Obs(a::agent, b::agent, τ, dτ, dv)

    times = collect(0:dτ:τ)
    v_x = collect(-a.v_max:dv:a.v_max)
    v_y = collect(-a.v_max:dv:a.v_max)

    vel_obs = fill(1.0, length(v_x), length(v_y))

    m = b.pos .- a.pos
    r = (a.l + b.l)/2

    for (i, vx) in enumerate(v_x)

        for (j, vy) in enumerate(v_y)

            for t in times

                if p_in_D(t.*((vx,vy).-b.heading.*b.vel), m, r) == true

                    vel_obs[j, i] = 0.0

                end

            end


        end
    end

    vel_obs, v_x, v_y

end


function p_in_D(p, m, r)

    if abs(p.-m)>r

        false

    else

        true

    end

end

function Calc_Vel_Obs_2(a::agent, b::agent, dv)

    v_x = collect(-a.v_max:dv:a.v_max)
    v_y = collect(-a.v_max:dv:a.v_max)

    vel_obs = fill(1.0, length(v_x), length(v_y))

    m = b.pos .- a.pos
    r = (a.l + b.l)/2

    for (i, vx) in enumerate(v_x)

        for (j, vy) in enumerate(v_y)

            a_vel = abs((vx, vy))
            a_heading = (vx, vy)./a_vel

            vel_obs[j, i] = 1/ttc(a, b, a_heading, a_vel)

            #if ttc(a, b, a_heading, a_vel) <= a.T

            #    vel_obs[j, i] = 0.0

            #end
        end
    end

    vel_obs, v_x, v_y

end

function Calc_Vel_Obs_3(a::agent, b::agent, τ, dτ, dv)

    v_x = collect(-a.v_max:dv:a.v_max)
    v_y = collect(-a.v_max:dv:a.v_max)

    vel_obs = fill(1.0, length(v_x), length(v_y))

    m = b.pos .- a.pos
    r = (a.l + b.l)/2

    for (i, vx) in enumerate(v_x)

        for (j, vy) in enumerate(v_y)

            a_vel = abs((vx, vy))
            a_heading = (vx, vy)./a_vel

            if TimeGap(a, b, a_heading, a_vel) <= τ

                vel_obs[j, i] = 0.0

            end
        end
    end

    vel_obs, v_x, v_y

end
