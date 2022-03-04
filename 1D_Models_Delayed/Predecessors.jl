function Init_Predecessors!(menge::crowd)

    for (i, x) in enumerate(menge.agent)

        x.pred = mod(i, length(menge.agent))+1

    end

end

function Update_Predecessors!(menge::crowd, L)

    for (i, x) in enumerate(menge.agent)

        for (j, y) in enumerate(menge.agent)

            if d(x, y, L) < d(x, menge.agent[x.pred], L) && i != j

                x.pred = j

            end
        end
    end
end
