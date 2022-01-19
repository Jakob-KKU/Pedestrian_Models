function Calc_Single_Acc(menge::crowd, i::Int64, L, dt)

    x = menge.agent[i].pred
    x_2 = menge.agent[x].pred

    acc(menge.agent[i], menge.agent[x], menge.agent[x_2], L)

end

function acc(a::agent, b::agent, c::agent, L)

    return (1/a.τ *(ov(a, b, L) - a.vel)
    + a.τ_A/(a.T*a.τ)*Δv(a, b)
    + a.γ*(d(a, b, L) - d(b, c, L))
    + a.σ * randn())

end
#ov(a::agent, b::agent, L) = max(0.0,(d(a, b, L) - l(a, b))/a.T)
#ov(a::agent, b::agent, L) = min(a.v_max,(d(a, b, L) - l(a, b))/a.T)
#ov(a::agent, b::agent, L) = min(a.v_max, max(0.0,(d(a, b, L) - l(a, b))/a.T))
ov(a::agent, b::agent, L) = (d(a, b, L) - l(a, b))/a.T
;
