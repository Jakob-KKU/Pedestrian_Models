function rewrite_geometry(geometrie::geometry)

    geometry_x = Float64[]
    geometry_y = Float64[]


    for x in geometrie.element

        push!(geometry_x, x.pos[1])
        push!(geometry_y, x.pos[2])

    end

    return geometry_x, geometry_y

end



function plot_geometry(geometry_x, geometry_y, size, color)

    GR.setmarkertype(GR.MARKERTYPE_SOLID_CIRCLE)
    GR.setmarkersize(size)
    GR.setmarkercolorind(color)
    GR.polymarker(geometry_x, geometry_y)

end

function plot_boundaries(x, y, size, color)

    GR.setmarkertype(GR.MARKERTYPE_ASTERISK)
    GR.setmarkersize(size)
    GR.setmarkercolorind(color)
    GR.polymarker(x, y)

end

function plot_goal(goal)

    GR.setmarkertype(GR.MARKERTYPE_SOLID_DIAMOND)
    GR.setmarkersize(2)
    GR.setmarkercolorind(30)
    GR.polymarker([goal[1]], [goal[2]])

end



function plot_agents(positions, headings, size, color, size_2, color_2, abstand)

    GR.setmarkertype(GR.MARKERTYPE_SOLID_CIRCLE)
    GR.setmarkersize(size)
    GR.setmarkercolorind(color)
    GR.polymarker([x[1] for x in positions], [x[2] for x in positions])

    GR.setmarkertype(GR.MARKERTYPE_SOLID_CIRCLE)
    GR.setmarkersize(size_2)
    GR.setmarkercolorind(color_2)

    GR.polymarker([x[1]*abstand + positions[i][1] for (i, x) in enumerate(headings)], [x[2]*abstand + positions[i][2] for (i, x) in enumerate(headings)])

end

function plot_agents(positions, size, color) #1D

    GR.setmarkertype(GR.MARKERTYPE_SOLID_CIRCLE)
    GR.setmarkersize(size)
    GR.setmarkercolorind(color)
    GR.polymarker(positions, 0 .*positions)

end

function plot_agents(positions, size, color)

    GR.setmarkertype(GR.MARKERTYPE_SOLID_CIRCLE)
    GR.setmarkersize(size)
    GR.setmarkercolorind(color)
    GR.polymarker(positions, 0 .*positions)

end

function boundaries_rectangle_positions(system_size)

    x = vcat(zeros(length(LinRange(0:0.1:system_size[2]))), LinRange(0:0.1:system_size[1]), fill(system_size[1], length(LinRange(0:0.1:system_size[2]))), LinRange(0:0.1:system_size[1]))
    y = vcat(LinRange(0:0.1:system_size[2]) , fill(system_size[2], length(LinRange(0:0.1:system_size[1]))), LinRange(0:0.1:system_size[2]), zeros(length(LinRange(0:0.1:system_size[1]))))

    return x, y
end

Create_LaTeXString(x) = [latexstring(x_i) for x_i in x]
;
