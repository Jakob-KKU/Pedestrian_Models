#Initialize the Parameters TimeGap, Size, Maximal Velocity
function Init_Hom_Parameters!(p::Vector, menge::crowd)

    for x in menge.agent

        x.v_max, x.v_des, x.T, x.T2, x.l, x.dt_step, x.τ_A, x.τ_R, x.α, x.β, x.ζ_h, x.ζ_v, x.r, x.ϕ =
            p[1], p[2], p[3], p[4], p[5], p[6], p[7], p[8], p[9], p[10], p[11], p[12], p[13], p[14]

    end

end

function Init_hom_Goal!(menge, goal)

    for x in menge.agent
        x.goal = goal
    end
end

function Init_E_des!(menge::crowd, dir)

    for a in menge.agent
        a.e_des = dir
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

function Too_Close(current_agent::Int, menge::crowd, geometrie::geometry, system_size)

    for i in 1:current_agent-1

        if d(menge.agent[current_agent], menge.agent[i], system_size) < 2*l(menge.agent[current_agent], menge.agent[i])
            return true
        end
    end

    for x in geometrie.element

        if d(menge.agent[current_agent], x, system_size) < 2*l(menge.agent[current_agent], x)
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

function Random_Pos_In_Rectangle(P1, P2, N_min::Int, N_max::Int, menge::crowd, heading, system_size, geometrie)

        for i in N_min:N_max

            menge.agent[i].pos = (P1[1] + rand()*(P2[1]-P1[1]) , P1[2] + rand()*(P2[2]-P1[2]))

            while overlap(i, menge, geometrie, system_size) == true
                menge.agent[i].pos = (P1[1] + rand()*(P2[1]-P1[1]) , P1[2] + rand()*(P2[2]-P1[2]))
            end

            menge.agent[i].e_des, menge.agent[i].heading = heading, heading
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
function Init_Random_Headings!(menge::crowd)
    for agent in menge.agent
        #agent.e_des = random_heading()
        agent.heading = random_heading()
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

            menge.agent[i].e_des, menge.agent[i].heading = (1, 0), (1, 0)
        end

        for i in N1+1:length(menge.agent)
            menge.agent[i].pos = (system_size[1] - rand()*(breite_crowds) ,rand()*system_size[2])

            while overlap(i, menge, geometrie, system_size) == true
                menge.agent[i].pos = (system_size[1] - rand()*breite_crowds,rand()*system_size[2])
            end

            menge.agent[i].e_des, menge.agent[i].heading = (-1, 0), (-1, 0)
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

function Init_Random_V_max!(menge::crowd, μ::Float64, σ::Float64)

    func = Truncated(Distributions.Normal(μ, σ), μ-2*σ, μ+2*σ)  #Construct truncated normal distribution

    for x in menge.agent

        x.v_max = rand(func)

    end

end

function Init_Random_Step_Pos!(menge::crowd)

    for x in menge.agent

        x.step = round(x.dt_step.*rand(), digits = 3)
    end
end


function Init_N_Agents_Bottleneck!(menge, system_size, a)

     initialize_random_positions((0.0, system_size[1]), (0.0, a), menge::crowd)

end

function Init_Random_αs!(menge::crowd, μ::Float64, σ::Float64)

    func = Truncated(Distributions.Normal(μ, σ), μ-2*σ, μ+2*σ)  #Construct truncated normal distribution

    for x in menge.agent

        x.α = rand(func)

    end

end

function Init_Random_τ_Rs!(menge::crowd, μ::Float64, σ::Float64)

    func = Truncated(Distributions.Normal(μ, σ), μ-2*σ, μ+2*σ)  #Construct truncated normal distribution

    for x in menge.agent

        x.τ_R = rand(func)

    end
end

function Init_N_Agents_Bottleneck!(menge, systemsize, a)

     initialize_random_positions((0.0, systemsize[1]), (0.0, a), menge::crowd)

