function Perceivable(a::agent, b::agent, menge::crowd, geometrie::geometry, system_size)
    true
end

function Perceivable(a::agent, b::element, menge::crowd, geometrie::geometry, system_size)
    true
end

function Perceivable(a::agent, b::agent, menge::crowd, geometrie::geometry)
    true
end

function Perceivable(a::agent, b::element, menge::crowd, geometrie::geometry)
    true
end
;
