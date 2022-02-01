function Combined_Histograms(files, path, header, Δx, x_min, x_max, k, sign, Δt, f_min, f_max, bins)

    x = collect(x_min:Δx:x_max)
    p_x_INT, p_x_IND = fill(0.0, length(x), 3), fill(0.0, length(x), 3)

    #iterate through data sets
    for (i, file) in enumerate(files)

        menge = Create_Crowd(Read_Traj(path, file, header))
        Init_Velocities!(menge, k, Δt, sign[i])

        Add_to_Histogram!(menge, Δx, x_max, p_x_INT, p_x_IND, f_min, f_max, bins)

    end

    p_x_INT, p_x_IND, x

end

function Add_to_Histogram!(menge::crowd, Δx, x_max, p_x_INT, p_x_IND, f_min, f_max, bins)



    #iterate through ID's
    for (i, a) in enumerate(menge.agent)

        if a.frames[1] > f_min && a.frames[2] < max_frame(menge) - f_max

           Add_agent_to_Histogram!(menge, a, i, Δx, x_max, p_x_INT, p_x_IND, bins)

       end

    end

    p_x_INT, p_x_IND

end

function Add_agent_to_Histogram!(menge::crowd, a::agent, i, Δx, x_max, p_x_INT, p_x_IND, bins)

    #iterate over all possible pairs
    for (j, b) in enumerate(menge.agent[i+1:end])

        #are a and b present in any frame together?
        if Intersection_Interval(a.frames, b.frames) == false

            #if this is not the case: it is used to estimate the "non-interacting" distribution
            Add_IND_Data!(p_x_IND, Δx, x_max, x_min, a, b, bins)

        else

            #if this they share at least f_min frames: it is used to estimate the "interacting" distribution
            Add_INT_Data!(p_x_INT, Δx, x_max, x_min, a, b, bins)

        end

    end
end


function Add_INT_Data!(p_x, Δx, x_max, x_min, a, b, bins)

    i_min, i_max = Intersection_Interval(a.frames, b.frames)

    #iterate over all frames in which i and j are together & calc the rows in the data
    for i in i_min:i_max

        k, l = i - a.frames[1] + 1, i - b.frames[1] + 1

        x = obs(a, b, k, l)
        y = obs_bin(a, b, k, l)

        if x < x_max && x > x_min && a.v_x[k] != 0.0 && b.v_x[l] != 0.0

            if y < bins[1]

                p_x[I(x,Δx,x_min), 1]+=1

            elseif y < bins[2]

                p_x[I(x,Δx,x_min), 2]+=1

            else

                p_x[I(x,Δx,x_min), 3]+=1

            end

        end

    end

end

function Add_IND_Data!(p_x, Δx, x_max, x_min, a, b, bins)

    #iterate over all frames in which i appears
    for k in 1:10:length(a.x)

        #iterate over all frames in which j appears
        for l in 1:10:length(b.x)

            #calculate their distance and add it to the independend set
            x = obs(a, b, k, l)
            y = obs_bin(a, b, k, l)

            if x < x_max && x > x_min && a.v_x[k] != 0.0  && b.v_x[l] != 0.0

                if y < bins[1]

                    p_x[I(x,Δx,x_min), 1]+=1

                elseif y < bins[2]

                    p_x[I(x,Δx,x_min), 2]+=1

                else

                    p_x[I(x,Δx,x_min), 3]+=1

                end

            end


        end

    end

end
