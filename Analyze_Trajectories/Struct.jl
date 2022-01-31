mutable struct agent

    frames::NTuple{2, Int} #first and last frame for which the data is known
    x::Vector{Float64}
    y::Vector{Float64}
    v_x::Vector{Float64}
    v_y::Vector{Float64}

end

struct crowd
    agent::Array{agent, 1}
end
