normalize(a::NTuple{2, Float64}) = a./abs(a)

Base.abs(a::NTuple{2, Float64}) = sqrt(a[1]^2+a[2]^2)
