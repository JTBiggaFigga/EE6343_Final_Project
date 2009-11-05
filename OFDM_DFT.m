function output = OFDM_DFT(input,N,status)

nFFT        = 64; % fft size
nUSC        = 48; % # of used subcarriers
%nBitPerSym  = nUSC;
%nSym        = 10^2; % number of symbols
CP          = 16;   % number of samples in CP

% Transmitter
if strcmp(status,'TX');
    rows = ceil(N/nUSC);
    ModX = reshape(input,rows,nUSC); % reshaping (Num of Symbols/Num of Used Subcarriers) x Num of Used Subcarriers
	    
    % Assigning modulated symbols to subcarriers from [-24 to -1, +1 to +24]
    X = [zeros(rows,8) ModX(:,:) zeros(rows,8)] ;
    size(X);
		  
    % Taking FFT, the term (nFFT/sqrt(nDSC)) is for normalizing the power of
    x = sqrt(nFFT) .* ifft(X.',nFFT).';
    %x = X;
    size(x);
			 
    % Appending cylic prefix 16 samples
    x_end = [x(:,end-CP+1:end) x];
    size(x_end);
 
    output = x_end;
				
% Receiver
elseif strcmp(status,'RX'); 
   y = input(:,CP+1:end); % removing cyclic prefix
   size(y);
	
   % converting to frequency domain
   Y = 1/sqrt(64) .* fft(y.',nFFT).'; 
   %Y = y; 
   size(Y);
	       
   % extracting the required data subcarriers
   ModY = Y(:,8+[1:nUSC] );
   size(ModY);

   output = ModY;
		     
else
    display('Please enter OFDM DFT status');
end
