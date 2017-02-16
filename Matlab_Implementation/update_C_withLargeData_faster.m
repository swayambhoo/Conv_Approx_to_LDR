function [c, C] = update_C_withLargeData_faster(A, D, X, R, mu, c_ini, C_ini)
% This funtions solves 
% arg min_{C} 0.5*|| AX - DCX ||_F^2 + mu||  C ||_F^2
% where 'C' is circulant matrix and 'mu'. It uses accelerated gradient 
% descent to solve above problem. 
% Inputs: 
%   1) A -- LDR matrix.
%   2) D -- The D matrix in optimization problem. 
%   3) X -- The data matrix.
%   4) R  -- The right rotation matrix 'R' in paper.
%   5) mu  -- Regularization parameter for C. It should >0.
%   4) c_int -- Initial value of first row of C_ini.
%   5) C_int -- Initial value of circulant matrix.
% Outputs: 
%   1) c -- First row of the circulant matrix.
%   2) C -- Full circulant matrix.

   L = 2*mu+2*norm(D)^2*norm(X)^2;
   step = 0.99/L;
   n = size(A,2);
   C = zeros(n); 
   nIter = 100;
   Cp = C;
   AX = A*X;
   
   Ct   = C_ini;
   Ctm1 = zeros(n);
   ct   = c_ini;
   ctm1 = zeros(n,1);
   
   for i = 1:nIter
        
        if i == 1
            dum = Ct;
        else
            dum = Ct + (i/(3+i))*(Ct - Ctm1);
        end
        
        grad = D'*(D*dum*X - AX)*X';
        dum = (1-2*step*mu)*dum - step*grad;
        
        ctm1 = ct;
        Ctm1 = Ct;
        
        ct = zeros(n,1);
        parfor j=1:n
            ct = ct + R^(j-1)*dum(j,:)'/n;
        end 
        
        parfor j=1:n 
           Ct(j,:) = ct'* R^(j-1);
        end
        
       % [i,norm(Ctm1 - Ct,'fro')/norm(Ctm1,'fro')];
        if norm(Ctm1 - Ct,'fro')/norm(Ctm1,'fro') < 0.0001
            %fprintf('C Opt. Over in %d iterations\n',i)
            break; 
        end

   end
   
   c = ct';
   C = Ct;
   
end
