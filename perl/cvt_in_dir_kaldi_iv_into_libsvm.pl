#!/usr/bin/perl -w

use File::Path;
use File::Find;
use File::Basename;

die "To use, $0 <indir> <outdir>\n" if(@ARGV != 2);
my ($indir, $outdir) = @ARGV;
mkpath($outdir) if(!(-d $outdir));

my %hash_train_ivs;
my %hash_test_ivs;

foreach my $ns (0..7)
{
	my $in_ark_train = File::Spec->catfile($indir, "$ns/ivector_train.ark");
	my $in_ark_test = File::Spec->catfile($indir, "$ns/ivector_test.ark");
	open INARKTR, $in_ark_train or die "Cannot open $in_ark_train:\n$!\n";
	while(<INARKTR>)
	{
		chomp;
		s/^\s+//g;
		s/\s+$//g;
		my ($tmpkey, @tmpdata) = ParseKaldiLine($_);
		my $key = substr($tmpkey, 0, index($tmpkey, "_state_"));
		my $state = substr($tmpkey, index($tmpkey, "_state_")+7);
		foreach my $el (@tmpdata)
		{
			push(@{$hash_train_ivs{$key}}, $el);
		}
	}
	close INARKTR;
	open INARKTS, $in_ark_test or die "Cannot open $in_ark_test:\n$!\n";
	while(<INARKTS>)
	{
		chomp;
		s/^\s+//g;
		s/\s+$//g;
		my ($tmpkey, @tmpdata) = ParseKaldiLine($_);
		my $key = substr($tmpkey, 0, index($tmpkey, "_state_"));
		my $state = substr($tmpkey, index($tmpkey, "_state_")+7);
		foreach my $el (@tmpdata)
		{
			push(@{$hash_test_ivs{$key}}, $el);
		}
	}
	close INARKTS;
}

my $out_train_livsvm_data = File::Spec->catfile($outdir, "train.libsvm.data");
my $out_test_livsvm_data = File::Spec->catfile($outdir, "test.libsvm.data");
my $out_train_livsvm_data_id = File::Spec->catfile($outdir, "train.libsvm.id");
my $out_test_livsvm_data_id = File::Spec->catfile($outdir, "test.libsvm.id");
open TRSVM, ">$out_train_livsvm_data" or die "Cannot write to $out_train_livsvm_data:\n$!\n";
open TRSVMID, ">$out_train_livsvm_data_id" or die "Cannot write to $out_train_livsvm_data_id:\n$!\n";
foreach my $key (sort keys %hash_train_ivs)
{
	print TRSVMID $key . "\n";
	my @tmpdata = @{$hash_train_ivs{$key}};
	foreach my $n (0..$#tmpdata)
	{
		print TRSVM " " if($n > 0);
		my $n1 = $n + 1;
		print TRSVM "$n1:$tmpdata[$n]";
	}	
	print TRSVM "\n";
}
close TRSVM;
close TRSVMID;

open TSSVM, ">$out_test_livsvm_data" or die "Cannot write to $out_test_livsvm_data:\n$!\n";
open TSSVMID, ">$out_test_livsvm_data_id" or die "Cannot write to $out_test_livsvm_data_id:\n$!\n";
foreach my $key (sort keys %hash_test_ivs)
{
	print TSSVMID $key . "\n";
	my @tmpdata = @{$hash_test_ivs{$key}};
	foreach my $n (0..$#tmpdata)
	{
		print TSSVM " " if($n > 0);
		my $n1 = $n + 1;
		print TSSVM "$n1:$tmpdata[$n]";
	}	
	print TSSVM "\n";
}
close TSSVM;
close TSSVMID;


sub ParseKaldiLine
{
	my ($str) = @_;
	my $lbpos = index($str, "[");
	my $rbpos = rindex($str, "]");

	my $str1 = substr($str, 0, $lbpos);
	my $str2 = substr($str, $lbpos + 1, $rbpos - $lbpos - 1);
	$str1=~s/^\s+//g;
	$str1=~s/\s+$//g;
	$str2=~s/^\s+//g;
	$str2=~s/\s+$//g;
	#print "$str\n[$str1]\n[$str2]\n";
	my @tmpa = split(/\s+/, $str2);
	return ($str1, @tmpa);
}
