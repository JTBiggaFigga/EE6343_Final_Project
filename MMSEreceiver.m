function [y,index,ychoice] = MMSEreceiver(r,H,SNR,Es,sigma_h_sq,xchoice)

[N M] = size(H);

rho = (Es*M*2*sigma_h_sq)/(10^(SNR/10));
G = inv(H'*H+rho/2*eye(M,M))*H';

for z=1:M;
    ng1(z) = (Es*(G(z,:)*H(:,z))^2) / (G(z,:)*(G(z,:))'*(rho/2) + sum(G(z,:)*H(:,z)*Es)); % jth SINR
end

chk = 0;

while chk == 0
    [p index] = max(ng1);
    if xchoice(index) == 1
	xchoice(index) = 0;
	chk = 1;
    else
        ng1(index) = -inf;
    end
end

ychoice = xchoice; % export modified input

% Get weighting vector
w = G(index,:);

% Generate decision vector
y = w*r;
