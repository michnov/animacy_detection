SHELL=/bin/bash

VALUES=John Mary boy girl man woman dog cat elephant computer table axe space government reason
VALUES_FLAG=-fkid_lemma $(VALUES)

run :
	./em.sh 100
	touch $@

stats : run
	./x_progress.sh $(VALUES_FLAG) >> $@

CHECKPOINTS=$(shell seq -s , 5 5 60)

graph : graph.pdf
graph.pdf : stats
	./anim_prob_graph.py $(CHECKPOINTS) < $<

clean :
	rm -rf data/iter*
	rm -rf tmp/*
	rm -rf model/*
	-rm run
	-rm stats
	-rm graph.pdf
