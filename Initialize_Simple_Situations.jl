function Init_Two_Agents_α!(menge::crowd, α, d, x_min, y_min, ϵ)

    menge.agent[1].pos = (x_min + ϵ, y_min)
    menge.agent[2].pos = (x_min, y_min + d)

    menge.agent[1].desired_heading = (cos(α/2), sqrt(1 - cos(α/2)^2))
    menge.agent[2].desired_heading = (cos(α/2), -sqrt(1 - cos(α/2)^2))

    menge.agent[1].heading = (cos(α/2), sqrt(1 - cos(α/2)^2))
    menge.agent[2].heading = (cos(α/2), -sqrt(1 - cos(α/2)^2))


end


function Init_Overtaking!(menge::crowd, d, x_min, y_min, ϵ, v1, v2)

    menge.agent[1].pos = (x_min, y_min)
    menge.agent[2].pos = (x_min + d, y_min + ϵ)

    menge.agent[1].desired_heading = (1, 0)
    menge.agent[2].desired_heading = (1, 0)

    menge.agent[1].heading = (1, 0)
    menge.agent[2].heading = (1, 0)

    menge.agent[1].v_max = v1
    menge.agent[2].v_max = v2

end

function Init_Agent_Bottleneck!(ϕ, dist, menge, systemsize)

    goal = (5.0, 9.0)

    menge.agent[1].pos = dist.*(cos(ϕ), sin(ϕ)) .+ systemsize./2 .- (0.0, menge.agent[1].l*2)
    menge.agent[1].desired_heading = -1 .*e_(menge.agent[1], goal)

end

function Init_2_Agents_Bottleneck!(ϕ1, ϕ2, dist1, dist2, menge, systemsize)

    goal = (5.0, 9.0)

    menge.agent[1].pos = dist1.*(cos(ϕ1), sin(ϕ1)) .+ systemsize./2 .- (0.0, menge.agent[1].l*2)
    menge.agent[1].desired_heading = -1 .*e_(menge.agent[1], goal)

    menge.agent[2].pos = dist2.*(cos(ϕ2), sin(ϕ2)) .+ systemsize./2 .- (0.0, menge.agent[2].l*2)
    menge.agent[2].desired_heading = -1 .*e_(menge.agent[2], goal)

end

function Init_3_Agents_Bottleneck!(ϕ1, ϕ2, ϕ3, dist1, dist2, dist3, menge, systemsize)

    goal = (5.0, 9.0)

    menge.agent[1].pos = dist1.*(cos(ϕ1), sin(ϕ1)) .+ systemsize./2 .- (0.0, menge.agent[1].l*2)
    menge.agent[1].desired_heading = -1 .*e_(menge.agent[1], goal)

    menge.agent[2].pos = dist2.*(cos(ϕ2), sin(ϕ2)) .+ systemsize./2 .- (0.0, menge.agent[2].l*2)
    menge.agent[2].desired_heading = -1 .*e_(menge.agent[2], goal)

    menge.agent[3].pos = dist3.*(cos(ϕ3), sin(ϕ3)) .+ systemsize./2 .- (0.0, menge.agent[3].l*2)
    menge.agent[3].desired_heading = -1 .*e_(menge.agent[3], goal)

end

function Init_4_Agents_Bottleneck!(ϕ1, ϕ2, ϕ3, ϕ4, dist1, dist2, dist3, dist4, menge, systemsize)

    goal = (5.0, 9.0)

    menge.agent[1].pos = dist1.*(cos(ϕ1), sin(ϕ1)) .+ systemsize./2 .- (0.0, menge.agent[1].l*2)
    menge.agent[1].desired_heading = -1 .*e_(menge.agent[1], goal)

    menge.agent[2].pos = dist2.*(cos(ϕ2), sin(ϕ2)) .+ systemsize./2 .- (0.0, menge.agent[2].l*2)
    menge.agent[2].desired_heading = -1 .*e_(menge.agent[2], goal)

    menge.agent[3].pos = dist3.*(cos(ϕ3), sin(ϕ3)) .+ systemsize./2 .- (0.0, menge.agent[3].l*2)
    menge.agent[3].desired_heading = -1 .*e_(menge.agent[3], goal)

    menge.agent[4].pos = dist3.*(cos(ϕ4), sin(ϕ4)) .+ systemsize./2 .- (0.0, menge.agent[4].l*2)
    menge.agent[4].desired_heading = -1 .*e_(menge.agent[4], goal)

end
