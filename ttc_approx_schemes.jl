function v_approx(a::agent, b::agent, menge::crowd, approx_scheme)

    model = string("v_approx_" ,approx_scheme)
    u = getfield(Main, Symbol(model))

    u(a, b, menge, system_size)
end

v_approx_ρ_global(a::agent, b::agent, menge::crowd, system_size) = ov(b, 1/sqrt(ρ_global(menge, system_size)))

v_approx_α(a::agent, b::agent, menge::crowd, system_size) = α*b.vel

v_approx_α_ρ(a::agent, b::agent, menge::crowd, system_size) = (1-ρ_global(menge, system_size)/ρ_max(system_size, menge))*b.vel

v_approx_voronoi(a::agent, b::agent, menge::crowd, system_size) = ov(b, 1/sqrt(b.voronoi_dens))

v_approx_α_voronoi(a::agent, b::agent, menge::crowd, system_size) = (1-b.voronoi_dens*(pi*b.parameters.l^2/4))*b.vel

v_approx_Δx(a::agent, b::agent, menge::crowd, geometrie::geometry, system_size) = ov(b, minimum_distance_in_front(b, menge, geometrie, system_size))
