function [y,index] = MLreceiver(r,H,cnstl)

[N,M] = size(H);

symbolList = allsymbols(cnstl);  % lists constellation symbols given constl
list = [];

for j = 1:length(symbolList);
    list(:,j) = eucdist(r, H * symbolList(j)).^2;   % size=[Nxlength(symbolList)]
end

%size(list)
w = sum(list);  % size=[1xlength(symbolList)]
[val, index] = min(w);  % size=[1x1]
y = symbolList(index);


