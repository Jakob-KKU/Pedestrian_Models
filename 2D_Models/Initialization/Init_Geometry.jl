function create_geometry_single_obstacle(position, size)
    geometry([element(position, size)])
end

function create_geometry_closed_room(a, b, l)
    geometry_x = vcat(LinRange(0:l:a), zeros(length(LinRange(0:l:b))), LinRange(0:l:a), fill(a, length(LinRange(0:l:b))))
    geometry_y = vcat(zeros(length(LinRange(0:l:a))), LinRange(0:l:b), fill(b, length(LinRange(0:l:a))), LinRange(0:l:b))

    geometry([element((geometry_x[i], geometry_y[i]), l) for i in 1:length(geometry_x)])
end


function create_geometry_room_door_on_right(a, b, l, breite_tuer)
    geometry_x = vcat(LinRange(0:l:a), zeros(length(LinRange(0:l:b))), LinRange(0:l:a), fill(a, length(LinRange(0:l:b/2-breite_tuer/2))), fill(a, length(LinRange(b/2-breite_tuer/2:l:b))))
    geometry_y = vcat(zeros(length(LinRange(0:l:a))), LinRange(0:l:b), fill(b, length(LinRange(0:l:a))), LinRange(0:l:b/2-breite_tuer/2), LinRange(b/2-breite_tuer/2:l:b))

    geometry([element((geometry_x[i], geometry_y[i]), l) for i in 1:length(geometry_x)])
end


function create_corridor_with_obstacle(width, laenge, size)
    geometry_y = vcat(zeros(length(LinRange(0:size:laenge))), fill(width, length(LinRange(0:size:laenge))), width/2)
    geometry_x = vcat(LinRange(0:size:laenge), LinRange(0:size:laenge), laenge/2)

    geometry([element((geometry_x[i], geometry_y[i]), size) for i in 1:length(geometry_x)])
end

function create_corridor(width, laenge, size)
    geometry_y = vcat(zeros(length(LinRange(0:size:laenge))), fill(width, length(LinRange(0:size:laenge))))
    geometry_x = vcat(LinRange(0:size:laenge), LinRange(0:size:laenge))

    geometry([element((geometry_x[i], geometry_y[i]), size) for i in 1:length(geometry_x)])
end

function Create_Geometry_Bottleneck(länge, breite, l, system_size)

    b1 = (system_size[1]-breite)/2


    a_x = LinRange(0:l:b1)
    a_y = fill(system_size[2]/2, length(a_x))

    b_x = LinRange(b1+breite:l:system_size[2])
    b_y = fill(system_size[2]/2, length(b_x))

    c_y = LinRange(system_size[2]/2:l:system_size[2]/2+länge)
    c_x = fill(b1, length(c_y))

    d_y = LinRange(system_size[2]/2:l:system_size[2]/2+länge)
    d_x = fill(b1+breite, length(c_y))


    geometry_x = vcat(a_x, b_x, c_x, d_x)
    geometry_y = vcat(a_y, b_y, c_y, d_y)

    geometry([element((geometry_x[i], geometry_y[i]), l) for i in 1:length(geometry_x)])
end

function Create_Closed_Room!(a0, a, b0, b, l)

    geometry_x = vcat(LinRange(a0:l:a0+a), fill(a0 ,length(LinRange(0:l:b))), LinRange(a0:l:a0+a), fill(a+a0, length(LinRange(0:l:b))))
    geometry_y = vcat(fill(b0, length(LinRange(0:l:a))), LinRange(b0:l:b+b0), fill(b+b0, length(LinRange(0:l:a))), LinRange(b0:l:b0+b))

    geometry([element((geometry_x[i], geometry_y[i]), l) for i in 1:length(geometry_x)])
end

;
