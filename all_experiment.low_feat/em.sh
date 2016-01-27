#!/bin/bash

#echo "Filtering features in ../data/train.table.gz"
#zcat ../data/train.table.gz | $ML_FRAMEWORK_DIR/scripts/filter_feat.pl --in verb_lemma_functor,kid_lemma,animacy | ../data_to_nonshared.pl | gzip -c > data/train.nonshared.table.gz
#echo "Filtering features in ../data/unlabeled.train.table.gz"
#zcat ../data/unlabeled.train.table.gz | $ML_FRAMEWORK_DIR/scripts/filter_feat.pl --in verb_lemma_functor,kid_lemma,animacy | ../data_to_nonshared.pl | gzip -c > data/unlabeled.train.nonshared.table.gz

epochs=${1:-20}
passes=10
prev_i=000
for i_int in `seq 1 $epochs`; do
    i=`printf "%03d" $i_int`
    zcat data/train.nonshared.table.gz 'data/iter'$prev_i'.labeled.train.nonshared.table.gz' | cut -f2 --complement | vw -f 'model/iter'$i'.train.nonshared.model' -b 25 --csoaa_ldf mc --loss_function logistic --holdout_off -k --cache_file vw.cache --passes $passes
    zcat data/unlabeled.train.nonshared.table.gz | cut -f2 --complement | vw -t -i 'model/iter'$i'.train.nonshared.model' -r 'tmp/iter'$i'.result.txt'
    echo "Pasting results to unlabeled.train.nonshared.table.gz"
    zcat data/unlabeled.train.nonshared.table.gz | $ML_FRAMEWORK_DIR/scripts/paste_data_results.pl 'tmp/iter'$i'.result.txt'  | gzip -c > 'data/iter'$i'.labeled.train.nonshared.table.gz'
    passes=1
    prev_i=$i
done
