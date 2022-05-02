function Calc_Single_Velocity(menge::crowd, i::Int64, L, t)

    a = menge.agent[i]
    b = menge.agent[i].pred

    ov(a, b, L, t) + a.σ * randn()

end

ov(a::agent, b::agent, L, t) = (d_del(a, b, L, t) - l(a, b))/a.T
;
