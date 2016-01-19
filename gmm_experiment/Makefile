init :
	ln -s ../all_experiment.low_feat/em.sh

LABELED_GMM_PARAMS=0,100,1000 1000,100,2000
UNLABELED_GMM_PARAMS=200,100,10000 1200,100,20000

tables : data/train.nonshared.table.gz data/unlabeled.train.nonshared.table.gz

data/train.nonshared.table.gz : LABELED=1
data/train.nonshared.table.gz : GMM_PARAMS=$(LABELED_GMM_PARAMS)
data/unlabeled.train.nonshared.table.gz : LABELED=0
data/unlabeled.train.nonshared.table.gz : GMM_PARAMS=$(UNLABELED_GMM_PARAMS)
data/train.nonshared.table.gz data/unlabeled.train.nonshared.table.gz :
	./data_gener.py $(LABELED) $(GMM_PARAMS) | gzip -c > $@

#VALUES1=$(shell seq -500 10 290)
#VALUESinter=$(shell seq 300 25 900)
#VALUES2=$(shell seq 910 10 00)
#VALUES=$(VALUES1) $(VALUESinter) $(VALUES2)
VALUES=$(shell seq -500 10 2000)

run :
	./em.sh 20
	touch $@

stats : run
	echo "LABELED_GMM_PARAMS=$(LABELED_GMM_PARAMS)" > $@
	echo "UNLABELED_GMM_PARAMS=$(UNLABELED_GMM_PARAMS)" >> $@
	./x_progress.sh $(VALUES) >> $@

graph : graph.pdf
graph.pdf : stats
	./anim_prob_graph.py < $<

clean :
	rm -rf data/*
	rm -rf tmp/*
	rm -rf model/*
	rm stats
	rm graph.pdf
