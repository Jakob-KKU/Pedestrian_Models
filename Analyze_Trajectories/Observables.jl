d(x_1, y_1, x_2, y_2) = sqrt((x_1-x_2)^2+(y_1-y_2)^2)

d(data::CSV.File, k::Int, l::Int) = sqrt((data[k].x-data[l].x)^2+(data[k].y-data[l].y)^2)

d_1D(data::CSV.File, k::Int, l::Int) = abs(data[k].x-data[l].x)
dx_1D(data::CSV.File, k::Int, l::Int) = data[k].x-data[l].x


v_1D(data::CSV.File, k::Int, l::Int, Δt) = (data[l].x-data[k].x)/Δt

v(x_1, y_1, x_2, y_2, Δt) = ((x_2-x_1), (y_2-y_1))./Δt

v(data::CSV.File, k::Int, l::Int, Δt) = (data[l].x-data[k].x, data[l].y-data[k].y)./Δt

d_ttc_1d(Δv, δΔv, d, δd, l) = sqrt((sqrt(δd/Δv)^2)+((d-l)/(Δv)^2*δΔv)^2)

ttc_1d(Δv, d, l) = (d-l)/Δv

function ttc_1D(data::CSV.File, k1::Int, l1::Int, k2::Int, l2::Int, l, Δt)

    Δv = v_1D(data, k2, l2, Δt)-v_1D(data, k1, l1, Δt)

    if Δv == 0

        999.0

    else

        d_mean = (dx_1D(data, k2, k1)+dx_1D(data, l2, l1))/2

        (d_mean-l)/Δv

    end

end

function count_hist(hist)

    N = 0

    for x in hist

        N = N + x

    end

    N

end
;
