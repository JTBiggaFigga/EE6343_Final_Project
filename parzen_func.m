function result = parzen_func(sigma,y)

result = ((2 * pi * sigma^2)^(-1/2)) .* exp( -1 .* ( abs(y) ./ (2 * sigma^2)));
