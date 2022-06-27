d(x_1, y_1, x_2, y_2) = sqrt((x_1-x_2)^2+(y_1-y_2)^2)
d(x1, x2) = abs(x2 - x1)

d(data::CSV.File, k::Int, l::Int) = sqrt((data[k].x-data[l].x)^2+(data[k].y-data[l].y)^2)

d_1D(data::CSV.File, k::Int, l::Int) = abs(data[k].x-data[l].x)
dx_1D(data::CSV.File, k::Int, l::Int) = data[k].x-data[l].x


v_1D(data::CSV.File, k::Int, l::Int, Δt) = (data[l].x-data[k].x)/Δt

v(x_1, y_1, x_2, y_2, Δt) = ((x_2-x_1), (y_2-y_1))./(Δt)


v(data::CSV.File, k::Int, l::Int, Δt) = (data[l].x-data[k].x, data[l].y-data[k].y)./Δt



v(p_p2, p_p1, p_n1, p_n2, Δt) = (-p_p2 + 8*p_p1 - 8*p_n1 + p_n2)/(12*Δt)
v(p_1, p_2, Δt) = (p_2-p_1)/(2*Δt)


d_ttc_1d(Δv, δΔv, d, δd, l) = sqrt((sqrt(δd/Δv)^2)+((d-l)/(Δv)^2*δΔv)^2)

ttc_1d(Δv, d, l) = (d-l)/Δv

function ttc_1D(data::CSV.File, k1::Int, l1::Int, k2::Int, l2::Int, l, Δt)

    Δv = v_1D(data, k2, l2, Δt)-v_1D(data, k1, l1, Δt)

    if Δv == 0

        999.0

    else

        d_mean = (dx_1D(data, k2, k1)+dx_1D(data, l2, l1))/2

        (d_mean-l)/Δv

    end

end

function count_hist(hist)

    N = 0

    for x in hist

        N = N + x

    end

    N

end

function XY_Frame(i, menge::crowd)

    x, y = Vector{Float64}(), Vector{Float64}()

    for a in menge.agent

        if In_Frame(i, a) == true

            push!(x, X_Frame(i, a))
            push!(y, Y_Frame(i, a))

        end

    end

    x, y

end

function V_Frame(i, menge::crowd)

    v_x, v_y = Vector{Float64}(), Vector{Float64}()

    for a in menge.agent

        if In_Frame(i, a) == true

            push!(v_x, V_x_Frame(i, a))
            push!(v_y, V_y_Frame(i, a))

        end

    end

    v_x, v_y

end

function e_Frame(i, menge::crowd)

    e_x, e_y = Vector{Float64}(), Vector{Float64}()

    for a in menge.agent

        if In_Frame(i, a) == true

            e_xa, e_ya = e_Frame(i, a)

            push!(e_x, e_xa)
            push!(e_y, e_ya)

        end

    end

    e_x, e_y
end


function In_Frame(i::Int, a::agent)

    if i < a.frames[1] || i > a.frames[2]

        false

    else

        true

    end

end

function In_Frame(frames1::NTuple{2, Int}, a::agent)

    if frames[1] > a.frames[2] || a.frames[1] > frames[2]

        false

    else

        true

    end

end

Ind_Frame(i::Int, a::agent) = i+1-a.frames[1]
Find_Frames(frames, a::agent) = (max(a.frames[1], frames[1]), min(frames[2], a.frames[2]))


XY_Frame(i::Int, a::agent) = (a.x[Ind_Frame(i, a)],  a.y[Ind_Frame(i, a)])
X_Frame(i::Int, a::agent) = a.x[Ind_Frame(i, a)]
Y_Frame(i::Int, a::agent) = a.y[Ind_Frame(i, a)]


V_Frame(i::Int, a::agent) = (a.v_x[Ind_Frame(i, a)],  a.v_y[Ind_Frame(i, a)])
V_x_Frame(i::Int, a::agent) = a.v_x[Ind_Frame(i, a)]
V_y_Frame(i::Int, a::agent) = a.v_y[Ind_Frame(i, a)]

e_Frame(i::Int, a::agent) = normalize(V_Frame(i, a))

function X_Frame(frames::NTuple{2, Int}, a::agent)

    f = Find_Frames(frames, a)

    [X_Frame(i, a) for i in f[1]:f[2]]

end

function X_Frame(frames::NTuple{2, Int}, a::agent)

    f = Find_Frames(frames, a)

    [Y_Frame(i, a) for i in f[1]:f[2]]

end

function XY_Frame(frames::NTuple{2, Int}, a::agent)

    f = Find_Frames(frames, a)

    [(X_Frame(i, a), Y_Frame(i, a)) for i in f[1]:f[2]]

end


function V_x_Frame(frames::NTuple{2, Int}, a::agent)

    f = Find_Frames(frames, a)

    [V_x_Frame(i, a) for i in f[1]:f[2]]

end

function V_y_Frame(frames::NTuple{2, Int}, a::agent)

    f = Find_Frames(frames, a)

    [V_y_Frame(i, a) for i in f[1]:f[2]]

end

function V_Frame(frames::NTuple{2, Int}, a::agent)

    f = Find_Frames(frames, a)

    [(V_x_Frame(i, a), V_y_Frame(i, a)) for i in f[1]:f[2]]

end


e_Frame(frames::NTuple{2, Int}, a::agent) = [normalize(v) for v in V_Frame(frames, a)]
;
