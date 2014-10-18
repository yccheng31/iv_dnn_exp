#!/usr/bin/perl -w

use File::Path;
use File::Spec;
use File::Basename;

die "To use, $0 [scp] [refscp] [newscp]\n" if(@ARGV != 3);
my ($scp, $refscp, $newscp) = @ARGV;
my ($tn, $td, $te) = fileparse($newscp, qr/\.[^.]*/);
mkpath($td) if(!(-d $td));
my @idlist;
open REF, $refscp or die "Cannot open $refscp:\n$!\n";
my $nn = 0;
while(<REF>)
{
	chomp;
	s/^\s+//g;
	s/\s+$//g;
	$nn++;
	my @tmpa = split(/\s+/, $_);
	if(@tmpa > 1)
	{
		push(@idlist, $tmpa[0]);
	}
	else
	{
		die "Kaldi scp file $refscp format error at line $nn: " . $_ . "\n";
	}
}
close REF;
my %hash_content;
open SCP, $scp or die "Cannot open $scp:\n$!\n";
$nn = 0;
while(<SCP>)
{
	chomp;
	s/^\s+//g;
	s/\s+$//g;
	my @tmpa = split(/\s+/, $_);
	$nn++;
	if(@tmpa > 1)
	{
		$hash_content{$tmpa[0]} = $_;
	}	
	else
	{
		die "Kaldi scp file $scp format error at line $nn: " . $_ . "\n";
	}
}
close SCP;
open NEWSCP, ">$newscp" or die "Cannot write to $newscp:\n$!\n";
foreach my $id(@idlist)
{
	die "ID list mismatch, $id is not found in $refscp\n" if(!exists($hash_content{$id}));
	print NEWSCP $hash_content{$id} . "\n";
}
close NEWSCP;

