function Calc_Heading_Velocity(a::agent, menge::crowd, geometrie::geometry, system_size)

    Calc_Heading(a, menge, geometrie, system_size), Calc_Velocity(a, menge, geometrie, system_size)

end

function Calc_Heading(a::agent, menge::crowd, geometrie::geometry, system_size)

    normalize(a.e_pref .+ F(a, menge, system_size))

end

function F(a::agent, menge::crowd, geometrie::geometry, system_size)

    F(a, menge, system_size) .+ F(a, geometrie, system_size)

end


function F(a::agent, menge::crowd, system_size)

    F_ = (0.0, 0.0)

    for i in 2:a.neighbors_agents[1]+1

        b = menge.agent[a.neighbors_agents[i]]

        F_ = F_ .+ F(a, b, system_size)

    end

    F_

end

function F(a::agent, geometrie::geometry, system_size)

    F_ = (0.0, 0.0)

    for i in 2:a.neighbors_geometry[1]+1

        b = geometrie.element[a.neighbors_geometry[i]]

        F_ = F_ .+ F(a, b, system_size)

    end

    F_

end

F(a::agent, b::agent, system_size) = α_(a,b,system_size)*exp(-(s(a, b, system_size)-l(a, b))/a.r).*dir(a, b, system_size)

α_(a::agent, b::agent, system_size) = a.α * (1 + (1-(a.e_pref⋅b.heading))/2)

s(a::agent, b::agent, system_size) = max(l(a,b), d_vec(a, b, a.τ_A, system_size)⋅e_(a, b, system_size))

function dir(a::agent, b::agent, system_size)

    help_ = e_XU(a, b, a.τ_A, system_size)⋅⟂(a.e_pref)

    if help_ == 0

        rand([-1, 1]) .* ⟂(a.e_pref)

    else

        sign(help_) .* ⟂(a.e_pref)

    end

end

function e_XU(a::agent, b::agent, t, system_size)

    #save original positions
    b_pos = b.pos

    #initialize test positions and calc anticipated distance
    b.pos = b.pos .+ b.heading .* b.vel .* t

    if d(a, b, system_size) == 0

        b.pos = b.pos .+ b.heading .* b.vel .* (t - 0.01)

    end

    e_ant = e_(a, b, system_size)

    #return to actual positions
    b.pos = b_pos

    e_ant

end

F(a::agent, b::element, system_size) =  0.1*a.α*exp(-(d(a, b, system_size)-l(a, b))/a.r).*e_(a, b, system_size)

function Calc_Velocity(a::agent, menge::crowd, geometrie::geometry, system_size::NTuple{2, Float64})

    d_ = Min_R_in_Front(a, menge, geometrie, system_size)

    clamp((d_-a.l)/(a.T2), 0.0, a.v_max)

end

function Min_R_in_Front(a::agent, menge::crowd, geometrie::geometry, system_size::NTuple{2, Float64})

    d_ = 999.9

    for i in 2:a.neighbors_agents[1]+1

        b = menge.agent[a.neighbors_agents[i]]

        if TimeGap(a, b, system_size) <= 999.0
            d_ = min(d(a, b, system_size), d_)
        end

    end

    for i in 2:a.neighbors_geometry[1]+1

        b = geometrie.element[a.neighbors_geometry[i]]

        if TimeGap(a, b, system_size) <= 999.0
            d_ = min(d(a, b, system_size), d_)
        end
    end

    d_

end

p = [1.7, 1.7, 0.0, 1.0, 0.0, 2*0.18, 1.0, 0.3, 3.0, 0.0, 0.0, 0.0, 0.1, 0.0]
# ModelParameter: v_max, v_des, T, T2, l, step_time, τ_A, τ_R, α, β, ζ_h, ζ_v, r, ϕ
p_desc = "v_max, v_des, T, T2, l, step_time, τ_A, τ_R, α, β, ζ_h, ζ_v, r, ϕ"


println("The following parameters were given in xu_AnticipationVelocitybasedModel_2021:")
println(p)
println(p_desc)
