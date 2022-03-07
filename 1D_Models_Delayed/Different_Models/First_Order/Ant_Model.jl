function Calc_Single_Velocity(menge::crowd, i::Int64, L, t)

    a = menge.agent[i]
    b = menge.agent[a.pred]

    b_i = Int(round(mod(t/b.dt, b.τ_R/b.dt)))+1


    ov(a, b, L, t) +  a.τ_A/(a.T+a.τ_A)*b.v_h[b_i]

end

ov(a::agent, b::agent, L, t) = (d_del(a, b, L, t) - l(a, b))/(a.T+a.τ_A)
;
