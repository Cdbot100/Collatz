// Scott Gordon and Steven Kundert
// CMPS 5433 - Colmenares
// Two Loops Project - Collatz Conjecture Verification
// Sequential implementation
#include <stdio.h>							//standard IO
#include <stdint.h>							//limits file
FILE *f = fopen("VerifyConjecture.txt", "w");//file for writing output
static const int NUM = 1024;

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
	const long Asize = (sizeof(long) *NUM);				//size of array (also largest N) 
	long * a_h;							//pointer for array
	long * a_d;
	a_h = (long *)malloc(Asize);//allocate array with zeros, make it correct size
	hailStoneArray(a_h, NUM);			//call our function 
	for (int x = 2; x < NUM; x++)			//loop for output
	{
		fprintf(f,"It takes %d iterations for %d to reach 1 using the Collatz Conjecture\n", a_h[x], x);
	}										//print output
	
	free(a_h); 							//free resources 
	return 0;  								//return 
}
