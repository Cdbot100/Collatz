// Scott Gordon and Steven Kundert
// CMPS 5433 - Colmenares
// Two Loops Project - Collatz Conjecture Verification
// Sequential implementation
#include <stdio.h>								//standard IO
#include <stdint.h>								//limits file
#include<math.h>
#include "timer.h"
FILE *f = fopen("VerifyConjecture.txt", "w");	//file for writing output
static const long NUM = pow(2,31);

__global__ void CUDAhailStoneModified(long * a, long size){
	long i;
	long iter=0;								//init values 
	__shared__ unsigned long long n;			//n can grow very large 

	for (i=threadIdx.x + blockDim.x  * blockIdx.x; i < size; i+= blockDim.x * gridDim.x){
		if (i < size && i >= 2){
			__syncthreads();
			iter = 0;							//set count to zero
			n = i;								//which value are we computing?
			while(n != 1)						//while not converging to 1
			{
				iter++;							//add one more interation
				if((n % 2) == 0)				//if even
				{
					n = n / 2;					// n / 2
				}
				else							//if odd
				{								//
					n = (3 * n + 1) / 2;		//(3n+1)/2. since (3n+1) % 2 == 0, divide by 2
					iter++;						//add one iteration for shortcutted step
				}
			}
			__syncthreads();	
			a[i] = iter;						//store the count in the correct place in the array. 
		}
	}
}

__global__ void CUDAhailStoneArray(long * a, long size){
	long i;
	long iter = 0;								//init values 
	unsigned long long n;						//n can grow very large 

	for (i=threadIdx.x + blockDim.x  * blockIdx.x; i < size; i+= blockDim.x * gridDim.x){
		if (i < size && i >= 2){
			iter = 0;								//set count to zero
				n = i;								//which value are we computing?
				while(n != 1)						//while not converging to 1
				{
					iter++;							//add one more interation
					if((n % 2) == 0)				//if even
					{
						n = n / 2;					// n / 2
					}
					else							//if odd
					{								//
						n = (3 * n + 1) / 2;		//(3n+1)/2. since (3n+1) % 2 == 0, divide by 2
						iter++;						//add one iteration for shortcutted step
					}
				}	
				a[i] = iter;						//store the count in the correct place in the array. 
		}
	}
}

void hailStoneArray(long * a, long size)	//our Sequential code 
{
	long i;
	long iter = 0;							//init values 
	unsigned long long n;					//n can grow very large 
	
	for(i = 2; i < size; i++)				//starting at two, loop for the problem size
	{
		iter = 0;							//set count to zero
		n = i;								//which value are we computing?
		while(n != 1)						//while not converging to 1
		{
			iter++;							//add one more interation
			if((n % 2) == 0)				//if even
			{
				n = n / 2;					// n / 2
			}
			else							//if odd
			{								//
				n = (3 * n + 1) / 2;		//(3n+1)/2. since (3n+1) % 2 == 0, divide by 2
				iter++;						//add one iteration for shortcutted step
			}
		}	
		a[i] = iter;						//store the count in the correct place in the array. 
	}
}

int main()									//our main
{
	double timeCompStart, timeCompEnd, timeComp;
	double timeCommStart, timeCommEnd, timeComm;
	const long Asize = (sizeof(long) *NUM);		//size of array 
	long * a_h, *a_d;							//pointer for array
	a_h = (long *)malloc(Asize);				//allocate array with zeros, make it correct size

	cudaMalloc((long**)&a_d,Asize);
	GET_TIME(timeCommStart);
	cudaMemcpy(a_d, a_h, Asize, cudaMemcpyHostToDevice);
	GET_TIME(timeCommEnd);
	timeComm = timeCommEnd - timeCommStart;

	GET_TIME(timeCompStart);
	CUDAhailStoneArray<<<32, 32>>> (a_d, NUM);
	//CUDAhailStoneModified<<<32,32>>> (a_d, NUM);
	//hailStoneArray(a_h, NUM);	
	cudaDeviceSynchronize();
	GET_TIME(timeCompEnd);

	GET_TIME(timeCommStart);
	cudaMemcpy(a_h, a_d, Asize, cudaMemcpyDeviceToHost);
	GET_TIME(timeCommEnd);

	timeComp = timeCompEnd - timeCompStart;
	timeComm = timeComm + (timeCommEnd - timeCommStart);
	//for (int x = 2; x < NUM; x++)				//loop for output
	//{
		fprintf(f,"It takes %d iterations for %d to reach 1 using the Collatz Conjecture\n", a_h[NUM-1], NUM-1);
	//}											//print output
	
	free(a_h); 									//free resources 
	
	printf ("\telapsed wall clock time: %f s\n", (timeComp+timeComm));

	return 0;  									//return 
}
