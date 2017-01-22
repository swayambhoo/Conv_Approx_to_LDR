function [c, P] = update_CP_withdata(A, data, iFdata, Dint, Rt, mu, iter_max, epsilon)
% This function solves the following problem:
% min_{P,C} 0.5*||AX - PCX||_F^2 + mu || C ||_F^2 
% using alternating minimization. Here P is row subselection matrix of 
% size same as A and mu > 0 is the regularization parameter.
% Inputs: 
%   1) A -- LDR matrix.
%   2) data -- Data matrix with data along its columns. 
%   3) iFdata -- Inverse Fourier transform of data matrix. 
%   4) Dint -- Initial value of P.
%   5) Rt  -- Transpose of right rotation matrix 'R' in paper. 
%   6) mu  -- Regularization parameter for C. It should >0.
%   7) iter_max -- Maximum number of iterations.
%   8) epsilon -- parameter for convergence.
% Outputs: 
%   1) c -- First row of the circulant matrix.
%   2) P -- The row subselection matrix.

    [m,n] = size(A);    
    P = Dint;
    R = sparse([ zeros(1,n-1), 1;  eye(n-1), zeros(n-1,1) ]'); 
    fVal= zeros(1, iter_max);
    c_p = zeros(1,n); 
    C_p = zeros(n,n);
    
    for i=1:iter_max
       
        fprintf('[iCPOpt: %d] \n', i)
        fprintf('updating C \n')
        tic;
	    [c, C] = update_C_withLargeData_faster(A, P, data, R, mu, c_p, C_p);
        toc;
        fprintf('updating P \n')
        tic;
        P = update_P(A, c, data); 
	    toc;
        
	% Checking Convergence
        n = size(A,2);
        fVal(i) =  0.5*norm(A*data-P*multCirculant(c,data), 'fro')^2 + mu*n*norm(c, 'fro')^2 ; 
        
        if i ~= 1
            if (fVal(i-1) > fVal(i))
                if abs(fVal(i) - fVal(i-1))/abs(fVal(i-1)) <= epsilon
                    break;
                end 
            else
                % use previous value of matrices because objective
                % function has increased
                c = c_p; 
                P = P_p;
                break;
            end 
        end
        
        c_p = c; 
        C_p = C;
        P_p = P;        
    end 
 
