#!/usr/bin/env perl

use warnings;
use strict;

while (my $line = <>) {
    chomp $line;
    my $instance;
    if ($line =~ /^shared/) {
        $instance = $line;
    }
    $line = <>;
    my $label;
    if ($line =~ /^1:0/) {
        $label = -1;
    }
    else {
        $label = 1;
    }
    $instance =~ s/^shared/$label/;
    $line = <>;
    $line = <>;
    print $instance . "\n";
}
