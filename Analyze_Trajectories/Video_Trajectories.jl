# Make Videos with GR

function Plot_Boundaries!(x, y, size, color)

    GR.setmarkertype(GR.MARKERTYPE_ASTERISK)
    GR.setmarkersize(size)
    GR.setmarkercolorind(color)
    GR.polymarker(x, y)

end

function Boundaries_Rectangle_Positions(system_size)

    x = vcat(zeros(length(LinRange(0:0.1:system_size[2]))), LinRange(0:0.1:system_size[1]), fill(system_size[1], length(LinRange(0:0.1:system_size[2]))), LinRange(0:0.1:system_size[1]))
    y = vcat(LinRange(0:0.1:system_size[2]) , fill(system_size[2], length(LinRange(0:0.1:system_size[1]))), LinRange(0:0.1:system_size[2]), zeros(length(LinRange(0:0.1:system_size[1]))))

    return x, y
end

function Plot_Agents!(menge::crowd, frame, size, color, size_2, color_2, abstand)

    GR.setmarkertype(GR.MARKERTYPE_SOLID_CIRCLE)
    GR.setmarkersize(size)
    GR.setmarkercolorind(color)

    x, y = XY_Frame(frame, menge)
    e_x, e_y = e_Frame(frame, menge)

    GR.polymarker(x, y)

    GR.setmarkertype(GR.MARKERTYPE_SOLID_CIRCLE)
    GR.setmarkersize(size_2)
    GR.setmarkercolorind(color_2)
    GR.polymarker(e_x.*abstand .+ x, e_y.*abstand .+ y)

end

function Plot_Agents!(menge::crowd, frame, size, color)

    GR.setmarkertype(GR.MARKERTYPE_SOLID_CIRCLE)
    GR.setmarkersize(size)
    GR.setmarkercolorind(color)

    x, y = XY_Frame(frame, menge)

    GR.polymarker(x, y)

end
