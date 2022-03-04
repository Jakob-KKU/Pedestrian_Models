function variance(x::Matrix)

    x_mean = mean(x)

    varianz = 0

    for i in 1:size(x)[2]

        for j in 1:size(x)[1]

            varianz += (x[j,i]-x_mean)^2

        end

    end

    return varianz/(size(x)[1]*size(x)[2])
end

function variance(x::Vector)

    x_mean = sum(x)/length(x)
    varianz = 0

    for val in x

            varianz += (val-x_mean)^2

    end

    return varianz/(length(x))
end
