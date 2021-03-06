function Init_Hom_Parameters!(menge::crowd,v_max, T, l, τ, τ_A, dt_step, γ, σ)

    for i in 1:length(menge.agent)

        menge.agent[i].v_max = v_max
        menge.agent[i].T = T
        menge.agent[i].l = l
        menge.agent[i].τ = τ
        menge.agent[i].τ_A = τ_A
        menge.agent[i].σ = σ
        menge.agent[i].γ = γ
        menge.agent[i].dt_step = dt_step

    end

end

function Init_EQ_Positions!(menge::crowd, dist)

    for i in 1:length(menge.agent)

        menge.agent[i].pos = (i-1)*dist

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

function Add_Pertubation!(menge::crowd, i, dx)

    menge.agent[i].pos += menge.agent[i].pos + dx

end

function Add_Max_Pertubation!(menge::crowd, i, L)

    x = mod(i, length(menge.agent))+1
    pert = d(menge.agent[i], menge.agent[x], L) - l(menge.agent[i], menge.agent[x])


    menge.agent[i].pos += min(pert, 1.0)


end
;
