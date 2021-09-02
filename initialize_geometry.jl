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
;
