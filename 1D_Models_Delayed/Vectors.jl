function d_del(a::agent, b::agent, L, t)

    a_i = a.i
    b_i = b.i

    #a_i = Int(round(mod(t/a.dt, a.τ_R/a.dt)))+1
    #b_i = Int(round(mod(t/b.dt, b.τ_R/b.dt)))+1

    dx = b.x_h[b_i] - a.x_h[a_i]

    if abs(dx) > L/2
        if dx < 0.0
            dx + L
        else
            dx - L
        end
    else
        dx
    end
end

function Δv_del(a::agent, b::agent, t)

    #a_i = Int(round(mod(t/a.dt, a.τ_R/a.dt)))+1
    #b_i = Int(round(mod(t/b.dt, b.τ_R/b.dt)))+1

    a_i = a.i
    b_i = b.i

    b.v_h[b_i] - a.v_h[a_i]

end



function d(a::agent, b::agent, L)
    dx = b.pos - a.pos
    if abs(dx) > L/2
        if dx < 0.0
            dx + L
        else
            dx - L
        end
    else
        dx
    end
end


l(a::agent, b::agent) = (a.l + b.l)/2;
