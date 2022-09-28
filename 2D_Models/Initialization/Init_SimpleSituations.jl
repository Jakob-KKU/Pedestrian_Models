function Init_Two_Agents_α!(menge::crowd, α, d, x_min, y_min, ϵ)

    menge.agent[1].pos = (x_min + ϵ, y_min)
    menge.agent[2].pos = (x_min, y_min + d)

    menge.agent[1].e_des = (cos(α/2), sqrt(1 - cos(α/2)^2))
    menge.agent[2].e_des = (cos(α/2), -sqrt(1 - cos(α/2)^2))

    menge.agent[1].heading = (cos(α/2), sqrt(1 - cos(α/2)^2))
    menge.agent[2].heading = (cos(α/2), -sqrt(1 - cos(α/2)^2))


end

function Init_Three_Agents!(menge::crowd, d, x_min, y_min, ϵ)

    menge.agent[1].pos = (x_min, y_min)
    menge.agent[2].pos = (x_min, y_min + 2*ϵ)
    menge.agent[3].pos = (x_min + d, y_min + ϵ)


    menge.agent[1].e_des = (1.0, 0.0)
    menge.agent[2].e_des = (1.0, 0.0)
    menge.agent[3].e_des = (-1.0, 0.0)


    menge.agent[1].heading = menge.agent[1].e_des
    menge.agent[2].heading = menge.agent[2].e_des
    menge.agent[3].heading = menge.agent[3].e_des


end


function Init_Overtaking!(menge::crowd, d, x_min, y_min, ϵ, v1, v2)

    menge.agent[1].pos = (x_min, y_min)
    menge.agent[2].pos = (x_min + d, y_min + ϵ)

    menge.agent[1].e_des = (1, 0)
    menge.agent[2].e_des = (1, 0)

    menge.agent[1].heading = (1, 0)
    menge.agent[2].heading = (1, 0)

    menge.agent[1].v_max = v1
    menge.agent[2].v_max = v2

end

function Init_Overtaking!(menge::crowd, d, x_min, y_min, ϵ, v1, v2, T1, T2)

    menge.agent[1].pos = (x_min, y_min)
    menge.agent[2].pos = (x_min + d, y_min + ϵ)

    menge.agent[1].e_des = (1, 0)
    menge.agent[2].e_des = (1, 0)

    menge.agent[1].heading = (1, 0)
    menge.agent[2].heading = (1, 0)

    menge.agent[1].v_max = v1
    menge.agent[2].v_max = v2

    menge.agent[1].T2 = T1
    menge.agent[2].T2 = T2

end

function Init_Agent_Bottleneck!(ϕ, dist, menge, systemsize)

    goal = (5.0, 9.0)

    menge.agent[1].pos = dist.*(cos(ϕ), sin(ϕ)) .+ systemsize./2 .- (0.0, menge.agent[1].l*2)
    menge.agent[1].e_des = -1 .*e_(menge.agent[1], goal)

end

function Init_2_Agents_Bottleneck!(ϕ1, ϕ2, dist1, dist2, menge, systemsize)

    goal = (5.0, 9.0)

    menge.agent[1].pos = dist1.*(cos(ϕ1), sin(ϕ1)) .+ systemsize./2 .- (0.0, menge.agent[1].l*2)
    menge.agent[1].e_des = -1 .*e_(menge.agent[1], goal)

    menge.agent[2].pos = dist2.*(cos(ϕ2), sin(ϕ2)) .+ systemsize./2 .- (0.0, menge.agent[2].l*2)
    menge.agent[2].e_des = -1 .*e_(menge.agent[2], goal)

end

function Init_3_Agents_Bottleneck!(ϕ1, ϕ2, ϕ3, dist1, dist2, dist3, menge, systemsize)

    goal = (5.0, 9.0)

    menge.agent[1].pos = dist1.*(cos(ϕ1), sin(ϕ1)) .+ systemsize./2 .- (0.0, menge.agent[1].l*2)
    menge.agent[1].e_des = -1 .*e_(menge.agent[1], goal)

    menge.agent[2].pos = dist2.*(cos(ϕ2), sin(ϕ2)) .+ systemsize./2 .- (0.0, menge.agent[2].l*2)
    menge.agent[2].e_des = -1 .*e_(menge.agent[2], goal)

    menge.agent[3].pos = dist3.*(cos(ϕ3), sin(ϕ3)) .+ systemsize./2 .- (0.0, menge.agent[3].l*2)
    menge.agent[3].e_des = -1 .*e_(menge.agent[3], goal)

end

function Init_4_Agents_Bottleneck!(ϕ1, ϕ2, ϕ3, ϕ4, dist1, dist2, dist3, dist4, menge, systemsize)

    goal = (5.0, 9.0)

    menge.agent[1].pos = dist1.*(cos(ϕ1), sin(ϕ1)) .+ systemsize./2 .- (0.0, menge.agent[1].l*2)
    menge.agent[1].e_des = -1 .*e_(menge.agent[1], goal)

    menge.agent[2].pos = dist2.*(cos(ϕ2), sin(ϕ2)) .+ systemsize./2 .- (0.0, menge.agent[2].l*2)
    menge.agent[2].e_des = -1 .*e_(menge.agent[2], goal)

    menge.agent[3].pos = dist3.*(cos(ϕ3), sin(ϕ3)) .+ systemsize./2 .- (0.0, menge.agent[3].l*2)
    menge.agent[3].e_des = -1 .*e_(menge.agent[3], goal)

    menge.agent[4].pos = dist3.*(cos(ϕ4), sin(ϕ4)) .+ systemsize./2 .- (0.0, menge.agent[4].l*2)
    menge.agent[4].e_des = -1 .*e_(menge.agent[4], goal)

end

function Initialize_Circle!(menge::crowd, R_::Float64, P_0::NTuple{2, Float64})

    dϕ = 2π/length(menge.agent)

    for (i, x) in enumerate(menge.agent)

        x.pos = (R_*cos((i-1)*dϕ)+P_0[1], R_*sin((i-1)*dϕ)+P_0[2])
        x.e_des = -1 .*e_(x.pos, P_0)
        x.heading = x.e_des

    end

end
