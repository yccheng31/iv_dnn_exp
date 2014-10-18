#!/usr/bin/perl -w

use File::Spec;
use File::Basename;
use File::Path;

die "To use, $0 <input_data> <outdir>\n" if(@ARGV < 2);

my ($indoc, $outdir) = @ARGV;
my ($tn, $td, $te) = fileparse($indoc, qr/\.[^.]*/);
my $data_log = File::Spec->catfile($outdir, $tn . "_data" . $te);
my $target_log = File::Spec->catfile($outdir, $tn . "_target" . $te);

mkpath($outdir) if (!(-d $outdir));

open INDOC, $indoc or die "Cannot open $indoc:\n$!\n";
my $hdr = <INDOC>;
chomp($hdr);
$hdr=~s/^\s+//g;
$hdr=~s/\s+$//g;
$hdr=~s/\:/ /g;
$hdr=~s/\s+/ /g;
my @hdra = split(/[\s+]/, $hdr);
#foreach $hdrl (@hdra){
#	print $hdrl . "\n";
#}
die "headerline [$hdr] has format error\n" if(@hdra != 6);
my $nNum = $hdra[1];
my $dim = $hdra[3];
my $nTargetdim = $hdra[5];
#print $nNum . " " . $dim . " " . $nTargetdim . "\n";

open DATA, ">$data_log" or die "Cannot write to $data_log:\n$!\n";
open TARGET, ">$target_log" or die "Cannot write to $target_log:\n$!\n";
foreach my $nn (0..$nNum-1)
{
	my $linenn = <INDOC>;
	chomp($linenn);
	$linenn=~s/^\s+//g;
	$linenn=~s/\s+$//g;
	$linenn=~s/\s+/ /g;
	my @tmpa = split(/\s+/, $linenn);
	if(@tmpa != ($dim+$nTargetdim))
	{
		die "At line " . ($nn+1) . ", dimension of input+output = " . ($#tmpa+1) . ", should be " . ($dim+$nTargetdim) . "\n";
	}
	for(my $ni = 0; $ni <= $dim-2; $ni++)
	{
		print DATA $tmpa[$ni] . " ";
	}
	print DATA $tmpa[$dim-1] . "\n";
	for(my $ni = $dim; $ni < $#tmpa - 2; $ni++)
	{
		print TARGET $tmpa[$ni] . " ";
	}
	print TARGET $tmpa[$#tmpa] . "\n";
}
close INDOC;
close DATA;
close TARGET;

