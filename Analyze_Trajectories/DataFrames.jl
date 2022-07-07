using CSV
using DataFrames
using Statistics

function d(a::Vector, b::Vector, L)

    c = fill(0.0, length(a))

    for i in 1:length(a)

        dx = a[i] - b[i]

        if dx > L/2
            dx = dx - L
        elseif dx < -L/2
            dx = dx + L
        end

        c[i] = dx


    end

    c

end

function d(a::NTuple{2, Float64}, b::NTuple{2, Float64}, system_size::NTuple{2, Float64})
    dx = abs(a[1]-b[1])
    dy = abs(a[2]-b[2])

    if dx > system_size[1]/2
        dx = system_size[1] - dx
    end
    if dy > system_size[2]/2
        dy = system_size[2] - dy
    end

    return sqrt(dx^2 + dy^2)
end

function Init_Velocities!(df::DataFrame, k::Int, Δt::Float64, L)

    n = nrow(df)
    v_x = fill(0.0, n)
    v_y = fill(0.0, n)

    ids = unique(df[!, :ID])
    index = 0


    for i in ids

        df_ = df[(df.ID .== i), :]
        n_ = nrow(df_)

        v_x[index+k+1:index+n_-k] = d(df_[!, :x][2*k+1:end], df_[!, :x][1:end-2*k], L[1])./(2*k*Δt)
        v_y[index+k+1:index+n_-k] = d(df_[!, :y][2*k+1:end], df_[!, :y][1:end-2*k], L[2])./(2*k*Δt)

        index += n_

    end

    df[!, :v_x] = v_x
    df[!, :v_y] = v_y;

end

Base.abs(a, b) = sqrt(a^2+b^2)

ϕ(r::Float64, ξ::Float64) = r ≤ 2*ξ ? exp(-r^2/(2*ξ^2)) : 0.0

function v_Field(df::DataFrame, r, L, ξ)

    u_x, u_y, norm = 0.0, 0.0, 0.0

    for row in eachrow(df)

        ϕ_ = ϕ(d((row.x, row.y), r, L), ξ)

        u_x += ϕ_*row.v_x
        u_y += ϕ_*row.v_y
        norm += ϕ_

    end

    if norm == 0.0
        0.0, 0.0
    else
        u_x/norm, u_y/norm
    end

end

function rnd_v(v, w, x)

    v_r = fill(0.0, length(v))
    w_r = fill(0.0, length(v))

    for i in 1:length(v)

        if abs(v[i], w[i]) < x

            v_r[i], w_r[i] = 0.0, 0.0

        else

            v_r[i], w_r[i] = v[i], w[i]
        end

    end

    v_r, w_r

end

function Calc_V_Field(df_G, df, L, ξ, dx, dy)

    ID_Intruder = maximum(df.ID)
    frames = minimum(df.Frame):10:maximum(df.Frame)

    #Split data Frame from Intruder and Agents
    df_Obs = df[(df.ID .== ID_Intruder), :]
    df = df[(df.ID .< ID_Intruder), :]

    v_x = fill(0.0, nrow(df_G))
    v_y = fill(0.0, nrow(df_G))

    for fr in frames

        P_Obs = df_Obs[(df_Obs.Frame .== fr), :]

        #Calculate relative Positions in current Frame and Filter to relevant positions
        df_fr = df[
            (df.Frame .== fr) .&
            (-dx-2*ξ .≤ (df.x .- P_Obs.x) .≤ dx+2*ξ) .&
            (-dy-2*ξ .≤ (df.y .- P_Obs.y) .≤ dy+2*ξ), :]

        df_fr[!, :x] = df_fr[!, :x] .- P_Obs.x
        df_fr[!, :y] = df_fr[!, :y] .- P_Obs.y;

        for (i, row) in enumerate(eachrow(df_G))

            a_, b_ = v_Field(df_fr, (row.x[1], row.y[1]), L, ξ)
            v_x[i] += a_
            v_y[i] += b_
        end

    end

    v_x./length(frames), v_y./length(frames)

end

function Init_Vornoi_Area!(df, L)

    gdf = groupby(df, :Frame)
    rect = Rectangle(Point2(0.0, 0.0), Point2(L))


    for df_ in gdf

        points = [Point2(df_.x[i], df_.y[i]) for i in 1:nrow(df_)];
        tess = voronoicells(points, rect);
        df_[!, :A] = voronoiarea(tess)

    end

    gdf
end

function ρ_Field(df, r, L, ξ)

   A, norm = 0.0, 0.0

    for row in eachrow(df)

        if row.ID == 160

            ϕ_ = ϕ(d((row.x, row.y), r, L), 0.17)


        else

            ϕ_ = ϕ(d((row.x, row.y), r, L), ξ)

        end

        A += ϕ_*row.A
        norm += ϕ_

    end

    if norm == 0.0
        0.0
    else
        norm/A
    end

end


function Calc_ρ_Field(df_G, df, L, ξ, dx, dy)

    ID_Intruder = maximum(df.ID)
    frames = minimum(df.Frame):10:maximum(df.Frame)

    #Split data Frame from Intruder and Agents
    df_Obs = df[(df.ID .== ID_Intruder), :]
    #df = df[(df.ID .< ID_Intruder), :]

    A = fill(0.0, nrow(df_G));

    for fr in frames

        P_Obs = df_Obs[(df_Obs.Frame .== fr), :]

        #Calculate relative Positions in current Frame and Filter to relevant positions
        df_fr = df[
            (df.Frame .== fr) .&
            (-dx-2*ξ .≤ (df.x .- P_Obs.x) .≤ dx+2*ξ) .&
            (-dy-2*ξ .≤ (df.y .- P_Obs.y) .≤ dy+2*ξ), :]

        df_fr[!, :x] = df_fr[!, :x] .- P_Obs.x
        df_fr[!, :y] = df_fr[!, :y] .- P_Obs.y;

        for (i, row) in enumerate(eachrow(df_G))

           A[i] = A[i] + ρ_Field(df_fr, (row.x[1], row.y[1]), L, ξ)

        end

    end

    A./length(frames)

end
