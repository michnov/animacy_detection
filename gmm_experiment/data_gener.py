import sys
import numpy as np

def print_line(l, l_true, x, labeled):
    l_str = str(l)
    if labeled == 1:
        loss = 0 if l == l_true else 1
        l_str = l_str + ":" + str(loss)
    print l_str + " | a=" + str(l-1) + ",x=" + str(int(x))
    

labeled = 0
if len(sys.argv) > 1:
    labeled = int(sys.argv[1])

m1_params = [ 0, 100, 10000 ]
if len(sys.argv) > 2:
    m1_params = [ int(x) for x in sys.argv[2].split(',') ]
m2_params = [ 500, 100, 20000 ]
if len(sys.argv) > 3:
    m2_params = [ int(x) for x in sys.argv[3].split(',') ]

m1_data = [ (x, 1) for x in np.random.normal(*m1_params) ]
m2_data = [ (x, 2) for x in np.random.normal(*m2_params) ]
m12_data = np.concatenate((m1_data, m2_data))
np.random.shuffle(m12_data)

for (x, label) in m12_data:
    print_line(1, label, x, labeled)
    print_line(2, label, x, labeled)
    print
