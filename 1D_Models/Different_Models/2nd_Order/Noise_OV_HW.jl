function Calc_Single_Acc(menge::crowd, dx, i::Int64, L, dt)

    x = menge.agent[i].pred
    a = menge.agent[i]
    b = menge.agent[x]

    (1/a.τ * (ov(a, b, dx[i], L) + a.τ_A*Δv(a, b)*ov_nod(a, b, dx[i], L) - a.vel)
    + a.γ*(dx[i] - dx[x])
    + a.σ * randn())


end


ov(a::agent, b::agent, dx, L) = max(0.0,(dx - l(a, b))/a.T)
#ov(a::agent, b::agent, L) = min(a.v_max,(d(a, b, L) - l(a, b))/a.T)
#ov(a::agent, b::agent, L) = min(a.v_max, max(0.0,(d(a, b, L) - l(a, b))/a.T))
#ov(a::agent, b::agent, dx, L) = (dx - l(a, b))/a.T

#ov_nod(a::agent, b::agent, dx, L) = 1/a.T

function ov_nod(a::agent, b::agent, dx, L)

    if dx - l(a, b) < 0
        0.0
    else
        1/a.T
    end
end

;
