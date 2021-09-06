using VoronoiCells
using GeometryBasics

function Pos_in_Point2(menge::crowd)

    Point{2, Float64}[x.pos for x in menge.agent]

end

function Update_Voronoi_Dens!(menge::crowd, system_size::NTuple{2, Float64})

    rect = Rectangle(Point2(0.0,0.0), Point2(system_size[1], system_size[2]))

    tess = voronoicells(Pos_in_Point2(menge), rect)

    vor_density = 1 ./voronoiarea(tess)

    for (i, x) in enumerate(menge.agent)

        x.voronoi_dens = vor_density[i]

    end

end
