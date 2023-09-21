mutable struct agent

    pos::NTuple{2, Float64}
    heading::NTuple{2, Float64}
    vel::Float64
    step::Float64

    v_pref::Float64
    e_pref::NTuple{2, Float64}
    goal::NTuple{2, Float64}
    e_des::NTuple{2, Float64}
    v_des::Float64
    neighbors_agents::Vector{Int}
    neighbors_geometry::Vector{Int}
    voronoi_dens::Float64

    v_max::Float64
    T::Float64
    T2::Float64
    l::Float64
    dt_step::Float64
    τ_A::Float64
    τ_R::Float64
    α::Float64
    β::Float64
    ζ_h::Float64
    ζ_v::Float64
    r::Float64
    λ::Float64
end

struct crowd
    agent::Array{agent, 1}
end

struct element
    pos::NTuple{2, Float64}
    l::Float64
end

struct geometry
    element::Array{element, 1}
end


function create_crowd(N::Int, geometrie::geometry)
    crowd([agent((0.0, 0.0), (0.0, 0.0), 0.0, 0.0, 0.0, (0.0, 0.0),  (0.0, 0.0), (0.0, 0.0), 0.0, fill(0, N+1),
     fill(0, length(geometrie.element)+1), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0) for i in 1:N])
end
;
