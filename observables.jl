L_mean(menge::crowd) = sum([x.parameters.l for x in menge.agent])/N_(menge)
L_mean(geometrie::geometry) = sum([x.l for x in geometrie.element])/N_(geometrie)
A_mean(menge::crowd) = L_mean(menge)^2*pi/4
A_mean(geometrie::geometry) = L_mean(geometrie)^2*pi/4
N_(menge::crowd) = length(menge.agent)
N_(geometrie::geometry) = length(geometrie.element)

ρ_global(menge::crowd, system_size::NTuple{2, Float64}, geometrie::geometry) = N_(menge)/(system_size[1]*system_size[2] - N_(geometrie)*A_mean(geometrie))
ρ_global(menge::crowd, system_size::NTuple{2, Float64}) = N_(menge)/(system_size[1]*system_size[2])
