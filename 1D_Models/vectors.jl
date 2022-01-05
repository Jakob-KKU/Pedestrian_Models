function ttc(a::agent, b::agent, L)

    if Δv(a, b) > 0
        (d(a, b, L) + l(a, b))/Δv(a, b)
    else
        999.9
    end
end


function d(a::agent, b::agent, L)

    dx = abs(b.pos - a.pos)

    if a.pos > b.pos
        L - dx
    else
        dx
    end
end

Δv(a::agent, b::agent) = a.vel - b.vel

l(a::agent, b::agent) = (a.l + b.l)/2
;
