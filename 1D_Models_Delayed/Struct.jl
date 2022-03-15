mutable struct agent

	pos::Float64
    vel::Float64

	pred::Int64 #predecessor
    v_h::Vector{Float64}
    x_h::Vector{Float64}

    v_max::Float64
    T::Float64 #desired_timegap
    l::Float64 #size
    τ_R::Float64 #reaction_time
	τ_A::Float64 #ant time
	σ::Float64 #Noise Amplitude
    i::Int64


end

mutable struct crowd
    agent::Array{agent, 1}
end


function create_crowd(N::Int, dt, τ_R)

    len = Int(round(τ_R/dt))

    crowd([agent(0.0, 0.0, 0, fill(0.0, len),  fill(0.0, len), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1) for i in 1:N])
end
;
