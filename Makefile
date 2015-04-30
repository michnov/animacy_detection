LRC=0

JOBS=200
ifeq ($(LRC),1)
LRC_FLAG= -p --qsub '-hard -l mem_free=2G -l act_mem_free=2G -l h_vmem=2G' --jobs $(JOBS) --priority 0
endif

#DATA_LIST=data/sample.list
DATA_LIST=$(TMT_ROOT)/personal/mnovak/czeng_coref/data/en/analysed/czeng_0/train/0001/list

UNLABELED_DATA=data/unlabeled.table.gz

extract_table_labeled : data/labeled.table.gz
extract_table_unlabeled : data/unlabeled.table.gz

data/labeled.table.gz : LABELED=1
data/labeled.table.gz : DIR=labeled
$(UNLABELED_DATA) : LABELED=0
$(UNLABELED_DATA) : DIR=unlabeled
data/labeled.table.gz $(UNLABELED_DATA) : $(DATA_LIST) 
	treex $(LRC_FLAG) -Len \
		Read::Treex from=@$< \
		My::ExtractAnimacyTable labeled=$(LABELED) to="." substitute='{^.*/([^\/]*)}{data/$(DIR)/$$1.txt}'
	find data/$(DIR) -name '*.txt' -exec cat {} \; | gzip -c > $@

TRAIN_DATA=data/train.table.gz
DEV_DATA=data/dev.table.gz
EVAL_DATA=data/eval.table.gz

$(TRAIN_DATA) : START=1
$(TRAIN_DATA) : END=1131232
$(DEV_DATA) : START=1131233
$(DEV_DATA) : END=1272636
$(EVAL_DATA) : START=1272637
$(EVAL_DATA) : END=1414040
$(TRAIN_DATA) $(DEV_DATA) $(EVAL_DATA) : data/labeled.table.gz
	zcat $< | sed -n '$(START),$(END)p' | gzip > $@

ITER_COUNT=10
SELECTION_METRICS_TYPE=min_loss
#SELECTION_METRICS_TYPE=diff_loss
#SELECTION_METRICS_TYPE=avg_diff_loss
SELECTION_METRICS_THRESHOLD=0
DELIBLE=1
POOL_SIZE=10

#               UNLABELED_SPLIT_SIZE=300000 
#        FEATSET_LIST=conf/$(LANGUAGE).featset_list 
self_training : $(TRAIN_DATA) $(DEV_DATA) $(UNLABELED_DATA)
	$(ML_FRAMEWORK_DIR)/run.sh -f config.conf \
        EXPERIMENT_TYPE=self-training \
        "DATA_LIST=UNLABELED_DATA TRAIN_DATA TEST_DATA" \
        TRAIN_DATA=$(TRAIN_DATA) \
        TEST_DATA=$(DEV_DATA) \
        "UNLABELED_DATA=$(UNLABELED_DATA)" \
        ML_METHOD_LIST=ml_method.conf \
       	ITER_COUNT=$(ITER_COUNT) \
        SELECTION_METRICS_TYPE=$(SELECTION_METRICS_TYPE) \
        SELECTION_METRICS_THRESHOLD=$(SELECTION_METRICS_THRESHOLD) \
        DELIBLE=$(DELIBLE) \
        POOL_SIZE=$(POOL_SIZE) \
        LRC=$(LRC) \
        TMP_DIR=tmp/ml \
        D="$(D)"
