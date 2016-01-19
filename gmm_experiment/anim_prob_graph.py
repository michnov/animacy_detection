#!/usr/bin/env python

import os, sys
import matplotlib.pyplot as plt

X = []
Y1 = []
Yn = []

a0_lab_mi = 0
a1_lab_mi = 0
a0_unlab_mi = 0
a1_unlab_mi = 0

for line in sys.stdin:
    line.strip();
    if line == "":
        continue
    if line.startswith("#"):
        continue
    if line.startswith("LABELED_GMM_PARAMS"):
        (a0_lab_mi, a1_lab_mi) = [ int(x.split(",")[0]) for x in line.split("=")[1].split() ]
        continue
    if line.startswith("UNLABELED_GMM_PARAMS"):
        (a0_unlab_mi, a1_unlab_mi) = [ int(x.split(",")[0]) for x in line.split("=")[1].split() ]
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
plt.axvline(a0_lab_mi, color="b", linestyle="--")
plt.axvline(a1_lab_mi, color="b", linestyle=":")
plt.axvline(a0_unlab_mi, color="r", linestyle="--")
plt.axvline(a1_unlab_mi, color="r", linestyle=":")
plt.savefig('graph.pdf')
