#!/usr/bin/env perl

use warnings;
use strict;

while (my $line = <>) {
    chomp $line;
    my @feats;
    if ($line =~ /^shared/) {
        $line =~ s/^.*\|[^ ]* //;
#        print STDERR "ERR: $line\n";
        @feats = split /\s+/, $line;
    }
    $line = <>;
    chomp $line;
    $line =~ s/\|.*$//;
    $line = $line . "| " . (join " ", map {"a=0,".$_} @feats);
    print $line . "\n";
    
    $line = <>;
    chomp $line;
    $line =~ s/\|.*$//;
    $line = $line . "| " . (join " ", map {"a=1,".$_} @feats);
    print $line . "\n";
    
    $line = <>;
    print "\n";
}
