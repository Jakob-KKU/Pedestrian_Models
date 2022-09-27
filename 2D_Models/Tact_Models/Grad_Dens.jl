function Calc_e_pref(a::agent, menge::crowd, geometrie::geometry, system_size::NTuple{2, Float64})

    x = a.pos .+ (0.0*a.l/2 + a.vel/2 ) .*a.heading

    ∇ρ = ∇ρ_gauss(x, a, menge, geometrie, system_size)
    #println(abs(∇ρ))


    if abs(∇ρ) < a.r

        a.e_des

    else

        normalize(a.e_des .+ a.α .* ∇ρ)

    end

end

function Calc_V_pref(a::agent, menge::crowd, geometrie::geometry, system_size::NTuple{2, Float64})

    #if a.e_pref == a.e_des#(0.0, 0.0)

    #    0.0

    #else

        x = a.pos .+ (0.0*a.l/2 + a.vel/2 ).*a.heading

        #0.25
        max(0.0, min((1/sqrt(ρ_gauss(x, a, menge, geometrie, system_size))-a.l)/a.T2, a.v_max))

    #end

end

function Update_Pref_Velocity!(a::agent, menge::crowd, geometrie::geometry, system_size::NTuple{2, Float64})

    a.e_pref = Calc_e_pref(a, menge, geometrie, system_size)
    a.v_pref = Calc_V_pref(a, menge, geometrie, system_size)

end
