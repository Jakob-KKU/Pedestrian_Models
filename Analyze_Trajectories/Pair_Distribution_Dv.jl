function Add_Int_Data_Δv!(data::CSV.File, i, j, hist_inter, frames, rows, x, step, dt, dv_max)
    #iterate over all frames in which i and j are together & calc the rows in the data
    for m in x[1]:x[2]-1

        k = rows[i]-frames[i][1]+m
        l = rows[j]-frames[j][1]+m


        dv = v_1D(data, l, l+1, dt)-v_1D(data, k, k+1, dt)

        if abs(dv) <= dv_max

            hist_inter[Int(round((dv+dv_max)/step))+1]+=1

        end

    end

end

function Add_Ind_Data_Δv!(data::CSV.File, i, j, hist_indep, frames, rows, step, dt, dv_max)

    #iterate over all frames in which i appears
    for k in rows[i]:10:rows[i]+(frames[i][2]-frames[i][1]-1)

        #iterate over all frames in which j appears
        for l in rows[j]:10:rows[j]+(frames[j][2]-frames[j][1]-1)

            #calculate their distance and add it to the independend set
            dv = v_1D(data, l, l+1, dt)-v_1D(data, k, k+1, dt)


            if abs(dv) <= dv_max

                hist_indep[Int(round((dv+dv_max)/step))+1]+=1

            end


        end

    end

end

function Combined_Δv_Histograms(N, cam, path, _Δ, _max, fps, f_min)

    _values = collect(-_max:_Δ:_max)
    _inter, _indep = fill(0.0, length(_values)), fill(0.0, length(_values))

    dt = 1/fps

    #iterate through data sets

    for x in cam

        for y in N

            file = string("n", y, "_cam", x, ".txt")
            data = Read_Traj(path, file)

            Add_Δv_Histograms!(data, _Δ, _max, _inter, _indep, f_min, dt)

        end

    end

     _inter, _indep, _values

end

function Add_Δv_Histograms!(data,  _Δ, _max, _inter, _indep, f_min, dt)

    frames, rows = Find_Frames(data)

    #iterate through ID's
    for i in 1:length(frames)

        #iterate over all possible pairs
        for j in i+1:length(frames)

            #are i and j present in any frame together?
            x = Intersection_Interval(frames[i], frames[j])


            if x == false

                #if this is not the case: it is used to estimate the "non-interacting" distribution
                Add_Ind_Data_Δv!(data, i, j, _indep, frames, rows, _Δ, dt, _max)

            elseif x[2]-x[1] >= f_min

                #if this they share at least f_min frames: it is used to estimate the "interacting" distribution
                Add_Int_Data_Δv!(data, i, j, _inter, frames, rows, x, _Δ, dt, _max)

            end

        end

    end

end
