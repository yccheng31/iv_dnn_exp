#!/usr/bin/perl -w

my $str = '2010_0522_0821_08__state_0  [ 0.1674806 -0.1064971 0.2209806 0.4910489 -0.4754826 -0.08908956 -0.06500459 0.1364792 0.1375576 -0.07211242 -0.04662377 -0.232387 0.2248037 0.02318181 -0.1294941 -0.04665251 -0.2455245 -0.09859013 0.1645271 -0.4377406 -0.07274728 0.08517865 0.053826 0.2360363 -0.4766858 0.05903173 -0.03812912 -0.100217 -0.09202377 0.111271 0.2000908 -0.1606678 -0.2754458 0.009322812 0.0137964 -0.02749076 -0.08904856 0.02319452 -0.1414531 0.1106932 -0.03632236 0.2486874 -0.01511811 0.1303104 -0.0502865 0.1402913 -0.01332352 0.06033513 -0.1912237 -0.02870347 -0.1179285 0.1020701 -0.1020113 -0.2434298 0.05316044 -0.2265018 -0.006448204 -0.03050099 -0.04563927 -0.2023143 0.2669125 -0.09495746 -0.02464024 0.03054657 ]
';

my ($key, @data) = ParseKaldiLine($str);
print $str . "\n";
print "[$key]\n";
print "[".substr($key, 0, index($key, "_state_")) . "]\n";
print "[".substr($key, index($key, "_state_")+7) . "]\n";
foreach my $n (0..$#data)
{
	print " " if($n > 0);
	my $n1 = $n + 1;
	print "$n1:$data[$n]";
}
print "\n";

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
