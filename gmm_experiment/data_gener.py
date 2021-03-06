#!/usr/bin/env python

import sys
import numpy as np

def print_line(l, l_true, x_list, labeled):
    l_str = str(l)
    if labeled == 1:
        loss = 0 if l == l_true else 1
        l_str = l_str + ":" + str(loss)
    x_str = " ".join( [ "a="+str(l-1)+",x="+str(int(x)) for x in x_list ] )
    print l_str + " | " + x_str

def get_data(gener):
    if gener:
        feats_per_inst = 5
        m1_params = [ 0, 100, 10000 ]
        if len(sys.argv) > 0:
            m1_params = [ int(x) for x in sys.argv.pop(0).split(',') ]
            m1_params[2] = ( m1_params[2], feats_per_inst )
        print >> sys.stderr, m1_params
        m2_params = [ 500, 100, 20000 ]
        if len(sys.argv) > 0:
            m2_params = [ int(x) for x in sys.argv.pop(0).split(',') ]
            m2_params[2] = ( m2_params[2], feats_per_inst )
        print >> sys.stderr, m2_params
        m1_data = [ (x, 1) for x in np.random.normal(*m1_params) ]
        m2_data = [ (x, 2) for x in np.random.normal(*m2_params) ]
        m12_data = np.concatenate((m1_data, m2_data))
        np.random.shuffle(m12_data)
    else:
        m12_data = [ ([x], 1) for x in sys.argv ]
    return m12_data

sys.argv.pop(0)
    
labeled = 0
gener = 1
if len(sys.argv) > 1:
    arg1 = sys.argv.pop(0)
    if arg1 != "-l":
        labeled = int(arg1)
    else :
        gener = 0
        
m12_data = get_data(gener)

for (x, label) in m12_data:
    print_line(1, label, x, labeled)
    print_line(2, label, x, labeled)
    print
