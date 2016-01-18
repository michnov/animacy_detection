#!/bin/bash

#words="John Mary boy girl man woman dog cat elephant computer table axe space government reason"
words="$@"
echo -n "	"
echo $words | sed 's/ /	/g'

for labeled_file in data/iter*.labeled.train.nonshared.table.gz; do 
    echo $labeled_file | sed 's/^.*iter\([0-9]\+\).*$/\1	/' | perl -pe 'chomp'
    for word in $words; do
        zcat $labeled_file | 
        grep "^2.*kid_lemma=$word " | 
        cut -c3 | 
        distr | 
        grep -P '\s-\s*$' |
        sed 's/[ 	]\+/ /g' |
        cut -f1 -d' ' | 
        sed 's/$/	/' |
        perl -pe 'chomp'
    done
    echo
done
