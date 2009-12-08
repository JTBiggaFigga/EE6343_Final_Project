function output = runthis(cnstl)

% EE6343 Final Project - Fall 2009
% John W. Thomas and Trevor Toland - University of Texas at Dallas

%close all
clc

%cnstl = '04PSK'; 			% Now a function parameter
trials=100;	            		% # of trials for better averaging
%SNRdB = [-10 0 10 ];   			% SNR (dB), smaller range
%SNRdB = [-10 -7 -5 0 5 7 10 15 20 ];  	% SNR (dB), small range
SNRdB = -10:30;    			% SNR (dB), large range
N=48;                 			% # of symbols per trial

nUSC=48;				% # of used subcarriers out of 80
nSamples = 80;             		% # of samples/symbol
rows = ceil(N/nUSC);			% # of rows in matrix form of symbols

num_intf = 2;               		% # of synchronous interferers
num_intfA = 0;               		% # of asynchronous interferers

%%----  File names ---%%
%savetxt = ['OFDM_Simulation_', cnstl, 'multi'];
%savetxt = ['OFDM_Simulation_', cnstl ];
savetxt = ['OFDM_Simulation_', cnstl, '_', num2str(num_intf), 'x', num2str(num_intfA), '_intf' ];
output = savetxt;

%%--- Data Initialization ---%%
BER=zeros(2,length(SNRdB));		% BER for AWGN channel - 2-D for w and w/o interference
intf = {}; 				% Interference sum class
intfA = {}; 				% Interference sum class


for k=1:length(SNRdB);			% SNR Loop
    SNRdB(k)
    noisevar=10^(-SNRdB(k)/10);  	% noise variance from the SNR assuming Es=1(symbol energy)
    for tri=1:trials;			% trials Loop
  	tri
        %%--- Data ---%%
        [x1 b] = modulator2(cnstl,N);  	% array of N random symbols - TX
        x = OFDM_DFT(x1,N,'TX');  	% IFFT - TX - size=10x80
        size(x);
	
        %%--- Received Pilots ---%%
        pilots_x = x(1:rows:nUSC);
	size(pilots_x);
        
        %%--- Synchronous Interference ---%%
        for f=1:num_intf
            [intf1 a] = modulator2(cnstl,N);  	% array of random symbols at TX
            intf{f} = OFDM_DFT(0.3.*intf1,N,'TX');  	% interference class - IFFT - TX - size=10x80
        end

	%%--- Asynchronous Interference ---%%
	for f=1:num_intfA
	    [intf1 a] = modulator2(cnstl,N);    		% array of random symbols at TX
	    delay = unifrnd(1,80) * 50 * 10^-9; 		% time delay - uniform dist (1-80 samples)
	    intfA{f} = OFDM_DFT(0.3.*intf1,N,'TX');   		% interference class - IFFT - TX - size=10x80
	    intfA{f} =  intfA{f} .* exp(-2i*pi*delay);
	end

        %%--- Complex Noise  ---%%
        noise=(randn(rows,nSamples)+1i*randn(rows,nSamples))/sqrt(2);  % complex Gaussian Noise
        size(noise);
        
        %%--- AWGN ---%%
        y1 = 0.4.*x + sqrt(noisevar)*noise;  			% AWGN channel - no interference
        yI1 = 0.8.*x + sqrt(noisevar)*noise;  			% AWGN channel - no interference
        for f=1:num_intf
            %yI1= 0.7.*yI1 + sqrt(noisevar)*intf{f};  	% AWGN channel - synch interference
        end
	for f=1:num_intfA
	    %yI1= yI1 + sqrt(noisevar)*intfA{f};         % AWGN channel - asynch interference
        end

        size(y1);
        y = OFDM_DFT(y1,N,'RX');  			% FFT at RX
        yI = OFDM_DFT(yI1,N,'RX');  			% FFT at RX
        yI2 = OFDM_DFT(yI1,N,'RX');  			% FFT at RX
        size(y);
        
        %%--- Received Pilots ---%%
        pilots_y = y(1,:);
        pilots_yI = yI(1,:);

	%%--- Channel Estimation ---%%
	if tri == 1
	    h_new = pilots_y ./ pilots_x;
	    h_newI = pilots_yI ./ pilots_x;
	else
	    sigma = sqrt(noisevar);
	    h_old = h_new;
	    h_oldI = h_newI;
	    %h_new = NPML_chan_est(pilots_x, pilots_y, h_old, sigma, nUSC);
	    %h_newI = NPML_chan_est(pilots_x, pilots_yI, h_oldI, sigma, nUSC)
	end
	
 	%%--- ML Receiver ---%%
	%xhat = MLreceiver(y, h_new, noisevar,cnstl) ;
	%xhatI = MLreceiver(yI, h_newI, noisevar,cnstl) ;

	y = reshape(y,1,N);
	yI = reshape(yI,1,N);
	yI2 = reshape(yI2,1,N);
	bhat = demodulator2(y, cnstl);        		% Receiver for AWGN channel
        bhatI = demodulator2(yI, cnstl);            	% Receiver for AWGN + interference channel
        bhatI2 = demodulator2(yI2, cnstl);            	% Receiver for AWGN + interference channel
        
        size(b);
	b;
        size(bhat);
	bhat;
        size(bhatI);
	bhatI;

        [num, err] = biterr(b,bhat);
        [numI, errI] = biterr(b,bhatI);
        [numI2, errI2] = biterr(b,bhatI2);

	BER(1,k)= BER(1,k) + err;          % error count for AWGN
        BER(2,k)= BER(2,k) + errI;          % error count for AWGN
        BER(3,k)= BER(2,k) + errI;          % error count for AWGN
   
   end

end

figure
semilogy(SNRdB,BER(1,:)/trials,'-g^');
hold on;
semilogy(SNRdB,BER(2,:)/trials,'-ro');
%semilogy(SNRdB,BER(3,:)/trials,'-k+');
hold off;

%eval(['title ', savetxt ])
title([ cnstl,  ' Performace ']) 
ylabel('BER')
xlabel('Avg. SINR per RX Antenna (dB)')
legend('LS - 2 synch interferers', 'NPML - 2 synch interferers');
%legend('AWGN - 2 synch interferers', ['AWGN - ',num2str(num_intf),' synch + 2 asynch interferers']);
%legend('LS AWGN - 2 synch interferers', ['NPML AWGN - ',num2str(num_intf),' synch interferers']);

save(savetxt)
saveas(gcf, [savetxt, '.fig'])
save2pdf(savetxt,gcf,600);

%clear all
