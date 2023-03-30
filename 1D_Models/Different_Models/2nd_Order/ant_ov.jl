function Calc_Single_Acc(menge::crowd, i::Int64, L, dt)

    x = menge.agent[i].pred

    acc(menge.agent[i], menge.agent[x], L)

end

function acc(a::agent, b::agent, L)
    (ov_Ant(a, b, L) - a.vel)/a.τ
end

#ov_Ant(a::agent, b::agent, L) = min(a.v_max, ov(a, b, L)+b.vel*a.τ_A/(a.T+a.τ_A))
#ov_Ant(a::agent, b::agent, L) = ov(a, b, L)+b.vel*a.τ_A/(a.T+a.τ_A)

#ov(a::agent, b::agent, L) = max(0.0,(d(a, b, L) - l(a, b))/(a.T+a.τ_A))
#ov(a::agent, b::agent, L) = min(a.v_max,(d(a, b, L) - l(a, b))/(a.T+a.τ_A))
#ov(a::agent, b::agent, L) = min(a.v_max, max(0.0,(d(a, b, L) - l(a, b))/(a.T+a.τ_A)))
ov(a::agent, b::agent, L) = (d(a, b, L) - l(a, b))/(a.T+a.τ_A);
