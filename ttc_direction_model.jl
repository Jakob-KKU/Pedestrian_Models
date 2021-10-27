function Calc_Headings!(menge::crowd, geometrie::geometry, temp_headings,
        system_size::NTuple{2, Float64})

    for (i,x) in enumerate(menge.agent)

         temp_headings[i]  = Calc_Heading_TTC(x, menge, geometrie, system_size)

    end

    temp_headings

end

function Calc_Heading_TTC(a::agent, menge::crowd, geometrie::geometry, system_size::NTuple{2, Float64})


    min_ttc_p, min_ttc_m = Min_TTC(a, a.desired_heading, menge, geometrie, system_size), 0.0

    a_heading_p, a_heading_m, Δϕ = (0.0, 0.0), (0.0, 0.0), 0.0

    while min_ttc_p < a.T && min_ttc_m < a.T && Δϕ < π

        Δϕ+= 0.01*π

        #rotate to the left
        a_heading_p = R(Δϕ)⋅a.desired_heading
        min_ttc_p = Min_TTC(a, a_heading_p, menge, geometrie, system_size)

        #rotate to the right
        a_heading_m = R(-Δϕ)⋅a.desired_heading
        min_ttc_m = Min_TTC(a, a_heading_m, menge, geometrie, system_size)

    end

    if Δϕ==0.0
        a.desired_heading
    elseif min_ttc_p < min_ttc_m
        a_heading_m
    else
        a_heading_p
    end

end
