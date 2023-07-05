function Calc_Single_Acc(menge::crowd, i::Int64, L, dt)

    x = menge.agent[i].pred

    acc(menge.agent[i], menge.agent[x], L)

end

function acc(a::agent, b::agent, L)
    (ov(a, b, L) - a.vel)/a.τ
end
#ov(a::agent, b::agent, L) = max(0.0,(d(a, b, L) - l(a, b))/a.T)
#ov(a::agent, b::agent, L) = min(a.v_max,(d(a, b, L) - l(a, b))/a.T)
ov(a::agent, b::agent, L) = min(a.v_max, max(0.0,(d(a, b, L) - l(a, b))/a.T))
#ov(a::agent, b::agent, L) = (d(a, b, L) - l(a, b))/a.T
;