end

function Init_Rand_Rect!(a0, a, b0, b, menge::crowd, geometrie::geometry)

    if ρ_global(menge, system_size, geometrie) > 7.5
        println("The density is too high!")
        false
    end

    for (i, agent) in enumerate(menge.agent)

       agent.pos = rand()*a+a0 , rand()*b+b0

        while overlap(i, menge, geometrie) == true
           agent.pos = rand()*a+a0 , rand()*b+b0
        end

    end
end

function Init_CrossSection_Crowds!(menge::crowd, geometrie::geometry, l1, l2 ,system_size)

    N = length(menge.agent)
    ΔN = Int(round(N/4))

    #left
    for i in 1:ΔN
        menge.agent[i].pos = (rand()*l1 , rand()*l2+l1)

        while overlap(i, menge, geometrie, system_size) == true
            menge.agent[i].pos = (rand()*l1 , rand()*l2+l1)
        end

        menge.agent[i].e_des, menge.agent[i].heading = (1.0, 0), (1.0, 0)
    end

    #bottom
    for i in ΔN+1:2*ΔN
        menge.agent[i].pos = (rand()*l2 + l1 , rand()*l1)

        while overlap(i, menge, geometrie, system_size) == true
            menge.agent[i].pos =  (rand()*l2 + l1 , rand()*l1)
        end

        menge.agent[i].e_des, menge.agent[i].heading = (0.0, 1.0), (0.0, 1.0)
    end

    #right
    for i in 2*ΔN+1:3*ΔN
        menge.agent[i].pos = (l1+l2+rand()*l1 , rand()*l2+l1)

        while overlap(i, menge, geometrie, system_size) == true
            menge.agent[i].pos =(l1+l2+rand()*l1 , rand()*l2+l1)
        end

        menge.agent[i].e_des, menge.agent[i].heading = (-1.0, 0), (-1.0, 0)
    end

    #top
    for i in 3*ΔN+1:N
        menge.agent[i].pos = (rand()*l2 + l1 , rand()*l1+l1+l2)

        while overlap(i, menge, geometrie, system_size) == true
            menge.agent[i].pos = (rand()*l2 + l1 , rand()*l1+l1+l2)
        end

        menge.agent[i].e_des, menge.agent[i].heading = (0.0, -1.0), (0.0, -1.0)
    end

end

function Init_CrossSection_Crowds!(menge::crowd, geometrie::geometry, l1, l2, system_size, d_goal)

    N = length(menge.agent)
    ΔN = Int(round(N/4))
    a = 0.35


    #left
    for i in 1:ΔN
        menge.agent[i].pos = ((i-1)*l1/ΔN+a*rand(), a*(rand()-0.5)*l2+l1+l2/2)

        while Too_Close(i, menge, geometrie, system_size) == true
            menge.agent[i].pos = ((i-1)*l1/ΔN+a*(rand()-0.5) , a*(rand()-0.5)*l2+l1+l2/2)
        end

        menge.agent[i].e_des, menge.agent[i].heading = (1.0, 0), (1.0, 0)
        menge.agent[i].goal = (system_size[1]/2 + d_goal, menge.agent[i].pos[2])
    end

    #bottom
    for i in ΔN+1:2*ΔN
        ind = i - ΔN
        menge.agent[i].pos = (a*(rand()-0.5)*l2+l1+l2/2 , (ind-1)*l1/ΔN+a*rand())

        while Too_Close(i, menge, geometrie, system_size) == true
            menge.agent[i].pos =  (a*(rand()-0.5)*l2+l1+l2/2 , (ind-1)*l1/ΔN+a*(rand()-0.5))
        end

        menge.agent[i].e_des, menge.agent[i].heading = (0.0, 1.0), (0.0, 1.0)
        menge.agent[i].goal = (menge.agent[i].pos[1], system_size[2]/2 + d_goal)

    end

    #right
    for i in 2*ΔN+1:3*ΔN
        ind = i - 2*ΔN
        menge.agent[i].pos = (l1+l2+(ind-1)*l1/ΔN+a*(rand()-0.5) , a*(rand()-0.5)*l2+l1+l2/2)

        while Too_Close(i, menge, geometrie, system_size) == true
            menge.agent[i].pos =(l1+l2+(ind-1)*l1/ΔN+a*(rand()-0.5) ,  a*(rand()-0.5)*l2+l1+l2/2)
        end

        menge.agent[i].e_des, menge.agent[i].heading = (-1.0, 0), (-1.0, 0)
        menge.agent[i].goal = (system_size[1]/2-d_goal, menge.agent[i].pos[2])

    end

    #top
    for i in 3*ΔN+1:N
        ind = i - 3*ΔN
        menge.agent[i].pos = (a*(rand()-0.5)*l2+l1+l2/2 , (ind-1)*l1/ΔN+a*(rand()-0.5)+l1+l2)

        while Too_Close(i, menge, geometrie, system_size) == true
            menge.agent[i].pos = (a*(rand()-0.5)*l2+l1+l2/2 , (ind-1)*l1/ΔN+a*(rand()-0.5)+l1+l2)
        end

        menge.agent[i].e_des, menge.agent[i].heading = (0.0, -1.0), (0.0, -1.0)
        menge.agent[i].goal = (menge.agent[i].pos[1],system_size[2]/2 + -d_goal)

    end

