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
;
