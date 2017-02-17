#!/usr/bin/env python2
# -*- coding: utf-8 -*-
"""
Created on Thu Feb 16 14:05:16 2017

@author: swayambhoo
"""

import numpy as np
from scipy.linalg import circulant 
import time as time
from multCirculant import multCirculantFFT, multCirulantMatVec

# Creating the data
m = 300    # Number of measurements or the demension of the LDR
n = 16000  # The ambient dimensionality of the data points
N = 1000   # Number of points in the training set
A = np.random.randn(m,n)   # The LDR matrix
X = np.random.randn(n,N)   # The data matrix 
AX = np.dot(A,X)

cr = np.random.randn(n)    # first row of circulant matrix stored in flattened format
cc = np.hstack( (cr[0],cr[:0:-1]) )  # first column of circulant matrix stored in flattened format
cMtx = circulant( cc )

nTrials = 20
t1 = 0.0 
t2 = 0.0
error = 0.0
for i in np.arange(nTrials):
    x = np.random.randn(n,1)
    t = time.time()
    Cx1 = multCirulantMatVec(cMtx,x)
    t1 = t1 + (time.time() - t)
    
    t = time.time()
    Cx2 = multCirculantFFT(cc, x)
    t2 = t2 + (time.time()-t) 
    error = error + np.linalg.norm(Cx1 - Cx2)
    
t1 = t1/nTrials
t2 = t2/nTrials
error = error/nTrials
print t1
print t2
print error 