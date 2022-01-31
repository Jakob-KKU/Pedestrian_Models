Pair_Distribution_from_Hist(h_inter, h_indep) = h_inter.*sum(h_indep)./(h_indep.*sum(h_inter))

function Combined_Histograms(files, path, header, Δx, x_min, x_max, k, sign, Δt)

    x = collect(0.0:Δx:x_max)
    p_x_INT, p_x_IND = fill(0.0, length(x)), fill(0.0, length(x))

    #iterate through data sets
    for (i, file) in enumerate(files)

        menge = Create_Crowd(Read_Traj(path, file, header))
        Init_Velocities!(menge, k, Δt, sign[i])

        Add_to_Histogram!(menge, Δx, x_max, p_x_INT, p_x_IND)

    end

    p_x_INT, p_x_IND, x

end

function Add_to_Histogram!(menge::crowd, Δx, x_max, p_x_INT, p_x_IND)

    #iterate through ID's
    for (i, a) in enumerate(menge.agent)

        #iterate over all possible pairs
        for (j, b) in enumerate(menge.agent[i+1:end])

            #are i and j present in any frame together?
            if Intersection_Interval(a.frames, b.frames) == false

                #if this is not the case: it is used to estimate the "non-interacting" distribution
                Add_IND_Data!(p_x_IND, Δx, x_max, x_min, a, b)

            else

                #if this they share at least f_min frames: it is used to estimate the "interacting" distribution
                Add_INT_Data!(p_x_INT, Δx, x_max, x_min, a, b)

            end

        end

    end

    p_x_INT, p_x_IND

end

function Add_INT_Data!(p_x, Δx, x_max, x_min, a, b)

    i_min, i_max = Intersection_Interval(a.frames, b.frames)

    #iterate over all frames in which i and j are together & calc the rows in the data
    for i in i_min:i_max

        x = d(a.x[i - a.frames[1] + 1], b.x[i - b.frames[1] + 1])

        if x < x_max && x > x_min

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
            x = d(a.x[k], b.x[l])

            if x < x_max && x > x_min

                p_x[I(x,Δx,x_min)]+=1

            end


        end

    end

end
