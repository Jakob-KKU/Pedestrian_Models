#heavyside
Θ(x) = x > 0.0 ? 1.0 : 0.0
Θ(x, k::Int) = 0.5 + 0.5 * tanh(k*x)

#define a dot product
⋅(u::NTuple{2, Float64}, v::NTuple{2, Float64}) = u[1]*v[1]+u[2]*v[2]
⋅(u::Vector{Float64}, v::Vector{Float64}) = u[1]*v[1]+u[2]*v[2]
⋅(u::agent, v::agent) = u.heading[1]*v.heading[1]+u.heading[2]*v.heading[2]
⋅(A::Matrix, x::NTuple{2, Float64}) = (x[1]*A[1, 1]+x[2]*A[1, 2], x[1]*A[2, 1]+x[2]*A[2, 2])


#abstand
d(u::agent, v::agent) =  sqrt((u.pos[1]-v.pos[1])^2+(u.pos[2]-v.pos[2])^2)
d(u::element, v::agent) =  sqrt((u.pos[1]-v.pos[1])^2+(u.pos[2]-v.pos[2])^2)
d(u::agent, v::element) =  sqrt((u.pos[1]-v.pos[1])^2+(u.pos[2]-v.pos[2])^2)
d(u::agent, v::NTuple{2, Float64}) =  sqrt((u.pos[1]-v[1])^2+(u.pos[2]-v[2])^2)
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

function d(a::NTuple{2, Float64}, b::NTuple{2, Float64}, system_size::NTuple{2, Float64})
    dx = abs(a[1]-b[1])
    dy = abs(a[2]-b[2])

    if dx > system_size[1]/2
        dx = system_size[1] - dx
    end
    if dy > system_size[2]/2
        dy = system_size[2] - dy
    end

    return sqrt(dx^2 + dy^2)
end


#common_size i.e. l_i/2 + l_j/2
l(u::agent, v::agent) = u.l/2 + v.l/2
l(u::element, v::agent) = u.l/2 + v.l/2
l(u::agent, v::element) = u.l/2 + v.l/2

l_min(u::agent, v::agent) = u.l_min/2 + v.l_min/2
l_min(u::element, v::agent) = u.l/2 + v.l_min/2
l_min(u::agent, v::element) = u.l_min/2 + v.l/2

#betrag
Base.abs(a::T) where T<:NTuple{2, Real} = sqrt(a[1]^2+a[2]^2)

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
∠(a::NTuple{2, Float64}, b::NTuple{2, Float64}) = acos(clamp((a⋅b)/(abs(a)*abs(b)),-1.0, 1.0))
∠(a::Vector{Float64}, b::Vector{Float64}) = acos(clamp((a⋅b)/(abs(a)*abs(b)),-1.0, 1.0))
∠(a::agent, b::agent) = acos(clamp((a⋅b)/(abs(a)*abs(b)),-1.0, 1.0))
#winkel zwischen orts vektor von a nach b und dem heading von a
∠_h(a::agent, b::agent) = acos(clamp(e_(b, a)⋅a.heading,-1.0, 1.0))
∠_h(a::agent, b::agent, system_size) = acos(clamp(e_(b, a, system_size)⋅a.heading,-1.0, 1.0))
∠_h(a::agent, a_v, b::agent, system_size) = acos(clamp(e_(b, a, system_size)⋅normalize(a_v),-1.0, 1.0))



#einheitsvektor von b nach a
e_(b::agent, a::agent) = (b.pos.-a.pos)./d(a, b)
e_(b::NTuple{2, Float64}, a::NTuple{2, Float64}) = (b.-a)./d(a, b)
e_(b::Vector{Float64}, a::Vector{Float64}) = (b.-a)./d(a, b)
e_(b::agent, a::element) = (b.pos.-a.pos)./d(a, b)
e_(b::element, a::agent) = (b.pos.-a.pos)./d(a, b)
e_(b::agent, a::NTuple{2, Float64}) = (b.pos.-a)./d(b, a)

e_v(a::agent) = normalize(a.vel.*a.heading)
e_v(b::agent, a::agent) = normalize(b.vel.*b.heading .- a.vel.*a.heading)
e_v(v_b::NTuple{2, Float64}, v_a::NTuple{2, Float64}) = normalize(v_b .- v_a)
e_v(b::agent, a::agent, v_b::Float64) = normalize(v_b.*b.heading .- a.vel.*a.heading)
e_v(b::agent, a::agent, v_b::Float64, v_a::Float64) = normalize(v_b.*b.heading .- v_a.*a.heading)
e_v(b::agent, a::agent, b_heading::NTuple{2, Float64}) = normalize(b.vel.*b_heading .- a.vel.*a.heading)
e_v(b::agent, a::agent, b_heading::NTuple{2, Float64}, v_a::Float64) = normalize(b.vel.*b_heading .- v_a.*a.heading)
e_v(b::agent, a::agent, b_heading::NTuple{2, Float64}, b_vel::Float64) = normalize(b_vel.*b_heading .- a.vel.*a.heading)


