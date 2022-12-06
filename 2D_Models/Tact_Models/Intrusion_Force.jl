#r_soc(a::agent, b::agent, system_size) = 0.6
r_soc(a::agent, b::element, system_size) = 0.3

#r_soc(a::agent, b::agent, system_size) = (1.4-0.1)/2*(cos(∠_h(a, b, system_size))+1)+0.1

#function IN(a::agent, b::agent, system_size)
#    d_ = d(a, b, system_size)
#    l_eff = 2/3*l(a, b)
#    if d_ <= l_eff
#        9999999999999999999999999999999999999999999999999999.9
#    else
#        ((r_soc(a, b, system_size) - l_eff)/(d_ - l_eff))
#    end
#end
IN(a::agent, b::element, system_size) = ((r_soc(a, b, system_size) - 2/3*l(a, b))/(d(a, b, system_size)  - 2/3*l(a, b)))

IN(a::agent, b::agent, system_size) = ((r_soc(a, b, system_size) - 2/3*l(a, b))/(d(a, b, system_size)  - 2/3*l(a, b)))
#IN(a::agent, b::element, system_size) = ((r_soc(a, b, system_size) - 0.1)/(d(a, b, system_size)  - 0.1))
r_soc(a::agent, b::agent, system_size) = 0.8#(1.4-0.1)/2*(cos(∠_h(a, b, system_size))+1)+0.1

#IN(a::agent, b::agent, system_size) = (r_soc(a, b, system_size) - 0.1)/(d(a, b, system_size) - 0.1)




function IN(a::agent, menge::crowd, system_size)

    in_ = 0.0

    for i in 2:a.neighbors_agents[1]+1

        b = menge.agent[a.neighbors_agents[i]]

        in_ += IN(a, b, system_size)

    end

    in_

end

function ∇IN(a::agent, b::agent, system_size)

        h = 0.00001

        IN_0 = IN(a, b, system_size)

        a.pos = a.pos .+ h .*(1.0, 0.0)

        IN_x = IN(a, b, system_size)

        a.pos = a.pos .- h .*(1.0, 0.0)  .+ h .*(0.0, 1.0)

        IN_y = IN(a, b, system_size)

        a.pos = a.pos .- h .*(0.0, 1.0)

        ((IN_x, IN_y) .- IN_0)./h
end

function ∇IN(a::agent, menge::crowd, system_size)

    ∇in_ = (0.0, 0.0)

    for i in 2:a.neighbors_agents[1]+1

        b = menge.agent[a.neighbors_agents[i]]

        ∇in_ = ∇in_ .+ ∇IN(a, b, system_size)

    end

    ∇in_

end

function ∇IN(a::agent, geometrie::geometry, system_size)

    ∇in_ = (0.0, 0.0)

    for i in 2:a.neighbors_geometry[1]+1

        b = geometrie.element[a.neighbors_geometry[i]]

        ∇in_ = ∇in_ .+ ∇IN(a, b, system_size)

    end

    ∇in_

end


function ∇IN(a::agent, b::element, system_size)

        h = 0.00001

        IN_0 = IN(a, b, system_size)

        a.pos = a.pos .+ h .*(1.0, 0.0)

        IN_x = IN(a, b, system_size)

        a.pos = a.pos .- h .*(1.0, 0.0)  .+ h .*(0.0, 1.0)

        IN_y = IN(a, b, system_size)

        a.pos = a.pos .- h .*(0.0, 1.0)

        ((IN_x, IN_y) .- IN_0)./h
end


function Update_Pref_Velocity!(a::agent, menge::crowd, geometrie::geometry, system_size::NTuple{2, Float64})

    v_new = a.v_des .* a.e_des .- a.α .* ∇IN(a, menge, system_size) .- 0.1 .* a.α .* ∇IN(a, geometrie, system_size)
    #v_new =  .- a.α .* ∇IN(a, menge, system_size) .- 0.1 .* a.α .* ∇IN(a, geometrie, system_size)

    a.v_pref = min(a.v_max, abs(v_new))
    a.e_pref = normalize(v_new)

end
