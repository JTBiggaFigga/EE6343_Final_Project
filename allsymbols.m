function symbolArray = allsymbols(constl)

% Provides an array of all possible symbols for a modulation scheme
% Possible modulation schemes: BPSK, QPSK, 8PSK, 16PSK, 16QAM

symbolArray = [];

% BPSK
if constl == '02PSK'
    symbolArray = [1, -1];

elseif constl == '04PSK'
    vec = 1:2:7;
    for a = 1:length(vec);
        symbolArray = [symbolArray exp(vec(a)*j*pi/length(vec))];
    end

elseif constl == '08PSK'
    vec = 1:2:15;
    for a = 1:length(vec);
        symbolArray = [symbolArray exp(vec(a)*j*pi/length(vec))];
    end
elseif constl == '16PSK'
    vec = 1:2:31;
    for a = 1:length(vec);
	symbolArray = [symbolArray exp(vec(a)*j*pi/length(vec))];
    end
elseif constl == '16QAM'
    num = -3:2:3;
    for real = 1:length(num);
	for imag = 1:length(num);
            symbolArray = [symbolArray num(real)+(j*num(imag)) ];
	end
    end
elseif constl == '64QAM'
    num = -7:2:7;
    for real = 1:length(num);
	for imag = 1:length(num);
	    symbolArray = [symbolArray num(real)+(j*num(imag)) ];
        end
    end
end





