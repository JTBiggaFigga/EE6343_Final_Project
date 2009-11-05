function shat = demodulator(y,cnstl)
%   Demodulates the given vector of symbols and return shat (bits). 
%   Use biterr to count bit errors
%
%   CNSTL specifies the constellation, 
%     '02PSK' for binary phase shift keying, 
%     '04PSK' for quadrature phase shift keying
%     '08PSK' for octal phase shift keying, 
%     '16PSK' for 16-phase shift keying, 
%     '16QAM' for 16-quadrature amplitude modulation.  
%     '64QAM' for 64-quadrature amplitude modulation.  
%
    
    if cnstl == '02PSK'
        H = modem.pskdemod(2);
        shat = demodulate(H,y);

    elseif cnstl == '04PSK'
        H = modem.pskdemod(4);
        %shat = demodulate(H,conj(h).*y);
        shat = demodulate(H,y);

    elseif cnstl == '08PSK'
        H = modem.pskdemod(8);
        %shat = demodulate(H,conj(h)*y);
        shat = demodulate(H,y);

    elseif cnstl == '16PSK'
        H = modem.pskdemod(16);
        %shat = demodulate(H,conj(h)*y);
        shat = demodulate(H,y);

    elseif cnstl == '16QAM'
        H = modem.qamdemod(16);
        %shat = demodulate(H,conj(h)*y);
        shat = demodulate(H,y);

    elseif cnstl == '64QAM'
        H = modem.qamdemod(64);
        %shat = demodulate(H,conj(h)*y);
        shat = demodulate(H,y);

    end
