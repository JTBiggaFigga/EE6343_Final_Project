function [x, index] = MLreceiver(Y,h,sigma,cnstl)

symbolList = allsymbols(cnstl);  % lists constellation symbols given constl
list = [];
sum = zeros(1,size(Y,1));
x = zeros(size(Y,1),size(Y,2));

for i = 1:size(Y,1)
    for j = 1:size(Y,2)
        list = (1/size(Y,2)) * (parzen_func(sigma, Y(i,j) - h(j) .* symbolList));
        [val, index] = max(list);  % size=[1x1]
        x(i,j) = symbolList(index);
    end
end

