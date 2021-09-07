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

    menge.agent[1].parameters.v_max = v1
    menge.agent[2].parameters.v_max = v2

end



    
