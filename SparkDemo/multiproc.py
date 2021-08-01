import multiprocessing
from multiprocessing import pool
import time

def func(x):
    return x*x

if __name__=='__main__':
    data, res = [1,3,5,4,3,5,6], []

    #x = func(10)
    t1 = time.time()
    for i in data:
        res.append(func(i))
    print(res)
    print("first time ", time.time() - t1)