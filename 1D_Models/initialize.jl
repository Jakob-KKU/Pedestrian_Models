function Init_Hom_Parameters!(menge::crowd,v_max, T, l, τ, dt_step)

    for i in 1:length(menge.agent)

        menge.agent[i].v_max = v_max
        menge.agent[i].T = T
        menge.agent[i].l = l
        menge.agent[i].τ = τ
        menge.agent[i].dt_step = dt_step

    end

end

function Init_Hom_Velocities!(menge::crowd, vel::Float64)

    for i in 1:length(menge.agent)

        menge.agent[i].vel = vel

    end

end

function Init_Random_Step_Pos!(menge::crowd)

    for x in menge.agent

        x.step = round(x.dt_step.*rand(), digits = 3)

    end

end


function Init_Hom_Positions!(menge::crowd, L)

    for i in 1:length(menge.agent)

        menge.agent[i].pos = (i-1)*L/length(menge.agent)

    end
end


function Init_Ampel_Start!(menge::crowd, L)

    current_pos = 0

    for i in 1:length(menge.agent)

        current_pos = current_pos +  menge.agent[i].l
        menge.agent[i].pos = current_pos

    end
end
;
