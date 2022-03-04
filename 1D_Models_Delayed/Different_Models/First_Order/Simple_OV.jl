function Calc_Single_Velocity(menge::crowd, i::Int64, L, t)

    x = menge.agent[i].pred

    ov(menge.agent[i], menge.agent[x], L, t)

end

ov(a::agent, b::agent, L, t) = max(0.0, (d_del(a, b, L, t) - l(a, b))/a.T)
;
