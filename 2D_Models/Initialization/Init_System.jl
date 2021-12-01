#Initialize the Parameters TimeGap, Size, Maximal Velocity
function Init_Hom_Parameters!(p::Vector, menge::crowd)

    for x in menge.agent

        x.v_max, x.T, x.l, x.dt_step = p[1], p[2], p[3], p[4]
    end

end

function Init_hom_Goal!(menge, goal)

    for x in menge.agent
        x.goal = goal
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

function overlap(current_agent::Int, menge::crowd, geometrie::geometry, system_size)

    for i in 1:current_agent-1

        if d(menge.agent[current_agent], menge.agent[i], system_size) < l(menge.agent[current_agent], menge.agent[i])
            return true
        end
    end

    for x in geometrie.element

        if d(menge.agent[current_agent], x, system_size) < l(menge.agent[current_agent], x)
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


function Two_Approaching_Crowds(menge::crowd, geometrie::geometry, breite_crowds, N1::Int, system_size)

    if ρ_global(N1, (breite_crowds, system_size[2])) > 7.5
        println("The density is too high!")
    elseif ρ_global(length(menge.agent) - N1, (breite_crowds, system_size[2])) > 7.5
        println("The density is too high!")
    else


        for i in 1:N1
            menge.agent[i].pos = (rand()*breite_crowds , rand()*system_size[2])

            while overlap(i, menge, geometrie, system_size) == true
                menge.agent[i].pos = (rand()*breite_crowds , rand()*system_size[2])
            end

            menge.agent[i].desired_heading, menge.agent[i].heading = (1, 0), (1, 0)
        end

        for i in N1+1:length(menge.agent)
            menge.agent[i].pos = (system_size[1] - rand()*(breite_crowds) ,rand()*system_size[2])

            while overlap(i, menge, geometrie, system_size) == true
                menge.agent[i].pos = (system_size[1] - rand()*breite_crowds,rand()*system_size[2])
            end

            menge.agent[i].desired_heading, menge.agent[i].heading = (-1, 0), (-1, 0)
        end
    end
end


function Init_Hom_Vels!(menge::crowd, vel::Float64)

    for x in menge.agent
        x.vel = vel
    end
end

function Init_Random_Desired_Time_Gaps!(menge::crowd, μ::Float64, σ::Float64)

    func = Truncated(Distributions.Normal(μ, σ), μ-2*σ, μ+2*σ)  #Construct truncated normal distribution

    for x in menge.agent

        x.T = rand(func)

    end

end

function Init_Random_Step_Pos!(menge::crowd)

    for x in menge.agent

        x.step = round(x.dt_step.*rand(), digits = 3)
    end
end
;