v(a::agent) = a.vel.*a.heading
v(a::agent, v_a) = v_a.*a.heading
v(a::agent, a_heading::NTuple{2, Float64}) = a.vel.*a_heading
v(vel::Float64, ϕ::Float64) = vel.*(cos(ϕ), sin(ϕ))
Heading(ϕ::Float64) = (cos(ϕ), sin(ϕ))
Heading(ϕ::Int64) = (cos(ϕ), sin(ϕ))


Δv(a::agent, b::agent) = v(a) .- v(b)
Δv(a::NTuple{2, Float64}, b::agent) = a .- v(b)
Δv(v_a::NTuple{2, Float64}, v_b::NTuple{2, Float64}) = v_a .- v_b
Δv(a::agent, b::agent, v_a::Float64) = a.heading.*v_a .- v(b)
Δv(a::agent, b::agent, v_a::Float64, v_b) = a.heading.*v_a .- b.heading.*v_b
Δv(a::agent, b::agent, a_heading::NTuple{2, Float64}) = v(a, a_heading) .- v(b)
Δv(a::agent, b::agent, a_heading::NTuple{2, Float64}, v_b::Float64) = v(a, a_heading) .- v(b, v_b)
Δv(a::agent, b::agent, a_heading::NTuple{2, Float64}, a_vel::Float64) = a_vel.*a_heading .- v(b)


R(ϕ) = [cos(ϕ) -sin(ϕ); sin(ϕ) cos(ϕ)] #2d Rotationsmatrix
R(ϕ, vec::NTuple{2, Float64}) = (cos(ϕ)*vec[1]-sin(ϕ*vec[2]), sin(ϕ)*vec[1]+cos(ϕ)*vec[2])


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

function e_(a::agent, b_pos::NTuple{2, Float64}, system_size::NTuple{2, Float64})
    dx, dy = a.pos.-b_pos

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


function e_(a_pos::NTuple{2, Float64}, b_pos::NTuple{2, Float64}, system_size::NTuple{2, Float64})
    dx, dy = a_pos.-b_pos

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

function d_vec(a::agent, b::agent, system_size::NTuple{2, Float64})

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

    (dx, dy)
end

function d_vec(a::agent, b::element, system_size::NTuple{2, Float64})

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

    (dx, dy)
end

function d_vec(x::NTuple{2, Float64}, a::agent, system_size::NTuple{2, Float64})

    dx, dy = x.-a.pos

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

    (dx, dy)
end

function d_vec(x::NTuple{2, Float64}, a::element, system_size::NTuple{2, Float64})
    dx, dy = x.-a.pos

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

    (dx, dy)
end

function ϕ_(a::agent)

    if a.heading[2] >= 0.0
        acos(a.heading[1])
    else
        2π - acos(a.heading[1]/abs(a.heading))
    end
end

function ϕ_(a::Vector)

    if a[2] >= 0.0
        acos(a[1])
    else
        2π - acos(a[1])
    end
end

function ϕ_(a::NTuple{2, Float64})

    if a[2] >= 0.0
        acos(a[1]/abs(a))
    else
        2π - acos(a[1]/abs(a))
    end
end


function wrap_vector!(a::NTuple{2, Float64}, system_size::NTuple{2, Float64})

    (x, y) = a

    if x > system_size[1]/2
        x = x - system_size[1]
    elseif x < -system_size[1]/2
        x = x + system_size[1]
    end
    if y > system_size[2]/2
        y = y - system_size[2]
    elseif y < -system_size[2]/2
        y = y + system_size[2]
    end

    (x, y)

end

function wrap_normed_vector!(a::NTuple{2, Float64}, system_size::NTuple{2, Float64})

    (x, y) = a

    if x > system_size[1]/2
        x = system_size[1] - x
    end
    if y > system_size[2]/2
        y = system_size[2] - y
    end

    (x, y)

end

function In_Cone(a::agent, b::agent, system_size)

    if ∠_h(a, b, system_size) <= a.ϕ/2 || ∠_h(a, b, system_size) >= 2π - a.ϕ/2 && d(a, b, system_size) <= a.r
        true
    else
        false
    end

end

A_Cone(a::agent) = a.r^2*a.ϕ/2

