#!/bin/bash

mkdir -p tmp/x_progress

#words="John Mary boy girl man woman dog cat elephant computer table axe space government reason"
words="$@"
echo -n "	"
echo $words | sed 's/ /	/g'

for labeled_file in data/iter*.labeled.train.nonshared.table.gz; do 
    file_id=`echo $labeled_file | sed 's/^.*iter\([0-9]\+\).*$/\1	/' | perl -pe 'chomp'`
    echo -n $file_id
    zcat $labeled_file |
        $ML_FRAMEWORK_DIR/scripts/discretize_losses.pl | gzip -c > tmp/x_progress/$file_id
    for word in $words; do
        all=`zcat tmp/x_progress/$file_id | grep -P "^2.*x=$word(\\s.*)?$" | wc -l`
        ones=`zcat tmp/x_progress/$file_id | grep -P "^1:0.*x=$word(\\s.*)?$" | wc -l`
        twos=`zcat tmp/x_progress/$file_id | grep -P "^2:0.*x=$word(\\s.*)?$" | wc -l`
        echo -ne '\t'
        echo -n $((ones*100/all))':'$((twos*100/all))
    done
    echo
done

rm -rf tmp/x_progress
