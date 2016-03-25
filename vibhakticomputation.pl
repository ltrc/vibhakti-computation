#!/usr/bin/perl
use Dir::Self;
use lib __DIR__ . "/src";
use lib __DIR__ . "/API";
use Getopt::Long;
use vibhakticompute;

GetOptions("help!"=>\$help,"input=s"=>\$input,"output=s",\$output);
print "Unprocessed by Getopt::Long\n" if $ARGV[0];
foreach (@ARGV) {
	print "$_\n";
	exit(0);
}

if($help eq 1)
{
	print "Vibhakti Computation  - Vibhakti Computation Version 2.3.2\n(14th July 2007 last modified on 9th August 2009)\n\n";
	print "usage : ./vibhakticomputation.pl [-i inputfile|--input=\"input_file\"] [-o outputfile|--output=\"output_file\"] \n";
	print "\tIf the output file is not mentioned then the output will be printed to STDOUT\n";
	exit(0);
}

if ($input eq "")
{
  $input="/dev/stdin";
}

vibhakticompute($input, $output);
