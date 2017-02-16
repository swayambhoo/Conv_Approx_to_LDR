#include<stdio.h>
#include<time.h>
#include<math.h>
#include <string.h>
#include "stdlib.h"
#include "util.h"

#define nROWs 300
#define nCOLs 16384
#define nData 1420

short FFT(short int dir,long m,float *x,float *y){
   long n,i,i1,j,k,i2,l,l1,l2;
   float c1,c2,tx,ty,t1,t2,u1,u2,z;

   /* Calculate the number of points */
   n = 1;
   for (i=0;i<m;i++)
      n *= 2;

   /* Do the bit reversal */
   i2 = n >> 1;
   j = 0;
   for (i=0;i<n-1;i++) {
      if (i < j) {
         tx = x[i];
         ty = y[i];
         x[i] = x[j];
         y[i] = y[j];
         x[j] = tx;
         y[j] = ty;
      }
      k = i2;
      while (k <= j) {
         j -= k;
         k >>= 1;
      }
      j += k;
   }

   /* Compute the FFT */
   c1 = -1.0;
   c2 = 0.0;
   l2 = 1;
   for (l=0;l<m;l++) {
      l1 = l2;
      l2 <<= 1;
      u1 = 1.0;
      u2 = 0.0;
      for (j=0;j<l1;j++) {
         for (i=j;i<n;i+=l2) {
            i1 = i + l1;
            t1 = u1 * x[i1] - u2 * y[i1];
            t2 = u1 * y[i1] + u2 * x[i1];
            x[i1] = x[i] - t1;
            y[i1] = y[i] - t2;
            x[i] += t1;
            y[i] += t2;
         }
         z =  u1 * c1 - u2 * c2;
         u2 = u1 * c2 + u2 * c1;
         u1 = z;
      }
      c2 = sqrt((1.0 - c1) / 2.0);
      if (dir == 1)
         c2 = -c2;
      c1 = sqrt((1.0 + c1) / 2.0);
   }

   /* Scaling for forward transform */
   if (dir == 1) {
      for (i=0;i<n;i++) {
         x[i] /= n;
         y[i] /= n;
      }
   }

   return(0);
}

short MatVecMult(int nRows, int nCols, float *c, float **X, float *y){

	int i,j;
    for (i=0; i<nRows; i++){
        for (j=0; j<nCols; j++){
			c[i] = c[i] + X[i][j]*y[j];
		}
	}
    return(0);
}

//read matrice from a file into variable mat
void loadMat(int nRows, int nCols,  float **mat,  char *fileName) {
    FILE *fp = NULL;
    char *line = NULL;
    size_t len = 500000;

    int i, j, read;

    fp = fopen(fileName, "r");
    if (fp == NULL) {
        printf("\nError opening file: %s", fileName);
        exit(EXIT_FAILURE);
    }

    i = 0;
    line = (char*) malloc(len);
    memset(line, 0, len);

    while((read = getline(&line, &len, fp)) != -1) {

      if (read >= len) {
          printf("\nErr: line > capacity specified");
      }

      //tokenize the line
      mat[i][0] = atof(strtok(line, " "));

          for (j = 1; j < nCols; j++) {
              //read mat[i][j]
              mat[i][j] = atof(strtok(NULL, " "));
          }

      i++;
      memset(line, 0, len);
    }

    fclose(fp);
    free(line);
}

void loadVec(float *vec, char *fName, int sz) {

  FILE *fp   = NULL;
  char *line = NULL;
  size_t len = 100;
  int i, j, read;

  fp = fopen(fName, "r");
  if (fp == NULL) {
    printf("\nError reading file %s", fName);
    exit(0);
  }

  line = (char*) malloc(len);
  memset(line, 0, len);

  i = 0;
  while((read = getline(&line, &len, fp)) != -1) {
    if (read >= len) {
      printf("\nErr: line > specified capacity");
    }
    vec[i++] = atof(line);
  }

//  assert(i == sz);
  fclose(fp);
  free(line);
}


void loadIntVec(int *vec, char *fName, int sz) {

  FILE *fp   = NULL;
  char *line = NULL;
  size_t len = 100;
  int i, j, read;

  fp = fopen(fName, "r");
  if (fp == NULL) {
    printf("\nError reading file %s", fName);
    exit(0);
  }

  line = (char*) malloc(len);
  memset(line, 0, len);

  i = 0;
  while((read = getline(&line, &len, fp)) != -1) {
    if (read >= len) {
      printf("\nErr: line > specified capacity");
    }
    vec[i++] = atoi(line);
  }

//  assert(i == sz);
  fclose(fp);
  free(line);
}


