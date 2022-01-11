function Add_Int_Data_d_ttc!(data::CSV.File, i, j, hist_inter, frames, rows, x, step, dt, d_max)
    #iterate over all frames in which i and j are together & calc the rows in the data

    d_pos = 1

    for m in x[1]:x[2]-d_pos

        k = rows[i]-frames[i][1]+m
        l = rows[j]-frames[j][1]+m


        ttc = ttc_1D(data, k, k+d_pos, l, l+d_pos, 0.3, d_pos*dt)

        if ttc <= 2

            hist_inter[Int(round((d(data, k, l))/step))+1, 1]+=1

        elseif ttc <= 5

            hist_inter[Int(round((d(data, k, l))/step))+1, 2]+=1

        elseif ttc > 5

            hist_inter[Int(round((d(data, k, l))/step))+1, 3]+=1

        end

    end

end

function Add_Ind_Data_d_ttc!(data::CSV.File, i, j, hist_inter, frames, rows, step, dt, d_max)

    d_pos = 1

    #iterate over all frames in which i appears
    for k in rows[i]:10:rows[i]+(frames[i][2]-frames[i][1]-d_pos)

        #iterate over all frames in which j appears
        for l in rows[j]:10:rows[j]+(frames[j][2]-frames[j][1]-d_pos)

            ttc = ttc_1D(data, k, k+d_pos, l, l+d_pos, 0.3, d_pos*dt)

            if ttc <= 2

                hist_inter[Int(round((d(data, k, l))/step))+1, 1]+=1

            elseif ttc <= 5

                hist_inter[Int(round((d(data, k, l))/step))+1, 2]+=1

            elseif ttc > 5

                hist_inter[Int(round((d(data, k, l))/step))+1, 3]+=1

            end


        end

    end

end


function Combined_Histograms_d_ttc(N, cam, path, Δd, d_max, fps, f_min)

    dist = collect(0.0:Δd:d_max)
    d_inter, d_indep = fill(0.0, length(dist), 3), fill(0.0, length(dist), 3)

    dt = 1/fps

    #iterate through data sets

    for x in cam

        for y in N

            file = string("n", y, "_cam", x, ".txt")
            data = Read_Traj(path, file)

            Add_Histograms_d_ttc!(data, Δd, d_max, d_inter, d_indep, f_min, dt)

        end

    end

    d_inter, d_indep, dist

end

function Add_Histograms_d_ttc!(data, Δd, d_max, d_inter, d_indep, f_min, dt)

    frames, rows = Find_Frames(data)

    #iterate through ID's
    for i in 1:length(frames)

        #iterate over all possible pairs
        for j in i+1:length(frames)

            #are i and j present in any frame together?
            x = Intersection_Interval(frames[i], frames[j])


            if x == false

                #if this is not the case: it is used to estimate the "non-interacting" distribution
                Add_Ind_Data_d_ttc!(data, i, j, d_indep, frames, rows, Δd, dt, d_max)

            elseif x[2]-x[1] >= f_min

                #if this they share at least f_min frames: it is used to estimate the "interacting" distribution
                Add_Int_Data_d_ttc!(data, i, j, d_inter, frames, rows, x, Δd, dt, d_max)

            end

        end

    end

end