end

function Init_CrossSection_Crowds2!(menge::crowd, geometrie::geometry, l1, l2, system_size, d_goal)

    N = length(menge.agent)
    ΔN = Int(round(N/4))

    #left
    for i in 1:ΔN
        menge.agent[i].pos = (l1*rand(), rand()*l2+l1)

        while Too_Close(i, menge, geometrie, system_size) == true
            menge.agent[i].pos = (l1*rand(), rand()*l2+l1)
        end

        menge.agent[i].e_des, menge.agent[i].heading = (1.0, 0), (1.0, 0)
        menge.agent[i].goal = (system_size[1]/2 + d_goal, menge.agent[i].pos[2])
    end

    #bottom
    for i in ΔN+1:2*ΔN
        ind = i - ΔN
        menge.agent[i].pos = (rand()*l2+l1 , l1*rand())

        while Too_Close(i, menge, geometrie, system_size) == true
            menge.agent[i].pos =  (rand()*l2+l1 , l1*rand())
        end

        menge.agent[i].e_des, menge.agent[i].heading = (0.0, 1.0), (0.0, 1.0)
        menge.agent[i].goal = (menge.agent[i].pos[1], system_size[2]/2 + d_goal)

    end

    #right
    for i in 2*ΔN+1:3*ΔN
        ind = i - 2*ΔN
        menge.agent[i].pos = (l1+l2+l1*rand() , rand()*l2+l1)

        while Too_Close(i, menge, geometrie, system_size) == true
            menge.agent[i].pos = (l1+l2+l1*rand() , rand()*l2+l1)
        end

        menge.agent[i].e_des, menge.agent[i].heading = (-1.0, 0), (-1.0, 0)
        menge.agent[i].goal = (system_size[1]/2-d_goal, menge.agent[i].pos[2])

    end

    #top
    for i in 3*ΔN+1:N
        ind = i - 3*ΔN
        menge.agent[i].pos = (rand()*l2+l1, l1*rand()+l1+l2)

        while Too_Close(i, menge, geometrie, system_size) == true
            menge.agent[i].pos = (rand()*l2+l1, l1*rand()+l1+l2)
        end

        menge.agent[i].e_des, menge.agent[i].heading = (0.0, -1.0), (0.0, -1.0)
        menge.agent[i].goal = (menge.agent[i].pos[1],system_size[2]/2 - d_goal)

    end

end





;
