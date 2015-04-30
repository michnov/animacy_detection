#!/usr/bin/env perl

use warnings;
use strict;

while (my $line = <>) {
    chomp $line;
    my ($shared_first, @shared_rest) = split /\t/, $line;
    my @feats;
    if ($shared_first =~ /^shared/) {
        $shared_first =~ s/^.*\|[^ ]* //;
#        print STDERR "ERR: $line\n";
        @feats = split /\s+/, $shared_first;
    }
    
    $line = <>;
    chomp $line;
    my ($first, @rest) = split /\t/, $line;
    $first =~ s/\|.*$//;
    $first = $first . "| " . (join " ", map {"a=0,".$_} @feats);
    print join "\t", ($first, @rest, @shared_rest);
    print "\n";
    
    $line = <>;
    chomp $line;
    ($first, @rest) = split /\t/, $line;
    $first =~ s/\|.*$//;
    $first = $first . "| " . (join " ", map {"a=1,".$_} @feats);
    print join "\t", ($first, @rest, @shared_rest);
    print "\n";
    
    $line = <>;
    print "\n";
}
