#!/usr/bin/env python

import os, sys
import matplotlib.pyplot as plt
import numpy as np

iters_print = {}
if len(sys.argv) > 1:
    iters_print = { int(x) : True for x in sys.argv[1].split(",") }

X = []
Y1 = []
Yi = []
Yn = []

a0_lab_mi = 0
a1_lab_mi = 0
a0_unlab_mi = 0
a1_unlab_mi = 0

labels = []
Yn_iter = 0

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
        Yn_iter = int(Y1.pop(0))
        labels.append(Yn_iter)
        continue
    Yn = line.split()
    Yn_iter = int(Yn.pop(0))
    if iters_print.has_key(Yn_iter):
        Yi.append(Yn)
        labels.append(Yn_iter)
labels.append(Yn_iter)

colormap = plt.cm.RdYlBu
colorcodes = [colormap(i) for i in np.linspace(0, 0.9, len(Yi)+2)]
colorcodes.reverse()
plt.gca().set_color_cycle(colorcodes)

plt.plot(X, Y1)
for i in Yi:
    plt.plot(X, i)
plt.plot(X, Yn)

plt.legend(["iter "+str(x) for x in labels], loc='upper right')

plt.axvline(a0_lab_mi, color="b", linestyle="--")
plt.axvline(a1_lab_mi, color="b", linestyle=":")
plt.axvline(a0_unlab_mi, color="r", linestyle="--")
plt.axvline(a1_unlab_mi, color="r", linestyle=":")
plt.savefig('graph.pdf')
