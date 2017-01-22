function [ P ] = update_P(A, c, Y)
% This funtions solves 
% arg min_{P} 0.5*|| AY - PCY ||_F^2 
% by transforming it to a linear program as described in the paper. 
% Inputs: 
%   1) A -- The given LDR matrix. 
%   2) c -- First row of the ciruclant matrix C.
%   3) Y -- The data matrix.
% Outputs:
%   1) P -- The row subselection matrix.

    [m,n] = size(A);
    CY = real(multCirculant(c,Y)); 
    AY = A*Y;
    W1 = zeros(m,n);
    for i = 1:m
        dum = CY - ones(n,1)*AY(i,:);
        W1(i,:) = sum(dum.^2, 2); 
    end
    W1t = W1';
    f = W1t(:);
    Aeq = kron(eye(m), ones(1,n));
    beq = ones(m,1);
    A = kron(ones(1,m), eye(n));
    b = ones(n,1);
    lb = zeros(n*m,1);
    ub = ones(n*m,1);
    ub(:) = inf;
    p = linprog(f,A,b,Aeq,beq,lb,ub);
    P = reshape(p,n,m)';
end
