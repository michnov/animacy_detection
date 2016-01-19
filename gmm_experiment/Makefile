init :
	ln -s ../all_experiment.low_feat/em.sh
	ln -s ../all_experiment.low_feat/word_progress.sh

LABELED_GMM_PARAMS=500,100,1000 1500,100,2000
UNLABELED_GMM_PARAMS=0,100,10000 1000,100,20000

tables : data/train.nonshared.table.gz data/unlabeled.train.nonshared.table.gz

data/train.nonshared.table.gz : LABELED=1
data/train.nonshared.table.gz : GMM_PARAMS=$(LABELED_GMM_PARAMS)
data/unlabeled.train.nonshared.table.gz : LABELED=0
data/unlabeled.train.nonshared.table.gz : GMM_PARAMS=$(UNLABELED_GMM_PARAMS)
data/train.nonshared.table.gz data/unlabeled.train.nonshared.table.gz :
	python data_gener.py $(LABELED) $(GMM_PARAMS) | gzip -c > $@

VALUES=-100 -50 -10 0 10 50 100 900 950 990 1000 1010 1050 1100
run :
	./em.sh 10
	./x_progress.sh $(VALUES) > words

clean :
	rm -rf data/*
	rm -rf tmp/*
	rm -rf model/*
	rm words
