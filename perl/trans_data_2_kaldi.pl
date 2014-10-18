#!/usr/bin/perl -w

use File::Basename;
use File::Path;
use File::Spec;

die "To use, $0 [intxt] [outark]\n" if(@ARGV != 2);
my ($intxt, $outark) = @ARGV;
my ($tn, $td, $te) = fileparse($outark, qr/\.[^.]*/);
if($te ne ".ark")
{
	$outark = File::Spec->catfile($td, $tn . ".ark");
}
$outscp =  File::Spec->catfile($td, $tn . ".scp");

mkpath($td) if(!(-d $td));
my $prefix = "syl_";

open INTXT, $intxt or die "Cannot open $intxt:\n$!\n";
open OUTARK, ">$outark" or die "Cannot write to $outark:\n$!\n";
open OUTSCP, ">$outscp" or die "Cannot write to $outscp:\n$!\n";
my $nn = 0;
my $ncn = 0;
my %hash_dim_uniq_val;
while(<INTXT>)
{
        chomp;
        s/^\s+//g;
        s/\s+$//g;
        my @tmpa = split(/\s+/, $_);
	for(my $k = 0; $k <= $#tmpa; $k++)
	{
		$hash_dim_uniq_val{$k}{$tmpa[$k]}++;
	}
}
close INTXT;
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
while(<INTXT>)
{
	chomp;
	s/^\s+//g;
	s/\s+$//g;
	my @tmpa = split(/\s+/, $_);
	$nn++;
	my $id_nn = sprintf("%s%06d", $prefix, $nn);
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
