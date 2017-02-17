#!/usr/bin/env python2
# -*- coding: utf-8 -*-
"""
Created on Thu Feb 16 14:05:16 2017

@author: swayambhoo
"""

import numpy as np
from numpy.fft import fft , ifft

def multCirulantMatVec(C,X):
    """
    Returns circulant matrix multiplication via standard matrix multiplication.
    Inputs: 
        1) 'C' is the circulant matrix in 2d array format
        2) 'X' is the data matrix columns in 2d nparray format
    Output:
        Multiple of circulant matrix and data vector in 2d nparray format
    """
    return np.dot(C,X)


def multCirculantFFT(c, X):
    """ This function multiplies circulant matrix via FFT based implementation.
        Inputs:
            1) 'c' is the first column of the circulant matrix in flattened format
            2) 'X' is the data matrix with data points as its columns in 2d nparray format
        Output: 
            Multiple of circulant matrix and data vector in flattended format
    """
    return   ifft( (fft(c)*fft(X,axis=0).T).T, axis=0 ) 
    
    
    