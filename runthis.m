function output = runthis(cnstl)

% EE6390 Final Project - Spring 2009
% John W. Thomas - University of Texas at Dallas

%close all
clc
%cnstl = '16QAM';
trials=1000;            % # of trials for better averaging
%SNRdB = [0 5 7 10 13 20 25 ];    % SNR (dB)
SNRdB = 0:30;    % SNR (dB)
N=480;                 % # of symbols per trial

nUSC=48;
nSamples = 80;             % # of samples/symbol
rows = ceil(N/nUSC);

%savetxt = ['OFDM_Simulation_', cnstl, 'multi']
%savetxt = ['OFDM_Simulation_', cnstl ]
savetxt = ['OFDM_Simulation_', cnstl, '_interference' ]
output = savetxt;

BER=zeros(1,length(SNRdB));
BER2 = BER;           %  BER initialized for rayleigh channel
BER3 = BER;           %  BER initialized for rayleigh channel
BERray = BER;           %  BER initialized for rayleigh channel
BERray2 = BER;           %  BER initialized for rayleigh channel
BERmulti = BER;         %  BER initialized for multipath channel

for k=1:length(SNRdB);
    noisevar=10^(-SNRdB(k)/10);  % calculate the noise variance from the SNR assuming Es=1;
    
    for tri=1:trials;

        %%% Data %%%
        [x1 b] = modulator2(cnstl,N);  % array of random symbols at TX
        x = OFDM_DFT(x1,N,'TX');  % IFFT at TX
        size(x);
        
        %%% Interference %%%
        [intf1 a] = modulator2(cnstl,N);  % array of random symbols at TX
        [intf21 a] = modulator2(cnstl,N);  % array of random symbols at TX
        intf = OFDM_DFT(intf1,N,'TX');  % IFFT at TX
        intf2 = OFDM_DFT(intf21,N,'TX');  % IFFT at TX

        %%% Complex Noise  %%%
        noise=(randn(rows,nSamples)+i*randn(rows,nSamples))/sqrt(2);  % complex Gaussian Noise
        size(noise);
        
        %%% AWGN %%%
	y1= x + sqrt(noisevar)*noise;  % AWGN channel
	y12= x + sqrt(noisevar)*intf + sqrt(noisevar)*noise;  % AWGN channel
	y13= x + sqrt(noisevar)*intf + sqrt(noisevar)*intf2 + sqrt(noisevar)*noise;  % AWGN channel
        size(y1);
	y = OFDM_DFT(y1,N,'RX');  % FFT at RX
	y2 = OFDM_DFT(y12,N,'RX');  % FFT at RX
	y3 = OFDM_DFT(y13,N,'RX');  % FFT at RX
        size(y);
        
        %%% Rayleigh %%%
	hray=(randn(rows,nSamples)+i*randn(rows,nSamples))/sqrt(2); % Var(h) is 1
	hray1=(randn(rows,nSamples)+i*randn(rows,nSamples))/sqrt(2); % Var(h) is 1
        yray1 = hray.*x + sqrt(noisevar)*noise;
        yray21 = hray.*x + hray1.*intf*sqrt(noisevar) + sqrt(noisevar)*noise;
	yray = OFDM_DFT(conj(hray) .* yray1,N,'RX');  % FFT at RX
	yray2 = OFDM_DFT(conj(hray) .* yray21,N,'RX');  % FFT at RX

        %%% 3-ray Rayleigh %%%
        [ymulti2,H] = ThreeRayH(x,rows,nSamples);
        [a,c] = size(ymulti2);
        noise2 =(randn(a,c)+i*randn(a,c))/sqrt(2);
        ymulti1 = ymulti2 + sqrt(noisevar) * noise2;
        ymulti = OFDM_DFT(ymulti1,N,'RX');  % FFT at RX
        size(ymulti);
        size(H);
        for p = 1:size(ymulti,1);
            ymulti(p,:) = ymulti(p,:) .* conj(H);
        end

        y = reshape(y,1,N);
        y2 = reshape(y2,1,N);
        y3 = reshape(y3,1,N);
        yray = reshape(yray,1,N);
        yray2 = reshape(yray2,1,N);
        ymulti = reshape(ymulti,1,N);

        bhat = demodulator2(y,cnstl);            % Receiver for AWGN channel
        bhat2 = demodulator2(y2,cnstl);            % Receiver for AWGN channel
        bhat3 = demodulator2(y3,cnstl);            % Receiver for AWGN channel
        bhatray = demodulator2(yray,cnstl);         % Receiver for Rayleigh channel
        bhatray2 = demodulator2(yray2,cnstl);         % Receiver for Rayleigh channel
        bhatmulti = demodulator2(ymulti,cnstl);  % Receiver for Multipath channel
        
        size(b);
        size(bhat);

        [num, err] = biterr(b,bhat);
        [num2, err2] = biterr(b,bhat2);
        [num3, err3] = biterr(b,bhat3);
        [numray, errray] = biterr(b,bhatray);
        [numray2, errray2] = biterr(b,bhatray2);
        [nummulti, errmulti] = biterr(b,bhatmulti);
	
        BER(k)=BER(k) + err;          % error count for AWGN
        BER2(k)=BER2(k) + err2;          % error count for AWGN
        BER3(k)=BER3(k) + err3;          % error count for AWGN
        BERray(k)=BERray(k) + errray; % error count for Rayleigh
        BERray2(k)=BERray2(k) + errray2; % error count for Rayleigh
        BERmulti(k)=BERmulti(k) + errmulti; % error count for Rayleigh
   
   end

end

figure
semilogy(SNRdB,BER/trials,'-g^')
%semilogy(SNRdB,BERray/trials,'-r^');
hold
semilogy(SNRdB,BER2/trials,'-r^')
semilogy(SNRdB,BER3/trials,'-k^')
%semilogy(SNRdB,BERray2/trials,'-k^');
%semilogy(SNRdB,BERmulti/trials,'-k^');
hold off

%eval(['title ', savetxt ])
title('BER Performace in AWGN Channel w/ Receiver Channel Knowledge') :1
ylabel('BER')
xlabel('Avg. SINR per RX Antenna (dB)')
legend('0 interferers', '1 interferer', '2 interferers');
%legend('AWGN', 'Rayleigh', 'Guassian Multipath');

save(savetxt)
saveas(gcf, [savetxt, '.fig'])
save2pdf(savetxt,gcf,600);

%clear all
