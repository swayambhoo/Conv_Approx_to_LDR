function [c] = update_C_withLargeData_fastest(AX, D, X, idxMtx, mu, c_ini, C_ini)
% This funtions solves 
% arg min_{C} 0.5*|| AX - DCX ||_F^2 + mu||  C ||_F^2
% where 'C' is circulant matrix and 'mu' is the regularization parameter. 
% This problem is solved by first transforming it into first row of 'C'. 
% Input: 
%   1) AX -- Matrix product of LDR matrix A and data matrix X
%   2) D  -- The post-processing matrix.
%   3) idxMtx -- Index matrix to convert the first row of the circulant
%                matrix to a n x n circulant matrix.
%   4) mu   -- Regularization parameter for C.   
%   4) c_int -- Initial value of first row of C.
%   5) C_ini -- Initial value of C.
% Output: 
%   1) c -- First row of the circulant matrix.

   L = 2*mu+2*norm(D)^2*norm(X)^2;
   step = 0.99/L;
   n = size(X,1);
   nIter = 100;
   ct   = c_ini';
   ctm1 = zeros(n,1);
  
   for i = 1:nIter
        
        if i == 1
            dum = ct;
        else
            dum = ct + (i/(3+i))*(ct - ctm1);
        end
        
        Ct = toeplitz([dum(1); dum(end:-1:2)] ,dum');
        grad = D'*(D*Ct*X - AX)*X';
        dum = (1-2*step*mu)*Ct - step*grad;
        
        ctm1 = ct;
        
        dum = dum' ;
        dum = reshape(dum(idxMtx(:)),n,n);
        ct = dum*ones(n,1)/n;     
        
        %[i,norm(ctm1 - ct,'fro')/norm(ctm1,'fro')]
        if norm(ctm1 - ct,'fro')/norm(ctm1,'fro') < 0.0001
            %fprintf('C Opt. Over in %d iterations\n',i)
            break; 
        end
        
   end   
   
   c = ct';

end

