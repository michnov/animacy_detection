SHELL=/bin/bash

#VALUES=John Mary boy girl man woman dog cat elephant computer table axe space government reason
VALUES=be_ACT be_PAT use_PAT give_PAT take_CPHR take_PAT keep_ACT leave_ACT come_PAT stand_ACT occur_TPAR forward_ADDR fall_REG sink_ACT wonder_TWHEN whisper_ADDR visualize_PAT walk_MANN destroy_MEANS ezeken_ACT forward_COND lift_off_DIR3
#VALUES_FLAG=-fkid_lemma $(VALUES)
VALUES_FLAG=-fverb_lemma_functor $(VALUES)

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
