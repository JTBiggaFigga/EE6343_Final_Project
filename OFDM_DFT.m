function output = OFDM_DFT(input,N,status)

nFFT        = 64; 			% fft size
nUSC        = 48; 			% # of used subcarriers
CP          = 16;   			% # of samples in cyclic prefix

% Transmitter - TX
if strcmp(status,'TX');
    rows = ceil(N/nUSC);
    ModX = reshape(input,rows,nUSC); 	% 10x48 (Num of Symbols/Num of Used Subcarriers) x Num of Used Subcarriers
	    
    % Assigning modulated symbols to subcarriers from [-24 to -1, +1 to +24]
    X = [zeros(rows,8) ModX(:,:) zeros(rows,8)] ;  % size = 10x64
    size(X);
		  
    % Taking FFT, the term (nFFT/sqrt(nDSC)) is for normalizing the power 
    x = sqrt(nFFT) .* ifft(X.',nFFT).';
    %x = X;
    size(x);
			 
    % Appending cylic prefix 16 samples
    x_end = [x(:,end-CP+1:end) x]; 	% size = 10x80
    size(x_end);

    output = x_end;
				
% Receiver - RX
elseif strcmp(status,'RX'); 
   y = input(:,CP+1:end); 		% removing cyclic prefix, size=10x64
   size(y);
	
   % converting to frequency domain
   Y = 1/sqrt(64) .* fft(y.',nFFT).'; 
   %Y = y; 
   size(Y);
	       
   % extracting the required data subcarriers
   ModY = Y(:,8+[1:nUSC] );
   size(ModY);

   output = ModY; 			%size = 10x48

else
    display('Please enter OFDM DFT status');
end
