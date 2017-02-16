#ifndef _IO_H_
#define _IO_H_

#include <stdio.h>
#include <string.h>

#include "stdlib.h"
#include "datastruct.h"
#include "util.h"

void loadVec(float *vec, char *fName, int sz);
void loadIntVec(int *vec, char *fName, int sz);
void loadMat(float **mat, int nrows, int ncols, char *fileName);
void loadData(Data *data, Params *params);
void writeData(Data *data);
void writeTrTestValSetInd(Data *data);
int numLines(char *fName);

#endif

