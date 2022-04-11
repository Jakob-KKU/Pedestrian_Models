function Calc_Single_Velocity(menge::crowd, i::Int64, L, t)

    a = menge.agent[i]
    b = menge.agent[a.pred]

    ov(a, b, L, t) +  a.τ_A*ov_nod(a, b, L, t)*Δv_del(a, b, t)

end

ov(a::agent, b::agent, L, t) = max(0.0, (d_del(a, b, L, t) - l(a, b))/a.T)

function ov_nod(a::agent, b::agent, L, t)

    if d_del(a, b, L, t) - l(a, b) < 0
       0.0
    else
        1/a.T
    end
end


#ov(a::agent, b::agent, L, t) = (d_del(a, b, L, t) - l(a, b))/a.T

#ov_nod(a::agent, b::agent, L, t) = 1/a.T


;
