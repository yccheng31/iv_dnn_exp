#!/usr/bin/perl -w


use File::Basename;
use File::Path;
use File::Spec;

die "To use, $0 [inark] [outmat]\n" if(@ARGV != 2);
my ($inark, $outmat) = @ARGV;
my ($tn, $td, $te) = fileparse($outmat, qr/\.[^.]*/);
mkpath($td) if(!(-d $td));
my $outscp =  File::Spec->catfile($td, $tn . ".scp");

open INARK, $inark or die "Cannot open $inark:\n$!\n";
open OUTMAT, ">$outmat" or die "Cannot write to $outmat:\n$!\n";
open OUTSCP, ">$outscp" or die "Cannot write to $outscp:\n$!\n";

while(<INARK>)
{
	chomp;
	s/^\s+//g;
	s/\s+$//g;
	if($_ =~ /\[/)
	{
		$_=~s/\[//g;
		print OUTSCP $_ . "\n";
	}
	elsif($_ =~ /\]/)
	{
		$_=~s/\]//g;
		s/^\s+//g;
		s/\s+$//g;
		print OUTMAT $_ . "\n";
	}
}
close OUTSCP;
close OUTMAT;
