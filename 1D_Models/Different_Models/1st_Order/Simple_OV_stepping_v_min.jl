function Calc_Single_Velocity(menge::crowd, i::Int64, L, dt)

    if menge.agent[i].step <= dt

        menge.agent[i].step += menge.agent[i].dt_step

        x = mod(i, length(menge.agent))+1

        if ov(menge.agent[i], menge.agent[x], L) < 0.2
            0.0
        else
            ov(menge.agent[i], menge.agent[x], L)
        end


    else
        menge.agent[i].step -= dt
        menge.agent[i].vel
    end

end

ov(a::agent, b::agent, L) = min(a.v_max, max(0.0,(d(a, b, L) - l(a, b))/a.T))
;
