### the functions to calculate the ttc are defined ###

function ttc(a::agent, b::agent)

    cos_α = e_(a, b)⋅e_v(a, b)
    A = ((cos_α)^2-1)*d(a,b)^2+l(a, b)^2

    if A < 0 || -(cos_α)*d(a,b)-sqrt(A) < 0
        999
    else
        (-(cos_α)*d(a,b)-sqrt(A))/abs(Δv(a,b))
    end
end

function ttc(a::agent, b::agent, v_a::Float64)

    cos_α = e_(a, b)⋅e_v(a, b, v_a)
    A = ((cos_α)^2-1)*d(a,b)^2+l(a, b)^2

    if A < 0 || -(cos_α)*d(a,b)-sqrt(A) < 0
        999
    else
        (-(cos_α)*d(a,b)-sqrt(A))/abs(Δv(a,b,v_a))
    end
end

function ttc(a::agent, b::element)

    cos_α = e_(a, b)⋅a.heading
    A = (cos_α^2-1)*d(a,b)^2+l(a,b)^2

    if  A < 0 || (-cos_α*d(a,b) - sqrt(A)) < 0
        return 999
    else
        return (-cos_α*d(a,b) - sqrt(A))/a.vel
    end
end

function ttc(a::agent, b::element, v_a::Float64)


    cos_α = e_(a, b)⋅a.heading
    A = (cos_α^2-1)*d(a,b)^2+l(a,b)^2

    if  A < 0 || (-cos_α*d(a,b) - sqrt(A)) < 0
        return 999
    else
        return (-cos_α*d(a,b) - sqrt(A))/v_a
    end
end

function ttc(a::agent, b::agent, system_size::NTuple{2, Float64})

    cos_α = e_(a,b,system_size)⋅e_v(a, b)
    A = ((cos_α)^2-1)*d(a,b,system_size)^2+l(a, b)^2

    if A < 0 || -(cos_α)*d(a,b,system_size)-sqrt(A) < 0
        999
    else
        (-(cos_α)*d(a,b,system_size)-sqrt(A))/abs(Δv(a,b))
    end
end

function ttc(a::agent, b::agent, v_a::Float64, system_size::NTuple{2, Float64})

    cos_α = e_(a, b, system_size)⋅e_v(a, b, v_a)
    A = ((cos_α)^2-1)*d(a,b,system_size)^2+l(a, b)^2

    if A < 0 || -(cos_α)*d(a,b,system_size)-sqrt(A) < 0
        999
    else
        (-(cos_α)*d(a,b,system_size)-sqrt(A))/abs(Δv(a,b,v_a))
    end
end

function ttc(a::agent, b::element, system_size::NTuple{2, Float64})

    cos_α = e_(a, b, system_size)⋅a.heading
    A = (cos_α^2-1)*d(a,b,system_size)^2+l(a,b)^2

    if  A < 0 || (-cos_α*d(a,b,system_size) - sqrt(A)) < 0
        return 999
    else
        return (-cos_α*d(a,b,system_size) - sqrt(A))/a.vel
    end
end

function ttc(a::agent, b::element, v_a::Float64, system_size::NTuple{2, Float64})

    cos_α = e_(a, b ,system_size)⋅a.heading
    A = (cos_α^2-1)*d(a,b,system_size)^2+l(a,b)^2

    if  A < 0 || (-cos_α*d(a,b,system_size) - sqrt(A)) < 0
        return 999
    else
        return (-cos_α*d(a,b,system_size) - sqrt(A))/v_a
    end
end
;
