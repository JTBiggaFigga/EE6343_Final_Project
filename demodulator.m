function shat = demodulator(y,cnstl)
    
    % Make hard decision, order output vector 

     if cnstl == '02PSK'
        if (real(y) >= 0)
            shat = 1;
			    
        elseif (real(y) < 0)
	    shat = -1;
	end

    elseif cnstl == '04PSK'
        if (real(y) >= 0) & (imag(y) >= 0) 
            shat = 1+j;
            
        elseif (real(y) < 0) & (imag(y) < 0)
            shat = -1-j;
            
        elseif (real(y) < 0) & (imag(y) >= 0)
            shat = -1+j;
            
        else shat = 1-j;
        end
        
    elseif cnstl == '08PSK'
        if (real(y) >= 0) & (imag(y) >= 0) & (angle(y)*180/pi < 45)
            shat = exp(j*pi/8);
        elseif (real(y) >= 0) & (imag(y) >= 0) & (angle(y)*180/pi >= 45)
            shat = exp(j*3*pi/8);
            
        elseif (real(y) >= 0) & (imag(y) < 0) & (angle(y)*180/pi >= -45)
            shat = exp(j*15*pi/8);
        elseif (real(y) >= 0) & (imag(y) < 0) & (angle(y)*180/pi < -45)
            shat = exp(j*13*pi/8);
            
        elseif (real(y) < 0) & (imag(y) >= 0) & (angle(y)*180/pi < 135)
            shat = exp(j*5*pi/8);
        elseif (real(y) < 0) & (imag(y) >= 0) & (angle(y)*180/pi >= 135)
            shat = exp(j*7*pi/8);
            
        elseif (real(y) < 0) & (imag(y) < 0) & (angle(y)*180/pi < -135)
            shat = exp(j*9*pi/8);
        elseif (real(y) < 0) & (imag(y) < 0) & (angle(y)*180/pi >= -135)
            shat = exp(j*11*pi/8);
        end
        
    elseif cnstl == '16PSK'
        if (real(y) >= 0) & (imag(y) >= 0) & (angle(y)*180/pi < 22.5)
            shat = exp(j*pi/16);
        elseif (real(y) >= 0) & (imag(y) >= 0) & (angle(y)*180/pi >= 22.5) & (angle(y)*180/pi < 45)
            shat = exp(j*3*pi/16);
        elseif (real(y) >= 0) & (imag(y) >= 0) & (angle(y)*180/pi >= 45) & (angle(y)*180/pi < 67.5)
            shat = exp(j*5*pi/16);
        elseif (real(y) >= 0) & (imag(y) >= 0) & (angle(y)*180/pi >= 67.25)
            shat = exp(j*7*pi/16);
            
        elseif (real(y) >= 0) & (imag(y) < 0) & (angle(y)*180/pi >= -22.5)
            shat = exp(j*31*pi/16);
        elseif (real(y) >= 0) & (imag(y) < 0) & (angle(y)*180/pi < -22.5) & (angle(y)*180/pi >= -45)
            shat = exp(j*29*pi/16);
        elseif (real(y) >= 0) & (imag(y) < 0) & (angle(y)*180/pi < -45) & (angle(y)*180/pi >= -67.5)
            shat = exp(j*27*pi/16);
        elseif (real(y) >= 0) & (imag(y) < 0) & (angle(y)*180/pi < -67.5)
            shat = exp(j*25*pi/16);
                        
        elseif (real(y) < 0) & (imag(y) >= 0) & (angle(y)*180/pi < 112.5)
            shat = exp(j*9*pi/16);
        elseif (real(y) < 0) & (imag(y) >= 0) & (angle(y)*180/pi >= 112.5) & (angle(y)*180/pi < 135)
            shat = exp(j*11*pi/16);
        elseif (real(y) < 0) & (imag(y) >= 0) & (angle(y)*180/pi >= 135) & (angle(y)*180/pi < 157.5)
            shat = exp(j*13*pi/16);
        elseif (real(y) < 0) & (imag(y) >= 0) & (angle(y)*180/pi >= 157.5)
            shat = exp(j*15*pi/16);
                      
        elseif (real(y) < 0) & (imag(y) < 0) & (angle(y)*180/pi < -157.5)
            shat = exp(j*17*pi/16);
        elseif (real(y) < 0) & (imag(y) < 0) & (angle(y)*180/pi >= -157.5) & (angle(y)*180/pi < -135)
            shat = exp(j*19*pi/16);
        elseif (real(y) < 0) & (imag(y) < 0) & (angle(y)*180/pi >= -135) & (angle(y)*180/pi < -112.5)
            shat = exp(j*21*pi/16);
        elseif (real(y) < 0) & (imag(y) < 0) & (angle(y)*180/pi >= -112.5)
            shat = exp(j*23*pi/16);
        end
    elseif cnstl == '16QAM'
        if (real(y) >= 0) & (imag(y) >= 0) & (real(y) > 2) & (imag(y) > 2)  
            shat = 3 + 3*j;
        elseif (real(y) >= 0) & (imag(y) >= 0) & (real(y) > 2) & (imag(y) < 2)
            shat = 3 + j;
        elseif (real(y) >= 0) & (imag(y) >= 0) & (real(y) < 2) & (imag(y) > 2)
            shat = 1 + 3*j;
        elseif (real(y) >= 0) & (imag(y) >= 0) & (real(y) < 2) & (imag(y) < 2)
            shat = 1 + j;
            
        elseif (real(y) >= 0) & (imag(y) < 0) & (real(y) > 2) & (imag(y) < -2)  
            shat = 3 - 3*j;
        elseif (real(y) >= 0) & (imag(y) < 0) & (real(y) > 2) & (imag(y) > -2)
            shat = 3 - j;
        elseif (real(y) >= 0) & (imag(y) < 0) & (real(y) < 2) & (imag(y) < -2)
            shat = 1 - 3*j;
        elseif (real(y) >= 0) & (imag(y) < 0) & (real(y) < 2) & (imag(y) > -2)
            shat = 1 - j;
                        
        elseif (real(y) < 0) & (imag(y) >= 0) & (real(y) < -2) & (imag(y) > 2)
            shat = -3 + 3*j;
        elseif (real(y) < 0) & (imag(y) >= 0) & (real(y) < -2) & (imag(y) < 2)
            shat = -3 + j;
        elseif (real(y) < 0) & (imag(y) >= 0) & (real(y) > -2) & (imag(y) > 2)
            shat = -1 + 3*j;
        elseif (real(y) < 0) & (imag(y) >= 0) & (real(y) > -2) & (imag(y) < 2)
            shat = -1 + j;
                      
        elseif (real(y) < 0) & (imag(y) < 0) & (real(y) < -2) & (imag(y) < -2)
            shat = -3 - 3*j;
        elseif (real(y) < 0) & (imag(y) < 0) & (real(y) > -2) & (imag(y) < -2)
            shat = -1 - 3*j;
        elseif (real(y) < 0) & (imag(y) < 0) & (real(y) < -2) & (imag(y) > -2)
            shat = -3 - j;
        elseif (real(y) < 0) & (imag(y) < 0) & (real(y) > -2) & (imag(y) > -2)
            shat = -1 - j;
        end
    elseif cnstl == '64QAM'
    end
