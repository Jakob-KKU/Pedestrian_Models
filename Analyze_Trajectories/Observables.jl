d(x_1, y_1, x_2, y_2) = sqrt((x_1-x_2)^2+(y_1-y_2)^2)

d(data::CSV.File, k::Int, l::Int) = sqrt((data[k].x-data[l].x)^2+(data[k].y-data[l].y)^2)

d_1D(data::CSV.File, k::Int, l::Int) = abs(data[k].x-data[l].x)
