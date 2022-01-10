function Add_ttc_Int_Data!(data::CSV.File, i, j, hist_inter, frames, rows, x, step, dt, ttc_max)

    #iterate over all frames in which i and j are together & calc the rows in the data
    for m in x[1]:x[2]-1

        k = rows[i]-frames[i][1]+m
        l = rows[j]-frames[j][1]+m


        ttc = ttc_1D(data, k, k+1, l, l+1, 0.3, dt)

        if ttc <= ttc_max && ttc >= 0.0

            hist_inter[Int(round(ttc/step))+1]+=1

        end

    end

end

function Add_ttc_Ind_Data!(data::CSV.File, i, j, hist_indep, frames, rows, step, dt, ttc_max)

    #iterate over all frames in which i appears
    for k in rows[i]:10:rows[i]+(frames[i][2]-frames[i][1]-1)

        #iterate over all frames in which j appears
        for l in rows[j]:10:rows[j]+(frames[j][2]-frames[j][1]-1)

            #calculate their distance and add it to the independend set
            ttc = ttc_1D(data, k, k+1, l, l+1, 0.3, dt)


            if ttc <= ttc_max && ttc >= 0.0

                hist_indep[Int(round(ttc/step))+1]+=1

            end


        end

    end

end

function Combined_ttc_Histograms(N, cam, path, Δttc, ttc_max, fps, f_min)

    ttcs = collect(0.0:Δttc:ttc_max)
    ttc_inter, ttc_indep = fill(0.0, length(ttcs)), fill(0.0, length(ttcs))

    dt = 1/fps

    #iterate through data sets

    for x in cam

        for y in N

            file = string("n", y, "_cam", x, ".txt")
            data = Read_Traj(path, file)

            Add_ttc_Histograms!(data, Δttc, ttc_max, ttc_inter, ttc_indep, f_min, dt)

        end

    end

    ttc_inter, ttc_indep, ttcs

end

function Add_ttc_Histograms!(data, Δttc, ttc_max, ttc_inter, ttc_indep, f_min, dt)

    frames, rows = Find_Frames(data)

    #iterate through ID's
    for i in 1:length(frames)

        #iterate over all possible pairs
        for j in i+1:length(frames)

            #are i and j present in any frame together?
            x = Intersection_Interval(frames[i], frames[j])


            if x == false

                #if this is not the case: it is used to estimate the "non-interacting" distribution
                Add_ttc_Ind_Data!(data, i, j, ttc_indep, frames, rows, Δttc, dt, ttc_max)

            elseif x[2]-x[1] >= f_min

                #if this they share at least f_min frames: it is used to estimate the "interacting" distribution
                Add_ttc_Int_Data!(data, i, j, ttc_inter, frames, rows, x, Δttc, dt, ttc_max)

            end

        end

    end

end
