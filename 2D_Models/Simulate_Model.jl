function Simulate!(menge::crowd, geometrie::geometry, t_relax::Float64, t_max::Float64, dt_save::Float64, dt::Float64,
        r::Float64, system_size::NTuple{2, Float64})

    N = length(menge.agent)

    #for saving positions
    saved_steps = Int(round((t_max-t_relax)/dt_save))-1
    positions = Array{NTuple{2, Float64}, 2}(undef, saved_steps, N)
    headings = Array{NTuple{2, Float64}, 2}(undef, saved_steps, N)

    #buffer vectors
    temp_headings, temp_velocities = Init_Temp_Vectors(menge)

    i, j = 0, 1

    while dt * i < t_max

        Iterate!(menge, geometrie, temp_headings, temp_velocities, dt, r, system_size)

        if dt*i>t_relax && mod(i, Int(round(dt_save/dt))) == 0

            Save_Posistions_Headings!(menge, geometrie, j, system_size, positions, headings)
            j = j + 1

        end

        i = i + 1
    end

    positions, headings
end

function Iterate!(menge::crowd, geometrie::geometry, temp_headings::Array{NTuple{2, Float64},1},
        temp_velocities, dt::Float64, r::Float64, system_size::NTuple{2, Float64})

    Update_Desired_Headings!(menge, system_size)

    Update_Neighborhood!(menge, geometrie, system_size, r)

    #Update_Voronoi_Dens!(menge, system_size)


    Update_Pref_Velocities!(menge, geometrie, system_size)

    Update_Temp_Headings_and_Velocities!(menge, geometrie, temp_headings,
     temp_velocities, system_size, dt)

    Update_Pos_and_Heading!(menge, temp_headings, temp_velocities, dt, system_size)

end

function Iterate_x_TimeSteps!(menge::crowd, geometrie::geometry, x::Int, dt::Float64,
        r::Float64, system_size::NTuple{2, Float64})

    #buffer vectors
    temp_headings, temp_velocities = Init_Temp_Vectors(menge)

    for i ∈ 1:x

        Iterate!(menge, geometrie, temp_headings, temp_velocities, dt, r, system_size)

    end

end

function Init_Temp_Vectors(menge::crowd)

    N = length(menge.agent)

    temp_velocities = Array{Float64,1}(undef,N)
    temp_headings = Array{NTuple{2, Float64},1}(undef,N)

    for i in 1:N
        temp_headings[i] = menge.agent[i].e_des
        temp_velocities[i] = menge.agent[i].vel
    end

    temp_headings, temp_velocities

end

function Save_Pos_Vel_TTC!(menge::crowd, geometrie::geometry, j, system_size, velocities, positions, headings)

    for i in 1:length(menge.agent)
        #ttcs[j, i] = Min_TTC(menge.agent[i], menge, geometrie, system_size)
        velocities[j , i] = menge.agent[i].vel
        positions[j, i] = menge.agent[i].pos
        headings[j, i]  = menge.agent[i].heading
    end

end

function Save_Posistions_Headings!(menge::crowd, geometrie::geometry, j, system_size, positions, headings)

    for i in 1:length(menge.agent)
        positions[j, i] = menge.agent[i].pos
        headings[j, i] = menge.agent[i].heading
    end

end
;
