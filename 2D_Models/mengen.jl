#gibt das maximum des schnitts von a & b
function max_vom_intervall_schnitt(a::NTuple{2, Float64}, b::NTuple{2, Float64})

        if a[1] > b[2] || a[2] < b[1]
            #schnitt ist leer
            return 0.0
        else
            #schnitt ist nicht leer
            return min(b[2], a[2])
        end
end

function max_vom_intervall_schnitt(a, b)

        if a[1] > b[2] || a[2] < b[1]
            #schnitt ist leer
            return 0.0
        else
            #schnitt ist nicht leer
            return min(b[2], a[2])
        end
end

#gibt den schnitt von a & b, dabei wird a = [a1, a2] bzw (a1, a2) als interval von a1 nach a2 angesehen
function ∩(a::NTuple{2, Float64}, b::NTuple{2, Float64})

        if a[1] > b[2] || a[2] < b[1]
            #schnitt ist leer
            (0.0, 0.0)
        else
            #schnitt ist nicht leer
            (max(a[1], b[1]),min(b[2], a[2]))
        end
end

function ∩(a::Vector{Float64}, b::Vector{Float64})

        if a[1] > b[2] || a[2] < b[1]
            #schnitt ist leer
            0.0
        else
            #schnitt ist nicht leer
            [max(a[1], b[1]),min(b[2], a[2])]
        end
end
;
