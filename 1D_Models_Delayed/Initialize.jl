function Init_Hom_Parameters!(menge::crowd,v_max, T, l, τ_R, τ_A, dt, σ)

    for i in 1:length(menge.agent)

        menge.agent[i].v_max = v_max
        menge.agent[i].T = T
        menge.agent[i].l = l
        menge.agent[i].τ_R = τ_R
        menge.agent[i].τ_A = τ_A
        menge.agent[i].σ = σ
        menge.agent[i].dt = dt

    end

end

function Init_Hom_History!(menge::crowd, ic_vel, L)

    for (i,a) in enumerate(menge.agent)

        for j in 1:length(a.x_h)

            a.x_h[j] = mod((i-1)*L/length(menge.agent)+a.dt*j*ic_vel, L)
            a.v_h[j] = ic_vel

        end

        a.pos = a.x_h[end]
        a.vel = ic_vel

    end
end

function Add_Max_Pertubation!(menge::crowd, i, L)

    x = mod(i, length(menge.agent))+1
    pert = d(menge.agent[i], menge.agent[x], L) - l(menge.agent[i], menge.agent[x])


    menge.agent[i].pos += min(pert, 1.0)


end
;
