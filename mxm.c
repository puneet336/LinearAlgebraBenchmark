 #include <stdio.h>
 #include <stdlib.h>
 #include <sys/time.h>
 #include<math.h>

 void init(double* matrix, int nrows, int ncols,double val)
 {
  int cr,cc;
   for (cc = 0; cc < ncols; cc++){
     for ( cr = 0; cr < nrows; cr++){
//       matrix[cc*nrows + cr] = val;
         matrix[cc*nrows + cr] = (double)rand();
     }
   }
 }
 
 void printM(const char * name, const double* matrix, int nrows, int ncols)
 {
   int cr,cc;
   printf("Matrix%s : rows %d ,cols %d \n", name, nrows, ncols);
   for ( cr = 0; cr < nrows; cr++){
     for ( cc = 0; cc < ncols; cc++){
       printf("%.3f ", matrix[cc*nrows + cr]);
     }
     printf("\n");
   }
   printf("\n");
 }
 
 int main(int argc, char * argv[])
 {
   int nrowsA, ncolsB, common;
   int i,j,k;
   struct timeval t1, t2;
   double elapsedTimeS,elapsedTimeU;
 
   if (argc != 4){
     nrowsA = 4; ncolsB = 5; common = 3;
     printf("default: (%d %d) x (%d %d) = (%d %d)\n",nrowsA,common,common,ncolsB,nrowsA,ncolsB);
   }
   else{
     nrowsA  = atoi(argv[1]); 
     ncolsB  = atoi(argv[2]);
     common  = atoi(argv[3]);
     printf("supplied: (%d %d) x (%d %d) = (%d %d)\n",nrowsA,common,common,ncolsB,nrowsA,ncolsB);
   }
 
   double* A=malloc(sizeof(double) * nrowsA * common); 
   double* B=malloc(sizeof(double) * common * ncolsB);
   double* C=malloc(sizeof(double) * nrowsA * ncolsB); 
   double* D=malloc(sizeof(double) * nrowsA * ncolsB);
 
   char transA = 'N', transB = 'N';
   double alpha = 1.0, beta = 0.0;
 
   srand(time(NULL));
   printf("init A & B\n"); 
   init(A, nrowsA, common,1.0); 
   init(B, common, ncolsB,2.0);

   printf("running dgemm_\n"); 
   gettimeofday(&t1, NULL); 
   dgemm_(&transA, &transB, &nrowsA, &ncolsB, &common, &alpha, A, &nrowsA, B, &common, &beta, C, &nrowsA);
   gettimeofday(&t2, NULL);

   elapsedTimeU=(t2.tv_sec*1000.0 + t2.tv_usec/1000.0) - (t1.tv_sec*1000.0 + t1.tv_usec/1000.0);
   elapsedTimeS=elapsedTimeU/1000.0;

// elapsedTimeU=elapsedTimeU%1000.0;
   elapsedTimeU=fmod(elapsedTimeU,1000.0);
   
   printf("Elapsed: %.fs,%.4fms\n",elapsedTimeS,elapsedTimeU);

   for(i=0;i<ncolsB;i++){
     for(j=0;j<nrowsA;j++){
       D[i*nrowsA+j]=0;
       for(k=0;k<common;k++){
         D[i*nrowsA+j]+=A[k*nrowsA+j]*B[k+common*i];
       }
      }
    }
    
    for(i=0;i<ncolsB;i++){
     for(j=0;j<nrowsA;j++){
        if (D[i*nrowsA+j]!=C[i*nrowsA+j])
        {
          printf("Error!");
          exit(1);
        }	
      }
    }    
   printf("ok");
     

//   print("A", A, rowsA, common); print("B", B, common, colsB);
//   print("C", C, rowsA, colsB); print("D", D, rowsA, colsB);
 
   return 0;
 }
