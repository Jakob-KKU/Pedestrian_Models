#define a dot product
⋅(u::NTuple{2, Float64}, v::NTuple{2, Float64}) = u[1]*v[1]+u[2]*v[2]
⋅(u::Vector{Float64}, v::Vector{Float64}) = u[1]*v[1]+u[2]*v[2]
⋅(u::agent, v::agent) = u.heading[1]*v.heading[1]+u.heading[2]*v.heading[2]

#abstand
d(u::agent, v::agent) =  sqrt((u.pos[1]-v.pos[1])^2+(u.pos[2]-v.pos[2])^2)
d(u::element, v::agent) =  sqrt((u.pos[1]-v.pos[1])^2+(u.pos[2]-v.pos[2])^2)
d(u::agent, v::element) =  sqrt((u.pos[1]-v.pos[1])^2+(u.pos[2]-v.pos[2])^2)
d(u::NTuple{2, Float64}, v::NTuple{2, Float64}) =  sqrt((u[1]-v[1])^2+(u[2]-v[2])^2)
d(u::Vector{Float64}, v::Vector{Float64}) =  sqrt((u[1]-v[1])^2+(u[2]-v[2])^2)

function d(a::agent, b::agent, system_size::NTuple{2, Float64})
    dx = abs(a.pos[1]-b.pos[1])
    dy = abs(a.pos[2]-b.pos[2])

    if dx > system_size[1]/2
        dx = system_size[1] - dx
    end
    if dy > system_size[2]/2
        dy = system_size[2] - dy
    end

    return sqrt(dx^2 + dy^2)
end

function d(a::agent, b::element, system_size::NTuple{2, Float64})
    dx = abs(a.pos[1]-b.pos[1])
    dy = abs(a.pos[2]-b.pos[2])

    if dx > system_size[1]/2
        dx = system_size[1] - dx
    end
    if dy > system_size[2]/2
        dy = system_size[2] - dy
    end

    return sqrt(dx^2 + dy^2)
end

function d(a::element, b::agent, system_size::NTuple{2, Float64})
    dx = abs(a.pos[1]-b.pos[1])
    dy = abs(a.pos[2]-b.pos[2])

    if dx > system_size[1]/2
        dx = system_size[1] - dx
    end
    if dy > system_size[2]/2
        dy = system_size[2] - dy
    end

    return sqrt(dx^2 + dy^2)
end


#common_size i.e. l_i/2 + l_j/2
l(u::agent, v::agent) = u.parameters.l/2 + v.parameters.l/2
l(u::element, v::agent) = u.l/2 + v.parameters.l/2
l(u::agent, v::element) = u.parameters.l/2 + v.l/2

#betrag
Base.abs(a::NTuple{2, Float64}) = sqrt(a[1]^2+a[2]^2)
function Base.abs(a::Vector{Float64})

    betrag = 0
    for x in a
        betrag += x^2
    end
    sqrt(betrag)
end

#senkrechter Vektor auf a in 2D
⟂(a::NTuple{2, Float64}) = (-a[2], a[1])
⟂(a::Vector{Float64}) = [-a[2], a[1]]

#vektor auf länge 1 normalisieren
normalize(a::NTuple{2, Float64}) = a./abs(a)
normalize(a::Vector{Float64}) = a./abs(a)

#winkel zwischen a und b
∠(a::NTuple{2, Float64}, b::NTuple{2, Float64}) = acos((a⋅b)/(abs(a)*abs(b)))
∠(a::Vector{Float64}, b::Vector{Float64}) = acos((a⋅b)/(abs(a)*abs(b)))
∠(a::agent, b::agent) = acos(a⋅b)

#einheitsvektor von b nach a
e_(b::agent, a::agent) = (b.pos.-a.pos)./d(a, b)
e_(b::NTuple{2, Float64}, a::NTuple{2, Float64}) = (b.-a)./d(a, b)
e_(b::Vector{Float64}, a::Vector{Float64}) = (b.-a)./d(a, b)
e_(b::agent, a::element) = (b.pos.-a.pos)./d(a, b)
e_(b::element, a::agent) = (b.pos.-a.pos)./d(a, b)

e_v(b::agent, a::agent) = normalize(b.vel.*b.heading .- a.vel.*a.heading)
e_v(b::agent, a::agent, v_b::Float64) = normalize(v_b.*b.heading .- a.vel.*a.heading)

v(a::agent) = a.vel.*a.heading
Δv(a::agent, b::agent) = v(a) .- v(b)
Δv(a::agent, b::agent, v_a::Float64) = a.heading.*v_a .- v(b)




function e_(a::agent, b::agent, system_size::NTuple{2, Float64})
    dx, dy = a.pos.-b.pos

    if dx > system_size[1]/2
        dx = dx - system_size[1]
    elseif dx < -system_size[1]/2
        dx = dx + system_size[1]
    end
    if dy > system_size[2]/2
        dy = dy - system_size[2]
    elseif dy < -system_size[2]/2
        dy = dy + system_size[2]
    end

    (dx, dy) ./ sqrt(dx^2 + dy^2)
end

function e_(a::agent, b::element, system_size::NTuple{2, Float64})
    dx, dy = a.pos.-b.pos

    if dx > system_size[1]/2
        dx = dx - system_size[1]
    elseif dx < -system_size[1]/2
        dx = dx + system_size[1]
    end
    if dy > system_size[2]/2
        dy = dy - system_size[2]
    elseif dy < -system_size[2]/2
        dy = dy + system_size[2]
    end

    (dx, dy) ./ sqrt(dx^2 + dy^2)
end

function e_(a::element, b::agent, system_size::NTuple{2, Float64})
    dx, dy = a.pos.-b.pos

    if dx > system_size[1]/2
        dx = dx - system_size[1]
    elseif dx < -system_size[1]/2
        dx = dx + system_size[1]
    end
    if dy > system_size[2]/2
        dy = dy - system_size[2]
    elseif dy < -system_size[2]/2
        dy = dy + system_size[2]
    end

    (dx, dy) ./ sqrt(dx^2 + dy^2)
end

;
