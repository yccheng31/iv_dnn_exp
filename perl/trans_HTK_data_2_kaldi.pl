#!/usr/bin/perl -w

use File::Basename;
use File::Path;
use File::Spec;

die "To use, $0 [in_HTK_scp] [outark]\n" if(@ARGV != 2);
my ($inscp, $outark) = @ARGV;
my ($tn, $td, $te) = fileparse($outark, qr/\.[^.]*/);
if($te ne ".ark")
{
	$outark = File::Spec->catfile($td, $tn . ".ark");
}
$outscp =  File::Spec->catfile($td, $tn . ".scp");

mkpath($td) if(!(-d $td));
my $prefix = "";
my $ncn = 0;
open INSCP, $inscp or die "Cannot open $inscp:\n$!\n";
open OUTARK, ">$outark" or die "Cannot write to $outark:\n$!\n";
open OUTSCP, ">$outscp" or die "Cannot write to $outscp:\n$!\n";
while(<INSCP>)
{
	chomp;
	s/^\s+//g;
	s/\s+$//g;
	# read the current HTK file:
	if($_ ne "") {
		my ($nSamples, $sample_period, $sample_size, $parameter_kind, $dim, $dataptr) = Get_HTK_Features($_);
		if($parameter_kind > 4096 && $parameter_kind < 8192)
		{
			$parameter_kind -= 4096;
		}
		my @fet_data = @$dataptr;
		($tn, $td, $te) = fileparse($_, qr/\.[^.]*/);
		$ncn += length($tn);
		print OUTSCP $tn . " " . $outark.":". ($ncn+1) . "\n";
		print OUTARK $tn . "  [\n";
		$ncn += 4;
		foreach my $tmpn (0 .. $#fet_data)
		{
			print OUTARK "  ";
			$ncn += 2;
			foreach my $el (@{$fet_data[$tmpn]})
			{
				print OUTARK $el." ";
				$ncn += length($el);
				$ncn += 1;
			}
			if($tmpn != $#fet_data) {
				print OUTARK "\n";
				$ncn += 1;
			}
		}
		print OUTARK "]\n";
		$ncn += 2;
	}
}
close INSCP;
close OUTARK;
close OUTSCP;


sub Get_HTK_Features
{
	my ($fet)=@_;
	my $nSamples = -1;
	my $sample_period = -1;
	my $sample_size = -1;
	my $parameter_kind = -1;
	my $dim = 0;
	my @data = ();
	if (-e $fet)
	{
		open FET, $fet;
		my $nn = read(FET, $buf, 4);
		# little endian
		$nSamples = unpack("l",$buf) if($nn == 4);
		# big endian
		#$res = unpack("N",$buf) if($nn == 4);
		$nn = read(FET, $buf, 4);
		$sample_period = unpack("l",$buf) if($nn == 4);
		$nn = read(FET, $buf, 2);
		$sample_size = unpack("s",$buf) if($nn == 2);
		$nn = read(FET, $buf, 2);
		$parameter_kind = unpack("s",$buf) if($nn == 2);
		$dim = $sample_size / 4 if($sample_size > 0);
		my $floatbuf = 0.0;
		foreach my $k (0..($nSamples-1))
		{
			my @tmp_sample = ();
			foreach my $d (0..($dim-1))
			{
				$nn = read(FET, $buf, 4);
				if($nn == 4)
				{
					$floatbuf = unpack("f",$buf);
					push(@tmp_sample, $floatbuf);
				}
				else
				{
					die "Read file fail at ${k}-th sample dimension $d for file $fet\n";
				}
			}
			push(@data, [@tmp_sample]);
		}
		close FET;
	}
	return ($nSamples, $sample_period, $sample_size, $parameter_kind, $dim, \@data);
}
