#Plot trajectories with plots.jl


function Plot_Trajectories(data::CSV.File)

    N = maximum(data.id)
    row_s = 1
    row_e = 1

    for i in 1:N-1

        c = get(ColorSchemes.rainbow, i/N)

        while data[row_e].id == i

            row_e+=1

        end

        scatter!([data[j].x for j in row_s:row_e], [data[j].y for j in row_s:row_e], color=c, msw=0, label=false)

        row_e += 1
        row_s = row_e

    end

    scatter!([data[j].x for j in (row_e:length(data))], [data[j].y for j in row_s:row_e], color=:black, markersize = 5, msw=0, label=false)

end

function Plot_Trajectories(menge::crowd, frames::NTuple{2, Int})

    N = length(menge.agent)

    for (i, a) in enumerate(menge.agent)

        c = get(ColorSchemes.rainbow, i/N)

        if In_Frame(frames, a) == true

            xy = XY_Frame(frames, a)

            scatter!(xy, color=c, msw=0, label=false)

        end

    end

end
