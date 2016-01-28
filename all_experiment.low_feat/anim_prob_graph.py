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

labels = []
Yn_iter = 0

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
        Yn_iter = int(Y1.pop(0))
        labels.append(Yn_iter)
        continue
    Yn = line.split()
    Yn_iter = int(Yn.pop(0))
    if iters_print.has_key(Yn_iter):
        Yi.append(Yn)
        labels.append(Yn_iter)
labels.append(Yn_iter)

X_range = range(len(X))
X_sorted_idx = np.argsort(Yn)

colormap = plt.cm.RdYlBu
colorcodes = [colormap(i) for i in np.linspace(0, 0.9, len(Yi)+2)]
colorcodes.reverse()
plt.gca().set_color_cycle(colorcodes)

plt.ylim(0, 100)
plt.plot(X_range, np.array(Y1)[X_sorted_idx])
for i in Yi:
    plt.plot(X_range, np.array(i)[X_sorted_idx])
plt.plot(X_range, np.array(Yn)[X_sorted_idx])

plt.xticks(X_range, np.array(X)[X_sorted_idx], rotation=315, horizontalalignment='left', fontsize='4')

plt.legend(["iter "+str(x) for x in labels], loc='lower right', fontsize='x-small')

plt.savefig('graph.pdf')
