### Works on its own is not connected to the code yet! ###
### As soon as N > 100, 200 it will be faster then the naive alg ###
### ALG from https://jaantollander.com/post/searching-for-fixed-radius-near-neighbors-with-cell-lists-algorithm-in-julia-language/


mutable struct agent

    pos::NTuple{2, Float64}
    l::Float64
    cell::CartesianIndex{2}
    neighbors_agents::Vector{Int}
end

struct CellList{d}
    indices::Dict{CartesianIndex{d}, Vector{Int}}
end

mutable struct crowd
    agent::Array{agent, 1}
    L::NTuple{2, Float64}
    N::Int
    Cells::CellList{2}
end

function Create_Crowd(N::Int, L::NTuple{2, Float64}, r)
    crowd([agent((0.0, 0.0), 0.3, CartesianIndex{2}(), fill(0, Max_N_in_R(N, r)+1)) for i in 1:N], L, N, CellList{2}(Dict{CartesianIndex{2}, Vector{Int}}()))
end

function Max_N_in_R(N::Int, r::Float64)

    ρ_max = 8.0

    min(N, Int(round(π*r^2*ρ_max)))

end

function Init_Rand_Pos!(menge::crowd)

    for (i, a) in enumerate(menge.agent)

        a.pos = (menge.L[1]*rand(), menge.L[2]*rand())
        count = 0

        while overlap(i, menge) == true && count < 10^2
            a.pos = (menge.L[1]*rand(), menge.L[2]*rand())
            count += 1
        end

    end

end

function overlap(current_agent::Int, menge::crowd)

    for i in 1:current_agent-1

        if d(menge.agent[current_agent], menge.agent[i]) < l(menge.agent[current_agent], menge.agent[i])
            return true
        end
    end

    false
end

l(u::agent, v::agent) = u.l/2 + v.l/2
d(a::agent, b::agent) =  sqrt((a.pos[1]-b.pos[1])^2+(a.pos[2]-b.pos[2])^2)

function Update_Near_Neighbors!(menge::crowd, r::T, offsets) where T<:AbstractFloat


    Delete_Neighbors!(menge)
    CellList!(menge, r)
    Near_Neighbors!(menge, r, offsets)

end

function Delete_Neighbors!(menge::crowd)

    for x in menge.agent
        for i in 1:x.neighbors_agents[1]
            x.neighbors_agents[i] = 0
        end
    end
end


function CellList!(menge::crowd, r::T, offset::Int=0) where T <: AbstractFloat

    @assert r > 0

    Clear_Cells!(menge)
    Update_Cells!(menge, r)

end

function Clear_Cells!(menge::crowd)

    for c in keys(menge.Cells.indices)
        menge.Cells.indices[c] .= 0
    end

end

function Update_Cells!(menge::crowd, r::Float64)

    for (i, a) in enumerate(menge.agent)

        a.cell = CartesianIndex(@. Int(fld(a.pos, r)))

        menge.Cells.indices[a.cell][menge.Cells.indices[a.cell][1]+2] = i
        menge.Cells.indices[a.cell][1] += 1

    end
end

function Near_Neighbors!(menge::crowd, r::T, offsets) where T <: AbstractFloat

    # Iterate all cells
    for (cell, is) in menge.Cells.indices

        if is[1] > 1

            brute_force!(is, menge, r)

            # Over neighboring cells
            for offset in offsets

                neigh_cell = cell + offset

                if haskey(menge.Cells.indices, neigh_cell) && menge.Cells.indices[neigh_cell][1] > 0
                    brute_force!(is, menge.Cells.indices[neigh_cell], menge, r)

                end
            end
        end
    end
end

@inline function brute_force!(is::Vector{Int}, menge::crowd, r::T) where T <: AbstractFloat

    for i in 2:(is[1]+1)

        a = menge.agent[is[i]]

        for j in (i+1):(is[1]+1)

            b = menge.agent[is[j]]

            if d(a, b) ≤ r
               @inbounds Add_as_Neighbors!(a, b, i, j)
            end
        end
    end
end

@inline function brute_force!(is::Vector{Int}, js::Vector{Int}, menge::crowd, r::T) where T <: AbstractFloat

    for i in 2:(is[1]+1)

        a = menge.agent[is[i]]

        for j in 2:(js[1]+1)

            b = menge.agent[js[j]]

            if @inbounds d(a, b) ≤ r
              @inbounds Add_as_Neighbors!(a, b, i, j)
            end
        end
    end
end

@inline function Add_as_Neighbors!(a::agent, b::agent, i, j)

        a.neighbors_agents[a.neighbors_agents[1]+2] = j
        a.neighbors_agents[1] += 1

        b.neighbors_agents[b.neighbors_agents[1]+2] = i
        b.neighbors_agents[1] += 1

end

function Init_Cells!(menge, r)

    max_ind = @. Int(fld(menge.L, r))
    max_N = Max_N_Cell(menge.N, r)

    for c in CartesianIndices((0:Int(menge.L[1]), 0:Int(menge.L[2])))
        menge.Cells.indices[c] = fill(0, max_N+1)
    end

end

function Max_N_Cell(N::Int, r::Float64)

    ρ_max = 8.0

    min(N, Int(round(r^2*ρ_max)))

end

@inline function neighbors(d::Int)
    [CartesianIndex(-1, -1), CartesianIndex(0, -1), CartesianIndex(1, -1), CartesianIndex(-1, 0)]
end
