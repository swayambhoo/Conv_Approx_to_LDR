#!/usr/bin/env python2
# -*- coding: utf-8 -*-
"""
Created on Thu Feb 16 11:28:08 2017

@author: swayambhoo
"""

import numpy as np
from scipy.linalg import circulant
from multCirculant import multCirculantFFT
from numpy.fft import fft, ifft


def update_C_with_Data_fastest(AX, D, X, idxMtx, mu, c_ini):
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
    ctm1 = np.zeros(n)    
    i = 0
    
    # convergence flag
    converged_Flag = True 
    
    DtAXXt = np.dot(np.dot(D.T,AX),X.T)   # D'AXX'
    I = np.eye(n)

    while converged_Flag:
        
        dum = ct + (i/(3+i))*(ct - ctm1)    
        grad = np.dot(D.T, np.dot( np.dot( np.dot(D, multCirculantFFT(ct, X) ), X.T )) - DtAXXt
        ctm1 = ct
        ct = circProj((1-2*step*mu)*multCirculantFFT(ct,I) - step*grad)  # gradient step
        # Projection onto circulant set.
              
              
def circProj(X):
    """
    This function returns the first of the circulant matrix nearest to the 
    given n x n matrix X in the following sense: 
        min_{C is circulant} || C - X ||_F^2
    Input:  'X' -- The nxn matrix.
    Output: 'c' -- the first row of C.        
    """        
        
    n = X.shape[0]
    c = np.zeros(n)
    idx_c = np.arange(n)
    for i in np.arange(n):
       # c[i] =  np.choose( (idx_c + i)%n , X.T).sum()/n     
       c[i] = X[ idx_c, (idx_c + i)%n ].sum()/n
        
    return c

def circProjFFT_implementation(X, Idx):
    """
    This function returns the first of the circulant matrix nearest to the 
    given n x n matrix X in the following sense: 
        min_{C is circulant} || C - X ||_F^2 
    Above problem is converted to equivalent problem over the diagonal of C
         min_{c is vector} || diag(IIFT(c)) - X ||_F^2
    Input:  'X' -- The nxn matrix.
    Output: 'c' -- the first row of C.        
    """        
        
    n = X.shape[0]
    c = np.zeros(n)
    idx_c = np.arange(n)
    for i in np.arange(n):
       # c[i] =  np.choose( (idx_c + i)%n , X.T).sum()/n     
       c[i] = X[ idx_c, (idx_c + i)%n ].sum()/n
        
    return c