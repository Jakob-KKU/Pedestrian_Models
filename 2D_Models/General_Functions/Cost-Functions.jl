function Calc_CostFunctionMatrix(a::agent, menge::crowd, geometrie::geometry, system_size)

    v_xs = collect(-a.v_max:0.01:a.v_max)
    v_ys = collect(-a.v_max:0.01:a.v_max)
    cost = fill(0.0, length(v_ys), length(v_xs))

    for (i, v_x) in enumerate(v_xs)

        for (j, v_y) in enumerate(v_ys)

            cost[j, i] = Score(a, (v_x, v_y), menge, geometrie, system_size)

        end
    end

    v_xs, v_ys, cost
end

#used for plotting the field lines
function Calculate_Direction_Matrix(a::agent, b::agent, menge::crowd, geometrie::geometry, system_size, x_values, y_values)

    Grid_x = fill(0.0, length(x_values)*length(y_values))
    Grid_y = copy(Grid_x)

    v_x = copy(Grid_x)
    v_y = copy(Grid_x)

    counter = 1

    for (i, x) in enumerate(x_values)

        for (j, y) in enumerate(y_values)

            a.pos = (x, y)

            if d(a, b) >= l(a, b)+0.05

                e_opt, v_opt = Calc_Heading_Velocity(a, menge, geometrie, system_size)
                gradient = e_opt .* v_opt

                v_x[counter] = gradient[1]
                v_y[counter] = gradient[2]


            end

            Grid_x[counter] = x
            Grid_y[counter] = y

            counter = counter + 1

        end
    end

    Grid_x, Grid_y, v_x, v_y

end


#Gradient for Potential at operational level
function ∇r_ϕ(a::agent, menge::crowd, geometrie::geometry, system_size, h = 0.001)

    a.pos = a.pos .+ h .*(1.0, 0.0)

    ϕ_x = ϕ(a, menge, geometrie, system_size)

    a.pos = a.pos .- h .*(1.0, 0.0)  .+ h .*(0.0, 1.0)

    ϕ_y = ϕ(a, menge, geometrie, system_size)

    a.pos = a.pos .- h .*(0.0, 1.0)

    ((ϕ_x, ϕ_y) .- ϕ(a, menge, geometrie, system_size))./h

end

#Gradient for Potential at tactical level
function ∇r_ϕ_TACT(a::agent, menge::crowd, geometrie::geometry, system_size, h = 0.001)

    a.pos = a.pos .+ h .*(1.0, 0.0)

    ϕ_x = ϕ(a, menge, geometrie, system_size)

    a.pos = a.pos .- h .*(1.0, 0.0)  .+ h .*(0.0, 1.0)

    ϕ_y = ϕ(a, menge, geometrie, system_size)

    a.pos = a.pos .- h .*(0.0, 1.0)

    ((ϕ_x, ϕ_y) .- ϕ(a, menge, geometrie, system_size))./h

end


# Calculate the Cost of velocity v for agent a
function Calc_Score(a::agent, v, menge::crowd, geometrie::geometry, system_size, dt = 0.01)

    #save current position
    a_vel_temp = a.vel
    a_head_temp = a.heading
    a_pos_temp = a.pos

    #initialize test velocity
    a.vel = abs(v)
    a.heading = normalize(v)
    a.pos = a.pos .+ v .* dt

    #calculate associated SCORE
    score_ = Score(a, menge, geometrie, system_size)

    #reset position
    a.vel = a_vel_temp
    a.heading = a_head_temp
    a.pos = a_pos_temp

    #return Score
    score_

end

;
