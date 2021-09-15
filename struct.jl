
mutable struct agent

    pos::NTuple{2, Float64}
    heading::NTuple{2, Float64}
    vel::Float64
    goal::NTuple{2, Float64}
    desired_heading::NTuple{2, Float64}
    neighbors_agents::Vector{Int}
    neighbors_geometry::Vector{Int}
    voronoi_dens::Float64

    v_max::Float64
    T::Float64
    l::Float64
    interaction_length::Float64
    interaction_strength::Float64


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
    crowd([agent((0.0, 0.0), (0.0, 0.0), 0.0, (0.0, 0.0), (0.0, 0.0), fill(0, N+1),
     fill(0, length(geometrie.element)+1), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0) for i in 1:N])
end

function set_parameters(p::Vector)
    parameters(p[1], p[2], p[3], p[4], p[5])
end


;
