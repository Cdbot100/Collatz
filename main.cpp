//  main.cpp
//  Collatz
//  Created by Scott Gordon on 3/24/15.
//  Copyright (c) 2015 Scott Gordon. All rights reserved.

#include <iostream>

int Collatz(int n){
    if (n==1 || n < 0){
        std::cout << "\n\n";
        return 0;
    }
    else if (n%2 == 0) n=n/2;
    else n=((3*n)+1);
    
    std::cout << n << " ";
    return Collatz(n);
}

int main(int argc, const char * argv[]) {
    srand((unsigned int) time(NULL));                   //seed rand with time
    
    for(int count=0;count<=1000; count++){              //do 1000 numbers
    int Num=(rand() % (1 + 1000000000000));             //pick at 'random'
        if (Num<=0) Num=(rand() % (1 + 1000000000));    //if negitive pick again
    //evaluate P(Num Correct), if possible-
    //check if Num has been checked before if so, pick again-
    std::cout << Num;
    std::cout << "\n\n";
    Collatz(Num);
    }
    
    return 0;
}


