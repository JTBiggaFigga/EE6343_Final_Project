function output = runthis(cnstl)

% EE6343 Final Project - Fall 2009
% John W. Thomas - University of Texas at Dallas

%close all
clc

%cnstl = '16QAM'; 			% Now a function parameter
trials=1000;            		% # of trials for better averaging
SNRdB = [0 5 7 10 13 20 25 ];    	% SNR (dB), small range
%SNRdB = 0:30;    			% SNR (dB), large range
N=480;                 			% # of symbols per trial

nUSC=48;				% # of used subcarriers out of 80
nSamples = 80;             		% # of samples/symbol
rows = ceil(N/nUSC);			% # of rows in matrix form of symbols

num_intf = 3;               		% # of synchronous interferers
num_intfA = 3;               		% # of asynchronous interferers

%%----  File names ---%%
%savetxt = ['OFDM_Simulation_', cnstl, 'multi'];
%savetxt = ['OFDM_Simulation_', cnstl ];
savetxt = ['OFDM_Simulation_', cnstl, '_', num2str(num_intf), '_interference' ];
output = savetxt

%%--- Data Initialization ---%%
BER=zeros(2,length(SNRdB));		% BER for AWGN channel - 2-D for w and w/o interference
BERray = BER;           		%  BER initialized for rayleigh channel
BERmulti = BER;         		%  BER initialized for multipath channel
intf = {}; 				% Interference sum class
intfA = {}; 				% Interference sum class


for k=1:length(SNRdB);			% SNR Loop
    noisevar=10^(-SNRdB(k)/10);  	% noise variance from the SNR assuming Es=1(symbol energy)
    for tri=1:trials;			% trials Loop

        %%--- Data ---%%
        [x1 b] = modulator2(cnstl,N);  	% array of N random symbols - TX
        x = OFDM_DFT(x1,N,'TX');  	% IFFT - TX - size=10x80
        size(x);

	%%--- Pilots ---%%
        pilots = x(1,:);
	size(pilots);
        
        %%--- Synchronous Interference ---%%
        for f=1:num_intf
            [intf1 a] = modulator2(cnstl,N);  	% array of random symbols at TX
            intf{f} = OFDM_DFT(intf1,N,'TX');  	% interference class - IFFT - TX - size=10x80
        end

	%%--- Asynchronous Interference ---%%
	for f=1:num_intfA
	    [intf1 a] = modulator2(cnstl,N);    		% array of random symbols at TX
	    delay = unifrnd(1,80) * 50 * 10^-9; 		% time delay - uniform dist (1-80 samples)
	    intfA{f} = OFDM_DFT(intf1,N,'TX');   		% interference class - IFFT - TX - size=10x80
	    intfA{f} =  intfA{f} .* exp(-2i*pi*delay);
	end

        %%--- Complex Noise  ---%%
        noise=(randn(rows,nSamples)+1i*randn(rows,nSamples))/sqrt(2);  % complex Gaussian Noise
        size(noise);
        
        %%--- AWGN ---%%
        y1= x + sqrt(noisevar)*noise;  			% AWGN channel - no interference
        yI1 = y1;
        for f=1:num_intf
            yI1= yI1 + sqrt(noisevar)*intf{f};  	% AWGN channel - interference
        end
        size(y1);
        y = OFDM_DFT(y1,N,'RX');  			% FFT at RX
        yI = OFDM_DFT(yI1,N,'RX');  			% FFT at RX
        size(y);
        
        %%--- Rayleigh ---%%
        hray=(randn(rows,nSamples)+1i*randn(rows,nSamples))/sqrt(2); % Var(h) is 1
        yray1 = hray.*x + sqrt(noisevar)*noise;					% w/o interference
        %yray1 = filter2(hray,1,x) + sqrt(noisevar)*noise;
        yrayI1 = yray1;
        for f=1:num_intf
            hrayI=(randn(rows,nSamples)+1i*randn(rows,nSamples))/sqrt(2); % Var(h) is 1
            yrayI1 = yrayI1 + hrayI.*intf{f}*sqrt(noisevar);			% with interference
            %yrayI1 = yrayI1 + filter2(hrayI,1,intf{f})*sqrt(noisevar);
        end
        yray = OFDM_DFT(conj(hray) .* yray1,N,'RX');  				% FFT at RX
        yrayI = OFDM_DFT(conj(hray) .* yrayI1,N,'RX');  			% FFT at RX

        %%--- 3-ray Rayleigh ---%%
        [ymulti2,H] = ThreeRayH(x,rows,nSamples);
        [a,c] = size(ymulti2);
        noise2 =(randn(a,c)+1i*randn(a,c))/sqrt(2);
        ymulti1 = ymulti2 + sqrt(noisevar) * noise2;
        ymulti = OFDM_DFT(ymulti1,N,'RX');  % FFT at RX
        size(ymulti);
        size(H);
        for p = 1:size(ymulti,1);
            ymulti(p,:) = ymulti(p,:) .* conj(H);
        end

        y = reshape(y,1,N);
        yI = reshape(yI,1,N);
        yray = reshape(yray,1,N);
        yrayI = reshape(yrayI,1,N);
        ymulti = reshape(ymulti,1,N);

        bhat = demodulator2(y,cnstl);            % Receiver for AWGN channel
        bhatI = demodulator2(yI,cnstl);            % Receiver for AWGN channel
        bhatray = demodulator2(yray,cnstl);         % Receiver for Rayleigh channel
        bhatrayI = demodulator2(yrayI,cnstl);         % Receiver for Rayleigh channel
        bhatmulti = demodulator2(ymulti,cnstl);  % Receiver for Multipath channel
        
        size(b);
        size(bhat);

        [num, err] = biterr(b,bhat);
        [numI, errI] = biterr(b,bhatI);
        [numray, errray] = biterr(b,bhatray);
        [numrayI, errrayI] = biterr(b,bhatrayI);
        [nummulti, errmulti] = biterr(b,bhatmulti);
	
        BER(1,k)= BER(1,k) + err;          % error count for AWGN
        BER(2,k)= BER(2,k) + errI;          % error count for AWGN
        BERray(1,k)=BERray(1,k) + errray; % error count for Rayleigh
        BERray(2,k)=BERray(2,k) + errrayI; % error count for Rayleigh
        BERmulti(1,k)=BERmulti(1,k) + errmulti; % error count for Rayleigh
   
   end

end

figure
semilogy(SNRdB,BER(1,k)/trials,'-g^');
hold
semilogy(SNRdB,BER(2,k)/trials,'-go');
%semilogy(SNRdB,BERray(1,k)/trials,'-r^');
%semilogy(SNRdB,BERray(2,k)/trials,'-ro');
%semilogy(SNRdB,BERmulti(1,k)/trials,'-k^');
hold off

%eval(['title ', savetxt ])
title('BER Performace w/ Receiver Channel Knowledge') :1
ylabel('BER')
xlabel('Avg. SINR per RX Antenna (dB)')
%legend('AWGN - 0 interferers', ['AWGN - ',num2str(num_intf),' interferers'], 'Rayleigh - 0 interferers', ['Rayleigh - ',num2str(num_intf),' interferers'], '3-ray Rayleigh - 0 interferers');
%legend('AWGN', 'Rayleigh', 'Guassian Multipath');

save(savetxt)
saveas(gcf, [savetxt, '.fig'])
save2pdf(savetxt,gcf,600);

%clear all
