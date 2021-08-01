from library.utils import *
import multiprocessing as mp
from multiprocessing import Pool, Process
import os

def print_hi(tc):
    for k,v in tc.items():
        print("key = {}, value = {}".format(k, v))

def f(x):
    return x*x

def info(title):
    print(title)
    print("module name : ", __name__)
    print("process id : ", os.getpid())
    print("parent process id : ", os.getppid())


def func(name):
    info("function func")
    print("Hello ", name)

def load_data(q):
    q.put("kannan")
    q.put("testing")
    q.put([1,2,'test record','status'])

if __name__ == '__main__':
    testconf = get_proc_config()
    print(testconf)
    print_hi(testconf)

    ##Pool example
    #with Pool(5) as p:
        #res = p.map(f, [1,2,3,4,4,5,6,7,8,9,10,11])
    #print(res)

    ##Process example
    #info("main func")
    #p = Process(target=func,args=('kannan',))
    #p.start()
    #p.join()

    ##Queue example using multiprocessing
    mp.set_start_method('spawn')
    q = mp.Queue()
    p = mp.Process(target=load_data,args=(q,))
    p.start()

    p.join()
    print(q.get())
    print(q.get())
    dat = q.get()

    for i in dat:
        print(i)



