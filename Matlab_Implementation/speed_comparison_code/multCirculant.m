function [CX] = multCirculant(c,X)
% This function multiplies circulant matrix whose 
% first row 'c' is with the data matrix 'X'.
        [n,N] = size(X);
	CX = n*ifft( (ifft(c')*ones(1,N)).*fft(X)) ;
end
