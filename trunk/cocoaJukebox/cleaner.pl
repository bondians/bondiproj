#!/usr/bin/perl

use strict;

my $file  = shift @ARGV;
my $ofile = shift @ARGV;

open FP,  $file      or die "Could not open file:$file";
open OFP, "> $ofile" or die "Could not open output file:$ofile";
my $start = 0;

for my $line (<FP>) {
    if ( $line =~ m#^\\.#) {
        $start = 0;
    }
    if ( $start == 1 ) {
        print OFP $line;
    }
    if ( $line =~ m/^COPY/ ) {
        $start = 1;
    }


}

close FP;
close OFP;
