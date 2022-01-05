function Calc_Single_Velocity(menge::crowd, i::Int64, L, dt)

    x = mod(i, length(menge.agent))+1
    x_2 = mod(x, length(menge.agent))+1

    ov(menge.agent[i], menge.agent[x], L) +
    menge.agent[i].γ * (d(menge.agent[i], menge.agent[x], L) -
    d(menge.agent[x], menge.agent[x_2], L)) + menge.agent[i].σ * randn()

end

ov(a::agent, b::agent, L) = min(a.v_max, max(0.0,(d(a, b, L) - l(a, b))/a.T))
#ov(a::agent, b::agent, L) = (d(a, b, L) - l(a, b))/a.T

;
