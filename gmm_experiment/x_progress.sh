#!/bin/bash

mkdir -p tmp/x_progress

#words="John Mary boy girl man woman dog cat elephant computer table axe space government reason"
values="$@"

./test_gener.pl $values | gzip -c > tmp/x_progress/test.table.gz

echo -n "	"
echo $values | perl -e 'my $line = <STDIN>; chomp $line; print join "\t", grep {$_ !~ /^-f/} split /\s+/, $line; print "\n";'

for model in model/iter*; do 
    file_id=`echo $model | sed 's/^.*iter\([0-9]\+\).*$/\1/' | perl -pe 'chomp'`
    echo -en $file_id'\t'

    zcat tmp/x_progress/test.table.gz | vw -t -i $model -r 'tmp/'$file_id'.result.txt' -b 25
    cat 'tmp/'$file_id'.result.txt' | ./prob_from_results.pl | perl -e 'my @a = <STDIN>; chomp $_ for (@a); print join "\t", @a; print "\n";'
done

rm -rf tmp/x_progress
