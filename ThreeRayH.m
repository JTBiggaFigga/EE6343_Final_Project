function [output,H] = ThreeRayH(input,X,Y)

c = (randn(1)+i*randn(1))/sqrt(2);

Var_c1 = 1;
Var_c2 = 0;
Var_c3 = 0;

h = [sqrt(Var_c1)*c 0 0 sqrt(Var_c2)*c 0 0 0 0 0 0 sqrt(Var_c3)*c];
H = fft(h,48);

newLength = length(input(1,:));
output = [];

for m=1:size(input,1);
    newOutput = conv(input(m,:),h);
    %newOutput = filter(h,1,input(m,:));
    %newOutput = newOutput(end+1-80:end);
    output = [output ; newOutput];
end


