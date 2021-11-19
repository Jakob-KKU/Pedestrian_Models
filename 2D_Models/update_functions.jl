function Update_Neighborhood!(menge::crowd, geometrie::geometry, system_size::NTuple{2, Float64},
     r::Float64)
    calculate_neighboring_agents(menge,system_size, r)
    calculate_neighboring_geometry(menge, geometrie, system_size, r)
end

function Update_Neighborhood!(menge::crowd, geometrie::geometry, r::Float64)
    calculate_neighboring_agents(menge, r)
    calculate_neighboring_geometry(menge, geometrie, r)
end

function Update_Pos_and_Heading!(menge::crowd, temp_headings::Array{NTuple{2, Float64},1},
     temp_velocities::Array{Float64,1}, dt::Float64)

     for (i, x) in enumerate(menge.agent)
         x.heading, x.vel = temp_headings[i], temp_velocities[i]
         x.pos = x.pos .+ dt .* x.heading .* x.vel
     end
end

function Update_Pos_and_Heading!(menge::crowd, temp_headings::Array{NTuple{2, Float64},1},
     temp_velocities::Array{Float64,1}, dt::Float64, system_size::NTuple{2, Float64})

     for (i, x) in enumerate(menge.agent)
         x.heading, x.vel = temp_headings[i], temp_velocities[i]
         x.pos = mod.(x.pos .+ dt .* x.heading .* x.vel, system_size)
     end
end

function Update_Pos_and_Heading!(menge::crowd, temp_headings::Array{NTuple{2, Float64},1},
     dt::Float64, system_size::NTuple{2, Float64})

     for (i, x) in enumerate(menge.agent)
         x.heading = temp_headings[i]
         x.pos = mod.(x.pos .+ dt .* x.heading .* x.v_max, system_size)
     end
end



function Update_Desired_Headings!(menge::crowd)

    for x in menge.agent
        x.desired_heading = e_(x, x.goal).*(-1)
    end
end
