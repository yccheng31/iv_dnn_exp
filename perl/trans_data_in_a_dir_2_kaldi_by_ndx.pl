#!/usr/bin/perl -w

use File::Basename;
use File::Path;
use File::Spec;
use File::Find;

die "To use, $0 [indir] [ndx] [outark]\n" if(@ARGV != 3);
my ($indir, $ndx, $outark) = @ARGV;
my ($tn, $td, $te) = fileparse($outark, qr/\.[^.]*/);
if($te ne ".ark")
{
	$outark = File::Spec->catfile($td, $tn . ".ark");
}
$outscp =  File::Spec->catfile($td, $tn . ".scp");

mkpath($td) if(!(-d $td));
my $prefix = "syl_";
my @ndx_ids = ();
my %hash_ndx;
my @infiles;
my %hash_in_files;
open NDX, $ndx or die "Cannot open $ndx:\n$!\n";
while(<NDX>)
{
	chomp;
	s/^\s+//g;
	s/\s+$//g;
	push(@ndx_ids, $_);
	$hash_ndx{$_}++;
}
close NDX;
find(\&find_feature_by_ndx, $indir);

my $nlines = @infiles;
die "The ndx file has only " . ($#ndx_ids+1) . " lines while txt has $nlines lines.\n" if($nlines != @ndx_ids);


open OUTARK, ">$outark" or die "Cannot write to $outark:\n$!\n";
open OUTSCP, ">$outscp" or die "Cannot write to $outscp:\n$!\n";
my $nn = 0;
my $ncn = 0;
my %hash_dim_uniq_val;
my %hash_only_single_val;

foreach my $feat_file (@infiles)
{
	open FEAT_FILE, $feat_file or die "Cannot open $feat_file:\n$!\n";
	my $buf = <FEAT_FILE>;
	while(<FEAT_FILE>)
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
	close FEAT_FILE;
}
foreach my $el (sort {$a<=>$b} keys %hash_dim_uniq_val)
{
	my @tmpa = sort {$a<=>$b} keys %{$hash_dim_uniq_val{$el}};
	if($#tmpa == 0)
	{
		$hash_only_single_val{$el} = $tmpa[0];
		print "[WARNING] Dimension $el only has a single value $tmpa[0]\n";
	}
}
	
foreach my $feat_file (@infiles)
{
	open FEAT_FILE, $feat_file or die "Cannot open $feat_file:\n$!\n";
	my $buf = <FEAT_FILE>;
	while(<FEAT_FILE>)
	{
		chomp;
		s/^\s+//g;
		s/\s+$//g;
		my @tmpa = split(/\s+/, $_);
		my $id_nn = $hash_in_files{$feat_file}; #sprintf("%s%06d", $prefix, $nn);
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
	close FEAT_FILE;
}

close OUTARK;
close OUTSCP;

sub find_feature_by_ndx
{
	($tn, $td, $te) = fileparse($File::Find::name, qr/\.[^.]*/);
	if(exists($hash_ndx{$tn}))
	{
		push(@infiles, $File::Find::name);
		$hash_in_files{$File::Find::name} = $tn; 	
	}
}

