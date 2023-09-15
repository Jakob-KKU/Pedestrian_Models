##### UNDER CONSTRUCTION #######

function ϕ(a::agent, menge::crowd, system_size)

    ϕ_ = 0.0

    for i in 2:a.neighbors_agents[1]+1

        b = menge.agent[a.neighbors_agents[i]]

        ϕ_ += ϕ(a, b, system_size)

    end

    ϕ_

end

function ϕ(a::agent, geometrie::geometry, system_size)

    ϕ_ = 0.0

    for i in 2:a.neighbors_geometry[1]+1

        b = geometrie.element[a.neighbors_geometry[i]]

        ϕ_ += ϕ(a, b, system_size)

    end

    ϕ_

end

function  ϕ(a::agent, menge::crowd, geometrie::geometry, system_size)

     ϕ(a, menge, system_size) +  ϕ(a, geometrie, system_size)

end

Effective_Distance(a::agent, b::agent) = 0.5*sqrt((d(a,b) + abs((a.pos.-b.pos).-v(b).*a.τ_A))^2-abs(v(b).*a.τ_A)^2)


Effective_Distance(a::agent, b::agent, system_size) = 0.5*sqrt((d(a,b, system_size) +
        abs(d_vec(a, b, system_size).-v(b).*a.τ_A))^2-abs(v(b).*a.τ_A)^2)

Effective_Distance2(a::agent, b::agent) = 0.5*sqrt((d(a,b) + abs((a.pos.-b.pos).-(v(b).-v(a)).*a.τ_A))^2-
            abs((v(b).-v(a)).*a.τ_A)^2)

Effective_Distance2(a::agent, b::agent, system_size) = 0.5*sqrt((d(a,b,system_size) +
        abs(d_vec(a, b, system_size).-(v(b).-v(a)).*a.τ_A))^2 - abs((v(b).-v(a)).*a.τ_A)^2)


Effective_Distance(a::agent, b::element) = d(a,b)

Effective_Distance(a::agent, b::element, system_size) = d(a,b, system_size)

Effective_Distance2(a::agent, b::element) = 0.5*sqrt((d(a,b) + abs((a.pos.-b.pos).+v(a).*a.τ_A))^2-
            abs(v(a).*a.τ_A)^2)

Effective_Distance2(a::agent, b::element, system_size) = 0.5*sqrt((d(a,b,system_size) +
        abs(d_vec(a, b, system_size).+v(a).*a.τ_A))^2 - abs(v(a).*a.τ_A)^2)



ϕ2(a::agent, b::agent, system_size) = a.α * a.r * exp(-Effective_Distance(a, b, system_size)/a.r)
ϕ(a::agent, b::agent, system_size) = a.α * a.r * exp(-Effective_Distance(a, b, system_size)/a.r)

ϕ2(a::agent, b::agent) = a.α * a.r * exp(-Effective_Distance(a, b)/a.r)
ϕ(a::agent, b::agent) = a.α * a.r * exp(-Effective_Distance(a, b)/a.r)

ϕ2(a::agent, b::element, system_size) = a.α * a.r * exp(-Effective_Distance(a, b, system_size)/a.r)
ϕ(a::agent, b::element, system_size) = a.α * a.r * exp(-Effective_Distance(a, b, system_size)/a.r)

ϕ2(a::agent, b::element) = a.α * a.r * exp(-Effective_Distance(a, b)/a.r)
ϕ(a::agent, b::element) = a.α * a.r * exp(-Effective_Distance(a, b)/a.r)
