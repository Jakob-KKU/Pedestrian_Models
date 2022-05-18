using VoronoiCells
using GeometryBasics

function Pos_in_Point2(menge::crowd)

    Point{2, Float64}[x.pos for x in menge.agent]

end

function Pos_in_Point2(pos::Vector{Tuple{Float64, Float64}})

    Point{2, Float64}[x for x in pos]

end

function Calc_Tess_at_Step(i, positions, system_size)

    positions_in_scope = Find_Agents_In_Rectangle(positions[i, :], 0.0, system_size[1], 0.0, system_size[2])
    rect = Rectangle(Point2(0.0,0.0), Point2(system_size[1], system_size[2]))

    return voronoicells(Pos_in_Point2(positions_in_scope), rect);

end 

function Update_Voronoi_Dens!(menge::crowd, system_size::NTuple{2, Float64})

    rect = Rectangle(Point2(0.0,0.0), Point2(system_size[1], system_size[2]))

    tess = voronoicells(Pos_in_Point2(menge), rect)

    vor_density = 1 ./voronoiarea(tess)

    for (i, x) in enumerate(menge.agent)

        x.voronoi_dens = vor_density[i]

    end

end

function Find_Agents_In_Rectangle(positions, x_min, x_max, y_min, y_max)

    positions_in_scope = NTuple{2, Float64}[]

    for x in positions

        if x[1] < x_max && x[1] > x_min && x[2] < y_max && x[2] > y_min

            push!(positions_in_scope, x)

        end

    end

    return positions_in_scope

end
