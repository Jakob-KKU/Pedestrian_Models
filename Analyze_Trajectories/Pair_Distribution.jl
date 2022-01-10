function Add_Distance_Int_Data!(data::CSV.File, i, j, d_inter, frames, rows, x, step)

    #iterate over all frames in which i and j are together & calc the rows in the data
    for m in x[1]:x[2]

        k = rows[i]-frames[i][1]+m
        l = rows[j]-frames[j][1]+m

        d_inter[Int(round((d_1D(data, k, l))/step))+1]+=1

    end

end

function Add_Distance_Ind_Data!(data::CSV.File, i, j, d_indep, frames, rows, step)

    #iterate over all frames in which i appears
    for k in rows[i]:10:rows[i]+(frames[i][2]-frames[i][1])

        #iterate over all frames in which j appears
        for l in rows[j]:10:rows[j]+(frames[j][2]-frames[j][1])

            #calculate their distance and add it to the independend set
            d_indep[Int(round((d_1D(data, k, l))/step))+1]+=1

        end

    end

end

#calculate the absolute frequencies of the distances with and with out interaction
function Pair_Dist(data, f_min, step, d_max)

    frames, rows = Find_Frames(data)

    distances = collect(0.0:step:d_max)
    d_inter, d_indep = fill(0.0, length(distances)), fill(0.0, length(distances))

    #iterate through ID's
    for i in 1:length(frames)

        #iterate over all possible pairs
        for j in i+1:length(frames)

            #are i and j present in any frame together?
            x = Intersection_Interval(frames[i], frames[j])


            if x == false

                #if this is not the case: it is used to estimate the "non-interacting" distribution
                Add_Distance_Ind_Data!(data, i, j, d_indep, frames, rows, step)

            elseif x[2]-x[1] >= f_min

                #if this they share at least f_min frames: it is used to estimate the "interacting" distribution
                Add_Distance_Int_Data!(data, i, j, d_inter, frames, rows, x, step)

            end

        end

    end

    d_inter, d_indep, distances

end

#gives the intersection of two intervals, false if none
function Intersection_Interval(i1, i2)

    if i2[1] > i1[2] || i1[1] > i2[2]

        false

    else

        (max(i1[1], i2[1]), min(i1[2], i2[2]))

    end

end

#gives the frames [start, end] in which agent i enters and leaves the filmed area and the row where his data starts
function Find_Frames(data::CSV.File)

    ID_max = data.ID[end]

    frames, row_start = Array{NTuple{2, Int64}, 1}(undef, ID_max), Array{Int64, 1}(undef, ID_max)

    ID_, row = 1, 1


    while ID_ < ID_max

        first = data[row].Frame
        row_start[ID_] = row

        while data[row].ID == ID_

            row+=1

        end

        last = data[row-1].Frame

        frames[ID_] = (first, last)

        ID_+=1

    end

    frames[ID_max] = (data[row].Frame, data[end].Frame)
    row_start[ID_max] = row

    frames, row_start

end
