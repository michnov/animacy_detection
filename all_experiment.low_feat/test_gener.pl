#!/usr/bin/env perl

use warnings;
use strict;

sub print_instance {
    my ($fname, $fvalue) = @_;
    print "1 | a=0,$fname=$fvalue\n";
    print "2 | a=1,$fname=$fvalue\n";
    print "\n";
}

my $fname = undef;
foreach my $arg (@ARGV) {
    if ($arg eq "-f") {
        $fname = undef;
        next;
    }
    if (!defined $fname) {
        $fname = $arg;
        next;
    }
    print_instance($fname, $arg);
}
