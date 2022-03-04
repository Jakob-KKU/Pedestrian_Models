function Calc_Single_Velocity(menge::crowd, i::Int64, L, dt)

    a = menge.agent[i]
    b = menge.agent[mod(i, length(menge.agent))+1]

    min(a.v_max, ov(a, b, L)+b.vel*a.τ_A/(a.T+a.τ_A))
end

#ov(a::agent, b::agent, L) = max(0.0,(d(a, b, L) - l(a, b))/(a.T+a.τ_A))
#ov(a::agent, b::agent, L) = min(a.v_max,(d(a, b, L) - l(a, b))/(a.T+a.τ_A))
#ov(a::agent, b::agent, L) = min(a.v_max, max(0.0,(d(a, b, L) - l(a, b))/(a.T+a.τ_A)))
#ov(a::agent, b::agent, L) = (d(a, b, L) - l(a, b))/(a.T+a.τ_A);