int main(int argc, char *argv[] ){
  // call this function as './a.out A.txt trainData.txt D_1.txt C_1.txt X_1.txt m'

  int i,j;

  // loading A
  float **A = (float **) malloc(sizeof(float *)*nROWs);
  for (i = 0; i < nROWs; i++){
    A[i] =   (float *) malloc(sizeof(float)*nCOLs);
  }
  loadMat(nROWs, nCOLs, A, argv[1]);
  //printf("Loading A Done.\n");


  // loading X
  float **X = (float **) malloc(sizeof(float *)*nCOLs);
  for ( i = 0; i < nCOLs; i++){
    X[i] =   (float *) malloc(sizeof(float)*nData);
  }
  loadMat(nCOLs, nData, X, argv[2]);
  //printf("Loading X Done.\n");

  // loading row of circulant matrix
  float *c = (float *) malloc(sizeof(float)*nCOLs);
  loadVec(c, argv[4], nCOLs);
  //printf("Loading C Done.\n");

  // getting internal dimension.
  int mi = atoi(argv[6]);
  //printf("Loading internal dimensiona done: %d . \n", mi );

  // loading D
  float **D = (float **) malloc(sizeof(float *)*nROWs);
  for ( i = 0; i < nROWs; i++){
    D[i] =   (float *) malloc(sizeof(float)*mi);
  }
  loadMat(nROWs, mi, D, argv[3]);
  //printf("Loading D Done.\n");

  // loading X reduced dimension.
  int *XSup = (int *) malloc(sizeof(int *)*mi);
  loadIntVec(XSup, argv[5], mi);
  //printf("Loading XSup Done.\n");

   /*for ( i = 0; i < nROWs; i++ ){
        for (int j = 0; j < nCOLs; j++){
            printf("%f \t", A[i][j]);
        }
        printf("\n");
    }

    for ( i = 0; i < nCOLs; i++ ){
        for ( j = 0; j < nData; j++){
            printf("%f \t", X[i][j]);
        }
        printf("\n");
    }*/

    int ncols = 16384;
    float *z = (float *) malloc(sizeof(float)*nROWs);
    float *dataPoint = (float *) malloc(sizeof(float)*nCOLs);
    float *real = (float *) malloc(sizeof(float)*nCOLs);
    //float *imag = (float *) malloc(sizeof(float)*nCOLs);
    float *imag = (float *) malloc(sizeof(float)*ncols);
    float *xSubsampled = (float *) malloc(sizeof(float)*mi);
    float tA = 0.0;
    float tDC = 0.0;

    for ( i = 0; i < nData; i++ ){
      for ( j = 0; j< nCOLs; j++){
        dataPoint[j] = X[j][i];
        imag[j]      = 0;
      }

      clock_t tic = clock();
      MatVecMult(nROWs, nCOLs, z, A, dataPoint);
      clock_t toc = clock();

      tA = tA + (float)(toc - tic) / CLOCKS_PER_SEC;

      real = dataPoint;

      tic = clock();

      FFT(1, 12, real, imag);

      for (j=0; j < nCOLs; j++){
        real[j] = c[j]*real[j];
        imag[j] = c[j]*imag[j];
      }

      FFT(-1, 12, real, imag);

      for (j=0; j < mi; j++){
        xSubsampled[j] = real[XSup[j]];
      }

      MatVecMult(nROWs, mi, z, D, xSubsampled);

      toc = clock();

      tDC = tDC + (float)(toc - tic) / CLOCKS_PER_SEC;
    }

    tA  = tA/nData;
    tDC = tDC/nData;

    printf("\n Average times with A: %f", tA);
    printf("\n Average times with DC: %f\n", tDC);

    //	  double y[4096];
    //    double X[100][4096];
    //    double z[100];

/*    int i, j;

	for ( i = 0; i<16384; i = i + 1){
		x[i] = i;
		y[i] = 0;
	}

	clock_t tic = clock();
	FFT(-1, 11, x, y);
    FFT(1, 11, x, y);
	clock_t toc = clock();

	printf("Time for FFT %f10 \n",(double)(toc - tic) / CLOCKS_PER_SEC);

    for ( i = 0; i < 300; i++){
        for ( j = 0; j < 16384; j++){
            X[i][j] = i+j;
        }
    }

    clock_t tic2 = clock();
    MatVecMult(300, 16384,z, X, y);
    clock_t toc2 = clock();

    printf("Time for Matrix Vector Multiplication %f10 \n",(double)(toc2 - tic2) / CLOCKS_PER_SEC);

    printf("Speed Ratio= %f \n",(double)(toc2 - tic2)/(toc - tic));


	//for ( int i = 0; i<2048; i = i + 1){
	//	printf(" fft[%d]= %f + i  %f\n",i,x[i],y[i]);
	//}
*/
        return(0);

}
