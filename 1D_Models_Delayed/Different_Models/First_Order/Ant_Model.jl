function Calc_Single_Velocity(menge::crowd, i::Int64, L, t)

    a = menge.agent[i]
    b = menge.agent[a.pred]

    ov(a, b, L, t) +  a.τ_A/(a.T+a.τ_A)*b.v_h[b.i]

end

ov(a::agent, b::agent, L, t) = (d_del(a, b, L, t) - l(a, b))/(a.T+a.τ_A)
;
