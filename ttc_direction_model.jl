function Calc_Headings!(menge::crowd, geometrie::geometry, temp_headings,
        system_size::NTuple{2, Float64})

    for (i,x) in enumerate(menge.agent)

         temp_headings[i]  = Calc_Heading_TTC(x, menge, geometrie, system_size)

    end

    temp_headings

end

function Calc_Heading_TTC(a::agent, menge::crowd, geometrie::geometry, system_size::NTuple{2, Float64})


    min_ttc_p, min_ttc_m = Min_TTC(a, a.desired_heading, menge, geometrie, system_size), 0.0
    a_heading_p, a_heading_m, ϕ_return, ttc_min = (0.0, 0.0), (0.0, 0.0), 0.0, 0.0


    for Δϕ in 0.0:0.01:π

        #rotate to the left
        min_ttc_p = Min_TTC(a, R(Δϕ)⋅a.desired_heading, menge, geometrie, system_size)

        #rotate to the right
        min_ttc_m = Min_TTC(a, R(-Δϕ)⋅a.desired_heading, menge, geometrie, system_size)

        if min_ttc_p > a.T
            ϕ_return = Δϕ
            break
        elseif min_ttc_m > a.T
            ϕ_return = -Δϕ
            break
        elseif min_ttc_p > min_ttc_m && min_ttc_p > ttc_min
            ttc_min, ϕ_return  = min_ttc_p, Δϕ
        elseif min_ttc_m > min_ttc_p && min_ttc_m > ttc_min
            ttc_min, ϕ_return  = min_ttc_m, -Δϕ
        end

    end

    return R(ϕ_return)⋅a.desired_heading

end
