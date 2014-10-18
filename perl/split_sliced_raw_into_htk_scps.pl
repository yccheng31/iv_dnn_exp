#!/usr/bin/perl -w

use File::Path;
use File::Find;
use File::Basename;

die "To use, $0 <indir> <outdir> <prefix>\n" if(@ARGV != 3);
my ($indir, $outdir, $prefix) = @ARGV;

mkpath($outdir) if(!(-d $outdir));

my %hash_state_ues;

find(\&findue, $indir);

my @states = sort {$a <=> $b} keys %hash_state_ues;
foreach my $s (@states)
{
	my $outfile = File::Spec->catfile($outdir, $prefix . "_state_$s.scp");
	open OUTFILE, ">$outfile" or die "Cannot write to $outfile:\n$!\n";
	foreach my $el (sort @{$hash_state_ues{$s}})
	{
		print OUTFILE $el . "\n";
	}
	close OUTFILE;
}

sub findue
{
	if($_=~/ue$/ || $_=~/mfc$/)
	{
		my ($tn, $td, $te) = fileparse($File::Find::name, qr/\.[^.]*/);
		my @tmpa = split(/_/, $tn);
		push(@{$hash_state_ues{$tmpa[$#tmpa]}}, $File::Find::name);
	}
}

