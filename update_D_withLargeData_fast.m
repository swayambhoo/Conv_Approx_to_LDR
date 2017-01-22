function [ D ] = update_D_withLargeData_fast(A, C, X, rho, D_ini)
% This funtions solves 
% arg min_{D} 0.5*|| AX - DCX ||_F^2 + rho*|| D ||_{2,1} 
% by transforming it to a transpose form as 
% arg min_{D} 0.5*|| X'A' - X'C'D||_F^2 + rho*|| D' ||_{1,2} and solves 
% it via accelerated proximal gradient algorithm.
% Final output is obtained by transposing the solution
% of the above problem. 
% Input:
%   1) A -- The LDR matrix.
%   2) C -- The circulant matrix.
%   3) X -- The data matrix. 
%   4) rho -- The regularization parameter for D.
%   5) D_ini -- Initial value of D. 
% Output:
%   1) D -- The post-processing matrix D.
    
    CXt = (C*X)';
    AXt = (A*X)';
    nIter = 100;
    
    L = norm(CXt)^2;
    
    step = .99/L;
    
    dum = step*CXt'*AXt;
    %rho_max = max(sqrt(sum(dum.^2, 2)));
    %rho = rho*rho_max;
    
    Dt = D_ini;
    Dtm1 = zeros(size(A'));
    for i = 1:nIter
        
        if i == 1
            dum = Dt;
        else
            dum = Dt + (i/(3+i))*(Dt - Dtm1);
        end
        dum = dum - step*CXt'*(CXt*Dt - AXt);
        v = 1 - rho./sqrt(sum(dum.^2, 2));
        v(v<0) = 0;
        Dtm1 = Dt;
        
        Dt = bsxfun(@times, v, dum);
        if norm(Dt) == 0
           break;  
        end
        %[i, norm(Dtm1 - Dt,'fro')/norm(Dt,'fro')];
         if norm(Dtm1 - Dt,'fro')/norm(Dt,'fro') < 0.00001
            %fprintf('D Opt. Over in %d iterations\n',i)
            break; 
         end
        
    end
    
    D = Dt'; 
end
