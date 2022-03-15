function Init_Hom_Parameters!(menge::crowd,v_max, T, l, τ_R, τ_A, σ)

    for i in 1:length(menge.agent)

        menge.agent[i].v_max = v_max
        menge.agent[i].T = T
        menge.agent[i].l = l
        menge.agent[i].τ_R = τ_R
        menge.agent[i].τ_A = τ_A
        menge.agent[i].σ = σ

    end

end

function Init_Hom_History!(menge::crowd, ic_vel, L, dt)

    for (i,a) in enumerate(menge.agent)

        for j in 1:length(a.x_h)

            a.x_h[j] = mod((i-1)*L/length(menge.agent)+dt*j*ic_vel, L)
            a.v_h[j] = ic_vel

        end

        a.pos = a.x_h[end]
        a.vel = a.v_h[end]

    end
end

function Add_Max_Pertubation!(menge::crowd, i, L)

    x = mod(i, length(menge.agent))+1

    pert = d(menge.agent[i], menge.agent[x], L) - l(menge.agent[i], menge.agent[x])


    menge.agent[i].pos += min(pert, 1.0)
    menge.agent[i].pos += min(pert, 1.0)


end

function Add_History_Pertubation!(menge::crowd, i, L)

    x = mod(i, length(menge.agent))+1
    a = menge.agent[i]
    b = menge.agent[x]

    T_a = 0.3
    a_decc = 1.0*a.vel / T_a


    for i in 2:length(a.x_h)

        a.x_h[i] = a.x_h[1]

        if i*a.dt > length(a.x_h)*a.dt - T_a

            a.v_h[i] = a.v_h[i-1]-a_decc*a.dt

        end

        a.x_h[i] = a.x_h[i-1]+a.dt*a.v_h[i]


    end

    a.pos = a.x_h[end]
    a.vel = a.v_h[end]


end
;
