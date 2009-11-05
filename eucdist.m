function distance = eucdist(x,y)

distance = (real(x)-real(y)).^2 + (imag(x)-imag(y)).^2;
