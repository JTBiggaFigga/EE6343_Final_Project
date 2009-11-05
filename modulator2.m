function [s,index]= modulator2(cnstl,M)

%   Generates random length M column vector of symbols from constellation with symbol 
%   energy given by Es.
%
%   CNSTL specifies the constellation, 
%     '02PSK' for binary phase shift keying, 
%     '04PSK' for quadrature phase shift keying
%     '08PSK' for octal phase shift keying, 
%     '16PSK' for 16-phase shift keying, 
%     '16QAM' for 16-quadrature amplitude modulation.  
%     '64QAM' for 64-quadrature amplitude modulation.  


if cnstl == '02PSK';
    h = modem.pskmod(2);
    index = randint(1,M,[0 1]);
    %s = modulate(h,index);
    s = pskmod(index,2);

elseif cnstl == '04PSK' ;
    h = modem.pskmod(4);
    index = randint(1,M,[0 3]);
    s = modulate(h,index);
    
elseif cnstl == '08PSK'
    h = modem.pskmod(8);
    index = randint(1,M,[0 7]);
    s = modulate(h,index);
    
elseif cnstl == '16PSK'  
    h = modem.pskmod(16);
    index = randint(1,M,[0 15]);
    s = modulate(h,index);

elseif cnstl == '16QAM'
    h = modem.qammod(16);
    index = randint(1,M,[0 15]);
    s = modulate(h,index);

elseif cnstl == '64QAM'
    h = modem.qammod(64);
    index = randint(1,M,[0 63]);
    s = modulate(h,index);
end
