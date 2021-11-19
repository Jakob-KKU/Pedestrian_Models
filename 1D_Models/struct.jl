mutable struct agent

	pos::Float64
    vel::Float64
	step::Float64

    v_max::Float64
    T::Float64 #desired_timegap
    l::Float64 #size
    τ::Float64 #reaction_time
	dt_step::Float64 #time for a steo

end

mutable struct crowd
    agent::Array{agent, 1}
end




#create an agent
function agent(pos::Float64, v_max::Float64, T::Float64, l::Float64, τ::Float64, dt_step::Float64)
	agent(pos, 0.0, 0.0, v_max, T, l, τ, dt_step)
end


function create_crowd(N::Int)
    crowd([agent(0.0, 0.0, 0.0,  0.0,  0.0,  0.0,  0.0,  0.0) for i in 1:N])
end
;
