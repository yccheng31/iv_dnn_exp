#!/usr/bin/perl -w

use File::Basename;
use File::Path;
use File::Spec;

die "To use, $0 [intxt] [ndx] [outark]\n" if(@ARGV != 3);
my ($intxt, $ndx, $outark) = @ARGV;
my ($tn, $td, $te) = fileparse($outark, qr/\.[^.]*/);
if($te ne ".ark")
{
	$outark = File::Spec->catfile($td, $tn . ".ark");
}
$outscp =  File::Spec->catfile($td, $tn . ".scp");

mkpath($td) if(!(-d $td));
my $prefix = "syl_";

my @ndx_ids = ();
open NDX, $ndx or die "Cannot open $ndx:\n$!\n";
while(<NDX>)
{
	chomp;
	s/^\s+//g;
	s/\s+$//g;
	push(@ndx_ids, $_);
}
close NDX;
open INTXT, $intxt or die "Cannot open $intxt:\n$!\n";
open OUTARK, ">$outark" or die "Cannot write to $outark:\n$!\n";
open OUTSCP, ">$outscp" or die "Cannot write to $outscp:\n$!\n";
my $nn = 0;
my $ncn = 0;
my %hash_dim_uniq_val;
my $buf = <INTXT>;
while(<INTXT>)
{
        chomp;
        s/^\s+//g;
        s/\s+$//g;
        my @tmpa = split(/\s+/, $_);
	$nn++ if(@tmpa > 0 && $_ ne "");
	for(my $k = 0; $k <= $#tmpa; $k++)
	{
		$hash_dim_uniq_val{$k}{$tmpa[$k]}++;
	}
}
close INTXT;
my $nlines = $nn;
die "The ndx file has only " . ($#ndx_ids+1) . " lines while txt has $nlines lines.\n" if($nlines != @ndx_ids);
$nn = 0;
my %hash_only_single_val;
foreach my $el (sort {$a<=>$b} keys %hash_dim_uniq_val)
{
	my @tmpa = sort {$a<=>$b} keys %{$hash_dim_uniq_val{$el}};
	if($#tmpa == 0)
	{
		$hash_only_single_val{$el} = $tmpa[0];
		print "[WARNING] Dimension $el only has a single value $tmpa[0]\n";
	}
}
open INTXT, $intxt or die "Cannot open $intxt:\n$!\n";
$buf = <INTXT>;
while(<INTXT>)
{
	chomp;
	s/^\s+//g;
	s/\s+$//g;
	my @tmpa = split(/\s+/, $_);
	$nn++;
	my $id_nn = $ndx_ids[$nn-1]; #sprintf("%s%06d", $prefix, $nn);
	$ncn += length($id_nn);
	print OUTSCP $id_nn . " " . $outark.":". ($ncn+1) . "\n";
	print OUTARK $id_nn . "  [\n";
	print OUTARK "  ";
	$ncn += 6;
	for(my $k = 0; $k <= $#tmpa; $k++)
	{
		if(!exists($hash_only_single_val{$k}))
		{
			print OUTARK $tmpa[$k]." ";
			$ncn += length($tmpa[$k]);
			$ncn += 1;
		}
	}
	print OUTARK "]\n";
	$ncn += 2;
}
close INTXT;
close OUTARK;
close OUTSCP;
