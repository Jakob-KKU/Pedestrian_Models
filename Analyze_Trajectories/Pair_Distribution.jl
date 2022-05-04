Pair_Distribution_from_Hist(h_inter, h_indep) = h_inter.*sum(h_indep)./(h_indep.*sum(h_inter))

function Combined_Histograms(files, path, header, Δx, x_min, x_max, k, sign, Δt, f_min, f_max)

    x = collect(x_min:Δx:x_max)
    p_x_INT, p_x_IND = fill(0.0, length(x)), fill(0.0, length(x))

    #iterate through data sets
    for (i, file) in enumerate(files)

        menge = Create_Crowd(Read_Traj(path, file, header))
        Init_Velocities!(menge, k, Δt, sign[i])

        Add_to_Histogram!(menge, Δx, x_max, p_x_INT, p_x_IND, f_min, f_max)

    end

    p_x_INT, p_x_IND, x

end

function Add_to_Histogram!(menge::crowd, Δx, x_max, p_x_INT, p_x_IND, f_min, f_max)

    #iterate through ID's
    for (i, a) in enumerate(menge.agent)

        if a.frames[1] > f_min && a.frames[2] < max_frame(menge) - f_max

           Add_agent_to_Histogram!(menge, a, i, Δx, x_max, p_x_INT, p_x_IND)

       end

    end

    p_x_INT, p_x_IND

end

function Add_agent_to_Histogram!(menge::crowd, a::agent, i, Δx, x_max, p_x_INT, p_x_IND)

    #iterate over all possible pairs
    for (j, b) in enumerate(menge.agent[i+1:end])

        #are a and b present in any frame together?
        if Intersection_Interval(a.frames, b.frames) == false

            #if this is not the case: it is used to estimate the "non-interacting" distribution
            Add_IND_Data!(p_x_IND, Δx, x_max, x_min, a, b)

        else

            #if this they share at least f_min frames: it is used to estimate the "interacting" distribution
            Add_INT_Data!(p_x_INT, Δx, x_max, x_min, a, b)

        end

    end
end


function Add_INT_Data!(p_x, Δx, x_max, x_min, a, b)

    i_min, i_max = Intersection_Interval(a.frames, b.frames)

    #iterate over all frames in which i and j are together & calc the rows in the data
    for i in i_min:i_max

        k, l = i - a.frames[1] + 1, i - b.frames[1] + 1

        x = obs(a, b, k, l)

        if x < x_max && x > x_min && a.v_x[k] != 0.0 && b.v_x[l] != 0.0

                p_x[I(x,Δx,x_min)]+=1

        end

    end

end

function Add_IND_Data!(p_x, Δx, x_max, x_min, a, b)

    #iterate over all frames in which i appears
    for k in 1:10:length(a.x)

        #iterate over all frames in which j appears
        for l in 1:10:length(b.x)

            #calculate their distance and add it to the independend set
            x = obs(a, b, k, l)

            if x < x_max && x > x_min && a.v_x[k] != 0.0  && b.v_x[l] != 0.0

                p_x[I(x,Δx,x_min)]+=1

            end


        end

    end

end

function max_frame(menge::crowd)
    f_max = 0

    for a in menge.agent
        f_max = max(a.frames[2], f_max)
    end

    f_max
end
