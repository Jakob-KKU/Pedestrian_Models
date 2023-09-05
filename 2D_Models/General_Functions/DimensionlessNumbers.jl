r_soc(a::agent, b::agent, system_size) = 0.8
r_soc(a::agent, b::element, system_size) = 0.5


IN(a::agent, b::element, system_size) = ((r_soc(a, b, system_size) - 0.1)/(d(a, b, system_size)  - 0.1))^2

function IN(a::agent, b::agent, system_size, ϵ = 0.05)

    if  d(a, b, system_size)-l(a, b) < ϵ
        ((r_soc(a, b, system_size) - 2/3*l(a, b))/ϵ)^2*(1 + 2 + 2/ϵ*(2/3*l(a, b) - d(a, b, system_size)))
    else
      ((r_soc(a, b, system_size) - 2/3*l(a, b))/(d(a, b, system_size)  - 2/3*l(a, b)))^2
    end

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
