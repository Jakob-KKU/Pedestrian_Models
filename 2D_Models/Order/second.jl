function Update_Pos_and_Heading!(menge::crowd, temp_headings::Array{NTuple{2, Float64},1},
     temp_velocities::Array{Float64,1}, dt::Float64, system_size::NTuple{2, Float64})

     for (i, x) in enumerate(menge.agent)
         x.heading = R(x.ζ_h*randn()*sqrt(dt), normalize(x.heading.*(1-dt/x.τ_R).+dt/x.τ_R.*temp_headings[i]))
         x.vel = x.vel*(1-dt/x.τ_R) + dt/x.τ_R * temp_velocities[i] + x.ζ_v*randn()*sqrt(dt)

         x.pos = mod.(x.pos .+ dt .* x.heading .* x.vel, system_size)
     end
end
