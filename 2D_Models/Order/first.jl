function Update_Pos_and_Heading!(menge::crowd, temp_headings::Array{NTuple{2, Float64},1},
     temp_velocities::Array{Float64,1}, dt::Float64)

     for (i, x) in enumerate(menge.agent)
         x.heading, x.vel = R(x.ζ_h*randn()*sqrt(dt), temp_headings[i], temp_velocities[i] + x.ζ_v*randn()*sqrt(dt))
         x.pos = x.pos .+ dt .* x.heading .* x.vel
     end
end

function Update_Pos_and_Heading!(menge::crowd, temp_headings::Array{NTuple{2, Float64},1},
     temp_velocities::Array{Float64,1}, dt::Float64, system_size::NTuple{2, Float64})

     for (i, x) in enumerate(menge.agent)
         x.heading, x.vel = R(x.ζ_h*randn()*sqrt(dt))⋅temp_headings[i], temp_velocities[i] + x.ζ_v*randn()*sqrt(dt)
         x.pos = mod.(x.pos .+ dt .* x.heading .* x.vel, system_size)
     end
end

function Update_Pos_and_Heading!(menge::crowd, temp_headings::Array{NTuple{2, Float64},1},
     dt::Float64, system_size::NTuple{2, Float64})

     for (i, x) in enumerate(menge.agent)
         x.heading = R(x.ζ_h*randn()*sqrt(dt))⋅temp_headings[i]
         x.pos = mod.(x.pos .+ dt .* x.heading .* x.v_max, system_size)
     end
end
