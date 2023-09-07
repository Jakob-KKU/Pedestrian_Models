#r_soc(a::agent, b::agent, system_size) = a.r
#r_soc(a::agent, b::element, system_size) = a.r/2


IN(a::agent, b::element, system_size) = ((a.r/2 - 0.1)/(d(a, b, system_size)  - 0.1))^2

function IN(a::agent, b::agent, system_size, ϵ = 0.01)

    if  d(a, b, system_size)-2/3*l(a, b) < ϵ
        g(a, b, system_size, ϵ)
    else
      ((a.r - 2/3*l(a, b))/(d(a, b, system_size)  - 2/3*l(a, b)))^2
    end

end

function g(a, b, system_size, ϵ = 0.01)

    - 2 * d(a, b, system_size)*(a.r - 2/3*l(a, b))^2/ϵ^3 +
    ((a.r-2/3*l(a, b))/ϵ)^2 + 2*(2/3*l(a, b)+ϵ)*(a.r-2/3*l(a, b))^2/ϵ^3

end

function IN(a::agent, menge::crowd, geometrie::geometry, system_size)

    IN(a, menge, system_size) + IN(a, geometrie, system_size)

end


function IN(a::agent, menge::crowd, system_size)

    in_ = 0.0

    for i in 2:a.neighbors_agents[1]+1

        b = menge.agent[a.neighbors_agents[i]]

        in_ += IN(a, b, system_size)

    end

    in_

end

function IN(a::agent, geometrie::geometry, system_size)

    in_ = 0.0

    for i in 2:a.neighbors_geometry[1]+1

        b = geometrie.element[a.neighbors_geometry[i]]

        in_ += IN(a, b, system_size)

    end

    in_

end

function AV(a::agent, menge::crowd, geometrie::geometry, system_size)

    a.T/Min_TTC(a, menge, geometrie, system_size)

end
;
