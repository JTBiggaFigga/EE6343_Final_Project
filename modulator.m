function [s,Es] = modulator(cnstl,M)

%   Generates random length M column vector of symbols from constellation with symbol 
%   energy given by Es.
%
%   CNSTL specifies the constellation, 
%     '02PSK' for binary phase shift keying, 
%     '04PSK' for quadrature phase shift keying
%     '08PSK' for octal phase shift keying, 
%     '16PSK' for 16-phase shift keying, 
%     '16QAM' for 16-quadrature amplitude modulation.  Returns symbol energy in Es.
%     '64QAM' for 64-quadrature amplitude modulation.  Returns symbol energy in Es.


if cnstl == '02PSK'
    Es = 1;
    for b = 1:M
        index = randint(1,1,[0 1]);
        s(b,1) = exp(index*j*pi);
    end

elseif cnstl == '04PSK' 
    Es = 1;
    vec = 1:2:7; % 4-PSK
    for b = 1:M 
        index = randint(1,1,[1 4]);
        s(b,1) = exp(vec(index)*j*pi/4);
    end 
    
elseif cnstl == '08PSK'
    Es = 1;
    vec = 1:2:15; % 8-PSK
    for b = 1:M
        index = randint(1,1,[1 8]);
        s(b,1) = exp(vec(index)*j*pi/8);
    end
    
elseif cnstl == '16PSK'  
    Es = 1;
    vec = 1:2:31; % 16-PSK
    for b = 1:M
        index = randint(1,1,[1 16]);
        s(b,1) = exp(vec(index)*j*pi/16);
    end
elseif cnstl == '16QAM'
    Es = 10;
    vec = -3:2:3;
    for b = 1:M
        for c = 1:2
            index(c) = randint(1,1,[1 4]);
        end
        s(b,1) = vec(index(1)) + j*vec(index(2));
    end
elseif cnstl == '64QAM'
    Es = 40.75;
    vec = -7:2:7;
    for b = 1:M
        for c = 1:2
            index(c) = randint(1,1,[1 8]);
        end
        s(b,1) = vec(index(1)) + j*vec(index(2));
    end
end
