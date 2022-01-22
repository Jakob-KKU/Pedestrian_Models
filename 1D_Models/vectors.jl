function ttc(a::agent, b::agent, L)

    if Δv(a, b) > 0
        (d(a, b, L) + l(a, b))/Δv(a, b)
    else
        999.9
    end
end


function d_neg(a::agent, b::agent, L)

    dx = b.pos - a.pos

    if abs(dx) > L/2

        if dx > 0.0
            L - dx
        else
            L + dx
        end
    else
        dx
    end

end

function d(a::agent, b::agent, L)

    dx = abs(b.pos - a.pos)

    if dx > L/2
        L - dx
    else
        dx
    end

end

Δv(a::agent, b::agent) = b.vel - a.vel

l(a::agent, b::agent) = (a.l + b.l)/2
;