#calculate the minimal distance to all other geometry and agents
function Min_R(a::agent, menge::crowd, geometrie::geometry, system_size::NTuple{2, Float64})

    r_geo = Min_R_Geometry(a, geometrie, system_size)
    r_agents = Min_R_Agents(a, menge, system_size)

    min(r_geo, r_agents)

end

#calculate the minimal distance to all other agents
function Min_R_Agents(a::agent, menge::crowd, system_size::NTuple{2, Float64})

    r_min = 999.0

    for i in 2:a.neighbors_agents[1]+1

        r_help = d(a, menge.agent[a.neighbors_agents[i]], system_size)
        r_min = min(r_help, r_min)

    end

    r_min
end

#calculate the minimal distance to all geometry
function Min_R_Geometry(a::agent, geometrie::geometry, system_size::NTuple{2, Float64})

    r_min = 999.0

    for i in 2:a.neighbors_geometry[1]+1

        r_help = d(a, geometrie.element[a.neighbors_geometry[i]], system_size)

        r_min = min(r_help, r_min)
    end

    r_min
end


### To round by the absolute value of the vector v_x, v_y for plotting of force
function Round_Velocity(v_x, v_y, ϵ = 0.01)

    if abs((v_x, v_y)) ≤ ϵ

        0.0, 0.0

    else

        v_x, v_y

    end

end

function Round_Velocities(v_xs, v_ys, ϵ = 0.01)

    v_xs_round, v_ys_round = fill(0.0, length(v_xs)), fill(0.0, length(v_xs))

    for i ∈ 1:length(v_xs)

        v_xs_round[i], v_ys_round[i] = Round_Velocity(v_xs[i], v_ys[i], ϵ)

    end

    v_xs_round, v_ys_round

end

function d(a::agent, b::agent, t, system_size)

    #save original positions
    a_pos, b_pos = a.pos, b.pos

    #initialize test positions and calc anticipated distance
    a.pos = a.pos .+ a.heading .* a.vel .* t
    b.pos = b.pos .+ b.heading .* b.vel .* t

    d_ant = d(a, b, system_size)

    #return to actual positions
    a.pos, b.pos = a_pos, b_pos

    d_ant

end

function d_vec(a::agent, b::agent, t, system_size)

    #save original positions
    a_pos, b_pos = a.pos, b.pos

    #initialize test positions and calc anticipated distance
    a.pos = a.pos .+ a.heading .* a.vel .* t
    b.pos = b.pos .+ b.heading .* b.vel .* t

    d_ant = d_vec(a, b, system_size)

    #return to actual positions
    a.pos, b.pos = a_pos, b_pos

    d_ant

end

function e_(a::agent, b::agent, t, system_size)

    #save original positions
    a_pos, b_pos = a.pos, b.pos

    #initialize test positions and calc anticipated distance
    a.pos = a.pos .+ a.heading .* a.vel .* t
    b.pos = b.pos .+ b.heading .* b.vel .* t

    if d(a, b, system_size) == 0

        a.pos = a.pos .+ a.heading .* a.vel .* (t - 0.01)
        b.pos = b.pos .+ b.heading .* b.vel .* (t - 0.01)
    end

    e_ant = e_(a, b, system_size)

    #return to actual positions
    a.pos, b.pos = a_pos, b_pos

    e_ant

end

function d(a::agent, b::element, t, system_size)

    #save original positions
    a_pos = a.pos

    #initialize test positions and calc anticipated distance
    a_pos = a.pos .+ a.heading .* a.vel .* t

    d_ant = d(a, b, system_size)

    #return to actual positions
    a.pos = a_pos

    d_ant

end

function d_vec(a::agent, b::element, t, system_size)

    #save original positions
    a_pos = a.pos

    #initialize test positions and calc anticipated distance
    a.pos = a.pos .+ a.heading .* a.vel .* t

    d_ant = d_vec(a, b, system_size)

    #return to actual positions
    a.pos = a_pos

    d_ant

end

function e_(a::agent, b::element, t, system_size)

    #save original positions
    a_pos = a.pos

    #initialize test positions and calc anticipated distance
    a.pos = a.pos .+ a.heading .* a.vel .* t

    if d(a, b, system_size) == 0
        a.pos = a.pos .+ a.heading .* a.vel .* (t - 0.01)
    end

    e_ant = e_(a, b, system_size)

    #return to actual positions
    a.pos = a_pos

    e_ant

end

RoA(a::agent, b::agent) = -1 .*Δv(a, b)⋅e_(a, b)
RoA(a::agent, b::agent, system_size) = -1 .*Δv(a, b)⋅e_(a, b, system_size)

RoA(a::agent, b::element) = -1 .*v(a)⋅e_(a, b)
RoA(a::agent, b::element, system_size) = -1 .*v(a)⋅e_(a, b, system_size)


;
