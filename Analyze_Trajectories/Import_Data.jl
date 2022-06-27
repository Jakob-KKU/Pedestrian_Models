function Read_Traj(path, file, header_)

    CSV.File(string(path, file); select = [1, 2, 3, 4], header=header_, comment="#")

end

function Init_Velocities!(menge::crowd, k, Δt, dir)

    for a in menge.agent

        for i in k+1:length(a.x)-k

            a.v_x[i] = dir*v(a.x[i-k], a.x[i+k], k*Δt)
            a.v_y[i] = dir*v(a.y[i-k], a.y[i+k], k*Δt)

        end
    end

end

function Init_Velocities!(menge::crowd, k, Δt)

    for a in menge.agent

        for i in k+1:length(a.x)-k

            a.v_x[i] = v(a.x[i-k], a.x[i+k], k*Δt)
            a.v_y[i] = v(a.y[i-k], a.y[i+k], k*Δt)

        end
    end

end

function Create_Crowd(data::CSV.File)

    frames, row_start = Find_Frames(data)

    N = length(frames)

    crowd([agent(frames[i],
                data.x[row_start[i]:(row_start[i] + frames[i][2]-frames[i][1])],
                data.y[row_start[i]:(row_start[i] + frames[i][2]-frames[i][1])],
                fill(0.0, frames[i][2]-frames[i][1]+1),
                fill(0.0, frames[i][2]-frames[i][1]+1))
            for i in 1:N])

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

I(x, Δx, x_min) = Int(floor((x-x_min)/Δx+1))


;
