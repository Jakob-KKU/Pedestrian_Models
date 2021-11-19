

function Calc_Single_Velocity(menge::crowd, i::Int64, L, dt)

    x = mod(i, length(menge.agent))+1

    ov(menge.agent[i], menge.agent[x], L)

end

ov(a::agent, b::agent, L) = min(a.v_max, max(0.0,(d(a, b, L) - l(a, b))/a.T))
;
