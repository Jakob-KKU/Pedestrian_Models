#### INCOMPLETE! ####

function Calc_v_des(a::agent, menge::crowd, geometrie::geometry, system_size::NTuple{2, Float64})

    opt, v_des = 99.0, a.v_des.*a.e_des
    τ = 0.5



    for ϕ in -π/3:0.3:π/3

        v_des_ = V_des(a, ϕ, menge, system_size)
        opt_ = abs(a.e_des*10.0 - v_des*τ)

        if opt_ < opt

            opt, v_des = opt_, v_des_

        end

    end

    a.desired_heading = v_des ./ abs(v_des)



end

function V_des(a, ϕ, menge, system_size)


end

function d_DS(a, menge, system_size)

    ρ_eff, σ = 0.0, 1.5


    for i in 2:a.neighbors_agents[1]+1

        b = menge.agent[a.neighbors_agents[i]]
        d_eff = abs(d_nod(a, b, system_size))

        ρ_eff += Gaussian(d_eff, σ)

    end

    a.l/ρ_eff

end




d_vec(a, b, system_size) = d(a, b, system_size).*e_(a, b, system_size)
d_y(a, b, system_size) = (d_vec(a, b, system_size)⋅a.desired_heading).*a.v_des
d_nod(a, b, system_size) = 2.5 .*(d_vec(a, b, system_size) .- d_y(a, b, system_size)).+d_y(a, b, system_size)
Gaussian(x, σ) = 1/(2π*σ)*exp(x^2/(2*σ^2))
