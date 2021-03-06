## Convolutional approximations to linear dimensionality reduction operators
![GUI](main_img.png "Main Picture")


This work examines the existence of efficiently implementable approximations of a general real linear dimensionality reduction (LDR)
operator. The specific focus is on approximating a given LDR operator with a partial circulant structured matrix (a matrix whose rows are related by circular shifts) as these constructions allow for low-memory footprint and computationally efficient implementations.
Our main contributions are are that we quantify how well general matrices may be approximated (in a Frobenius sense) by partial circulant structured matrices, and also consider a variation of this problem where the aim is only to accurately approximate the action of a given LDR operator on a restricted set of inputs. For the latter setting, we also consider a sparsity-regularized alternating minimization based algorithm for learning partial circulant approximations from data.

This repository contains MATLAB based implementation of various optimization problem that arise in this investigation. 

## Folders
* 'Matlab_Implementation', Contains MATLAB implementations for this project.
* 'Python_Implementation', Contains Python implementations for this project.

## Citation
Please the cite the following if you use this work.
* S. Jain and J. Haupt, ‘‘Convolutional approximations to linear dimensionality reduction operators,’’ Proceedings of International Conference on Acoustics, Speech and Signal Processing, March 2017.
