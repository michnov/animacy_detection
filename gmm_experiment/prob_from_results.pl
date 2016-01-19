#!/usr/bin/env perl

use strict;
use warnings;

while (my $a0 = <STDIN>) {
    chomp $a0;
    $a0 =~ s/^1://;
    my $a1 = <STDIN>;
    chomp $a1;
    $a1 =~ s/^2://;
    my $empty = <STDIN>;

    my $p = exp($a1) * 100 / (exp($a0) + exp($a1));
    printf "%.2f\n", $p;
}
