function [c, D] = update_CD_withdata_new(A, data, Dint, rho, mu, iter_max, epsilon)
% This function solves the following problem:
% min_{D,C} 0.5*||AX - DCX||_F^2 + mu || C ||_F^2 + rho || D ||_{2,1}
% using alternating minimization. Here D is the post-processing matrix 
% subselection matrix of size same as A and mu, rho > 0 are the 
% regularization parameters.
% Input: 
%   1) A -- LDR matrix.
%   2) data -- Data matrix with data along its columns. 
%   3) Dint -- Initial value of D. 
%   4) rho  -- Regularization parameter for D.   
%   5) mu   -- Regularization parameter for C.   
%   6) iter_max -- Maximum number of iterations.
%   7) epsilon -- parameter for convergence.
% Output: 
%   1) c -- First row of the circulant matrix.
%   2) D -- The post processing matrix.

    [m,n] = size(A);    
    D = Dint; 
    R = sparse([ zeros(1,n-1), 1;  eye(n-1), zeros(n-1,1) ]'); 
    fVal= zeros(1, iter_max);
    
    c_p = zeros(1,n); 
    C_p = zeros(n,n);
    D_p = zeros(m,n);
    
   idxMtx = reshape(1:n^2,n,n);
   idx = 1:n;

   for i = 1:n
      idxMtx(:,i) = R^(i-1)*idxMtx(:,i); 
   end

    AX = A*data;
    
    for i=1:iter_max
        
        fprintf('[iCDOpt: %d] \n', i)
        fprintf('updating C \n')
        tic; 
        c = update_C_withLargeData_fastest(AX, D, data, idxMtx, mu, c_p, C_p);
        C = zeros(n);
        parfor j=1:n 
           C(j,:) = c*R^(j-1);
        end
        toc;
        fprintf('updating D \n')
        tic;
        D = update_D_withLargeData_fast(A, C, data, rho, D_p'); 
        toc;
        
        % Checking Convergence
        Dnorm = sum(sqrt(ones(1, m)*(D.^2))); 
        fVal(i) =  0.5*norm(A*data-D*multCirculant(c,data), 'fro')^2 + rho*Dnorm + mu*n*norm(c, 'fro')^2 ; 
        
        if i ~= 1
            if (fVal(i-1) > fVal(i))
                if abs(fVal(i) - fVal(i-1))/abs(fVal(i-1)) <= epsilon
                    break;
                end 
            else
                % use previous value of matrices because objective
                % function has increased
                c = c_p; 
                D = D_p;
                break;
            end 
        end
        
        c_p = c; 
        C_p = C;
        D_p = D;
        
        if norm(D) == 0 
            break
        end
        
    end 
 
