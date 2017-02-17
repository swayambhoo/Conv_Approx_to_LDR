#!/usr/bin/env python2
# -*- coding: utf-8 -*-
"""
Created on Thu Feb 16 11:28:08 2017

@author: swayambhoo
"""

import numpy as np
from scipy.linalg import circulant

def update_C_with_Data_fastest(AX, D, X, idxMtx, mu, c_ini, C_ini) :
    """
   This funtions solves 
        arg min_{C} 0.5*|| AX - DCX ||_F^2 + mu||  C ||_F^2
   where 'C' is circulant matrix and 'mu' is the regularization parameter. 
   This problem is solved by first transforming it into first row of 'C'. 
   Input: 
       1) AX -- Matrix product of LDR matrix A and data matrix X
       2) D  -- The post-processing matrix.
       3) idxMtx -- Index matrix to convert the first row of the circulant
                matrix to a n x n circulant matrix.
       4) mu   -- Regularization parameter for C.   
       5) c_ini -- Initial value of first row of C.
       6) C_ini -- Initial value of C.
    Output: 
       1) c -- First row of the circulant matrix.
    """
    
    L = 2*mu + 2*np.linalg.norm(D,2)**2*np.linalg.norm(X,2)**2
    step = 0.99/L
    n = X.shape[0]
    
    # initialization
    c_t = c_ini
    ctm1 = np.zeros((1,n))    
    i = 0
    
    # convergence flag
    converged_Flag = True 
    
    DtAXXt = np.dot(np.dot(D.T,AX),X.T)   # D'AXX'

    
    
    while converged_Flag:
        
        dum = ct + (i/(3+i))*(ct - ctm1)    
        Ct = circulant(ct)
        
        grad = np.dot(D.T, np.dot( np.dot( np.dot(D, Ct), X ), X.T )) - DtAXXt
        ctm1 = ct
        Ct = (1-2*step*mu)*Ct - step*grad
        
        
        i = i + 1