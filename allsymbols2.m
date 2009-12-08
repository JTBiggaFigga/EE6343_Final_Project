function symbolArray = allsymbols(constl)

% Provides an array of all possible symbols for a modulation scheme
% Possible modulation schemes: BPSK, QPSK, 8PSK, 16PSK, 16QAM

symbolArray = [];

% BPSK
if constl == '02PSK'
    symbolArray = [0 1];

elseif constl == '04PSK'
    symbolArray = [0 3];

elseif constl == '08PSK'
    symbolArray = [0 7];

elseif constl == '16PSK'
    symbolArray = [0 15];

elseif constl == '16QAM'
    symbolArray = [0 15];

elseif constl == '64QAM'
    symbolArray = [0 63];





