
function plot_agents(positions, size, color) #1D

    GR.setmarkertype(GR.MARKERTYPE_SOLID_CIRCLE)
    GR.setmarkersize(size)
    GR.setmarkercolorind(color)
    GR.polymarker(positions, 0 .*positions)

end

;
