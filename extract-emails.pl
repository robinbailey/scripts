#!/usr/bin/perl
use strict;

my ($line, @EMAol, @EMHotmail, @EMYahoo, @EMGoogle, @EMMsn, @EMOther);

chomp(my $file = "$ARGV[0]");
if (!$file){print "Usage: email.pl <filename>\n"; exit;}
open (IN, "<$file") || print "ERROR: COULD NOT OPEN FILE $file - $!";

while ($line = <IN>) {
     
     chop $line;
     
     if ($line=~/\@yahoo./) {
          push (@EMYahoo, $line);
     } elsif ($line=~/\@hotmail./) {
          push (@EMHotmail, $line);
     } elsif ($line=~/\@aol.com/) {
          push (@EMAol, $line);
	 } elsif ($line=~/\@gmail.com/ ||$line=~/\@googlemail.com/) {
          push (@EMGoogle, $line);
     } elsif ($line=~/\@msn.com/) {
          push (@EMMsn, $line);
     } else {
          push (@EMOther, $line);
     }
}
close IN;


open (hotmail, ">_hotmail.txt") || print "could not open hotmail.txt $!";
print hotmail join("\n", @EMHotmail);
print hotmail ("\n");
close (hotmail);


open (aol, ">_aol.txt") || print "could not open aol.txt $!";
print aol join("\n", @EMAol);
print aol ("\n");
close (aol);

open (yahoo, ">_yahoo.txt") || print "could not open yahoo.txt $!";
print yahoo join("\n", @EMYahoo);
print yahoo ("\n");
close (yahoo);

open (gmail, ">_gmail.txt") || print "could not open gmail.txt $!";
print gmail join("\n", @EMGoogle);
print gmail ("\n");
close (gmail);

open (msn, ">_msn.txt") || print "could not open msn.txt $!";
print msn join("\n", @EMMsn);
print msn ("\n");
close (msn);

open (other, ">_other.txt") || print "could not open other.txt $!";
print other join("\n", @EMOther);
print other ("\n");
close (other);