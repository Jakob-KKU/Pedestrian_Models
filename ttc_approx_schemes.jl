function v_approx(a::agent, b::agent, menge::crowd, approx_scheme)

    model = string("v_approx_" ,approx_scheme)
    u = getfield(Main, Symbol(model))

    u(a, b, menge, system_size)
end

v_approx_ρ_global(a::agent, b::agent, menge::crowd, system_size) = ov(b, 1/sqrt(ρ_global(menge, system_size)))

v_approx_α(a::agent, b::agent, menge::crowd, system_size) = α*b.vel
