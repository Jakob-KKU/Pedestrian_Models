#Initialize the Parameters TimeGap, Size, Maximal Velocity
function initialize_homogeneous_parameters(p::Vector, menge::crowd)

    agent_parameters = parameters(p[1], p[2], p[3], p[4], p[5])

    for x in menge.agent
        x.parameters = agent_parameters
    end

end



#initialize positions
function overlap(current_agent::Int, menge::crowd)

    for i in 1:current_agent-1

        if d(menge.agent[current_agent], menge.agent[i]) < l(menge.agent[current_agent], menge.agent[i])
            return true
        end
    end

    false
end

#initialize positions
function overlap(current_agent::Int, menge::crowd, geometrie::geometry)

    for i in 1:current_agent-1

        if d(menge.agent[current_agent], menge.agent[i]) < l(menge.agent[current_agent], menge.agent[i])
            return true
        end
    end

    for x in geometrie.element

        if d(menge.agent[current_agent], x) < l(menge.agent[current_agent], x)
            return true
        end
    end

    false
end

#Ordne den Agenten zufällige Positionen zu
function initialize_random_positions(x::NTuple{2, Float64}, y::NTuple{2, Float64}, menge::crowd)

    for (i, agent) in enumerate(menge.agent)

       agent.pos = (x[1] + rand()*(x[2]-x[1]) , y[1] + rand()*(y[2]-y[1]))

        while overlap(i, menge) == true
            agent.pos = (x[1] + rand()*(x[2]-x[1]) , y[1] + rand()*(y[2]-y[1]))
        end

    end
end

# if the system starts at (0, 0) i.e. x_{min}
function initialize_random_positions(system_size::NTuple{2, Float64}, menge::crowd)

    if ρ_global(menge, system_size) > 7.5
        println("The density is too high!")
        false
    end

    for (i, agent) in enumerate(menge.agent)

       agent.pos = rand()*system_size[1] , rand()*system_size[2]

        while overlap(i, menge) == true
            agent.pos = rand()*system_size[1] , rand()*system_size[2]
        end

    end
end

# if the system starts at (0, 0) i.e. x_{min}
function initialize_random_positions(system_size::NTuple{2, Float64}, menge::crowd, geometrie::geometry)

    if ρ_global(menge, system_size, geometrie) > 7.5
        println("The density is too high!")
        false
    end

    for (i, agent) in enumerate(menge.agent)

       agent.pos = rand()*system_size[1] , rand()*system_size[2]

        while overlap(i, menge, geometrie) == true
            agent.pos = rand()*system_size[1] , rand()*system_size[2]
        end

    end
end

#Ordne den Agenten zufällige desired Headings zu
function initialize_random_headings(menge::crowd)
    for agent in menge.agent
        agent.desired_heading = random_heading()
        agent.heading = agent.desired_heading
    end
end

function random_heading()
    help_var = -1 + 2*rand()
    (help_var, sqrt(1 - help_var^2)*rand([-1, +1]))
end
;
