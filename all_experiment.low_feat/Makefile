SHELL=/bin/bash

VALUES=John Mary boy girl man woman dog cat elephant computer table axe space government reason
VALUES_FLAG=-fkid_lemma $(VALUES)

run :
	./em.sh 20
	touch $@

stats : run
	./x_progress.sh $(VALUES_FLAG) >> $@

graph : graph.pdf
graph.pdf : stats
	./anim_prob_graph.py 2,4,6,8,10,12,14,16,18 < $<

clean :
	rm -rf data/iter*
	rm -rf tmp/*
	rm -rf model/*
	-rm run
	-rm stats
	-rm graph.pdf
