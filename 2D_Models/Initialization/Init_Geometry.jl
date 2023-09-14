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

function create_corridor(width, laenge, size, dx)
    geometry_y = vcat(zeros(length(LinRange(0:dx:laenge))), fill(width, length(LinRange(0:dx:laenge))))
    geometry_x = vcat(LinRange(0:dx:laenge), LinRange(0:dx:laenge))

    geometry([element((geometry_x[i], geometry_y[i]), size) for i in 1:length(geometry_x)])
end

function Create_Geometry_Bottleneck(länge, breite, size, system_size)

    b1 = (system_size[1]-breite)/2


    a_x = LinRange(0.0:size:b1)
    a_y = fill(system_size[2]/2, length(a_x))

    b_x = LinRange(b1+breite:size:system_size[2])
    b_y = fill(system_size[2]/2, length(b_x))

    c_y = LinRange(system_size[2]/2:size:system_size[2]/2+länge)
    c_x = fill(b1, length(c_y))

    d_y = LinRange(system_size[2]/2:size:system_size[2]/2+länge)
    d_x = fill(b1+breite, length(c_y))


    geometry_x = vcat(a_x, b_x, c_x, d_x)
    geometry_y = vcat(a_y, b_y, c_y, d_y)

    geometry([element((geometry_x[i], geometry_y[i]), size) for i in 1:length(geometry_x)])
end

function Create_Closed_Room!(a0, a, b0, b, l)

    geometry_x = vcat(LinRange(a0:l:a0+a), fill(a0 ,length(LinRange(0:l:b))), LinRange(a0:l:a0+a), fill(a+a0, length(LinRange(0:l:b))))
    geometry_y = vcat(fill(b0, length(LinRange(0:l:a))), LinRange(b0:l:b+b0), fill(b+b0, length(LinRange(0:l:a))), LinRange(b0:l:b0+b))

    geometry([element((geometry_x[i], geometry_y[i]), l) for i in 1:length(geometry_x)])
end

function Create_Cross_Section(l1, l2, size)

    #1
    x1, y1 = Geo_Line((0, l1), (l1, l1), size)

    #2
    x2, y2 = Geo_Line((l1, 0), (l1, l1), size)

    #3
    x3, y3 = Geo_Line((l1+l2, 0), (l1+l2, l1), size)

    #4
    x4, y4 = Geo_Line((l1+l2, l1), (2*l1+l2, l1), size)

    #5
    x5, y5 = Geo_Line((0, l1+l2), (l1, l1+l2), size)

    #6
    x6, y6 = Geo_Line((l1, l1+l2), (l1, 2*l1+l2), size)

    #7
    x7, y7 = Geo_Line((l1+l2, 2*l1+l2), (l1+l2, l1+l2), size)

    #8
    x8, y8 = Geo_Line((l1+l2, l1+l2), (2*l1+l2, l1+l2), size)


    geometry_y = vcat(x1, x2, x3, x4, x5, x6, x7, x8)
    geometry_x = vcat(y1, y2, y3, y4, y5, y6, y7, y8)

    geometry([element((geometry_x[i], geometry_y[i]), size) for i in 1:length(geometry_x)])
end

function Geo_Line(P1, P2, size)

    N = Int(round(abs(P2.-P1)/size+1))
    cor_x, cor_y = fill(0.0, N), fill(0.0, N)

    for i in 1:N

        cor_x[i], cor_y[i] = Point_on_Line(P1, P2, size, i)

    end

    cor_x, cor_y

end

Point_on_Line(P1, P2, size, i) = P1 .+ (P2.-P1)./abs(P2.-P1).*size.*(i-1)


;
