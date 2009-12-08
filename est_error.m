function result = est_error(i, x, y, h, num_subs)

sum = 0;

for L = 1:num_subs
	sum = h .* exp(-2j * pi * i * (L-1) * (1/num_subs)); 
end

result = y(i) - (sum .* x(i)); 
