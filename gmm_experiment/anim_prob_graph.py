#!/usr/bin/env python

import os, sys
import matplotlib.pyplot as plt

X = []
Y1 = []
Yn = []

for line in sys.stdin:
    line.strip();
    if line == "":
        continue
    if line.startswith("#"):
        continue
    if len(X) == 0:
        X = line.split()
        continue
    if len(Y1) == 0:
        Y1 = line.split()
        Y1.pop(0)
        continue
    Yn = line.split()
    Yn.pop(0)

plt.plot(X, Y1, "b-", X, Yn, "r-")
plt.savefig('graph.pdf')
