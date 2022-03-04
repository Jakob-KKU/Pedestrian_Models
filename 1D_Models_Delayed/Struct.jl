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
    dt::Float64


end

mutable struct crowd
    agent::Array{agent, 1}
end




#create an agent
function agent(pos::Float64, v_max::Float64, T::Float64, l::Float64, τ::Float64, τ_A, dt_step::Float64, γ, σ)
	agent(pos, 0.0, 0.0, 0, v_max, T, l, τ, τ_A, dt_step, γ, σ)
end


function create_crowd(N::Int, dt, τ_R)

    len = Int(round(τ_R/dt))+1

    crowd([agent(0.0, 0.0, 0, fill(0.0, len),  fill(0.0, len), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0) for i in 1:N])
end
;
