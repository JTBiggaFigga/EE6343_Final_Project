function [y,index,ychoice] = ZFreceiver(r,H,xchoice)

[N M] = size(H);

G = pinv(H);

for z=1:M;
    ng1(z) = norm(G(z,:)); % norm vector for rows
end

chk = 0;

while chk == 0
    [p index] = min(ng1);
    if xchoice(index) == 1
	xchoice(index) = 0;
	chk = 1;
    else
        ng1(index) = inf;
    end
end

ychoice = xchoice; % export modified input sequence

% Get weighting vector
w = G(index,:);

% Generate decision vector
y = w*r;
