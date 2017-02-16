function [CX] = multCirculant(c,X)
% This function multiplies circulant matrix via FFT based implemention. 
% Inputs:   
%    1) 'c' is first row of circulant matrix
%    2) 'X' is the data matrix.
        [n,N] = size(X);
	CX = n*ifft( (ifft(c')*ones(1,N)).*fft(X)) ;
end
