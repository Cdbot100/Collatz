import random

def collatz(X):
    if X == 1 or X < 0:
        print("\n\n")
        return 0
    elif (X % 2 == 0):
        X=X/2
    else:
        X=((3*X)+1)

    print(X)
    return collatz(X)

if __name__=="__main__":
        x = abs(random.getrandbits(256))
        collatz(x)