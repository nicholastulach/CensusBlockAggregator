#!/usr/bin/perl
###
# Written by: Nicholas K Tulach
# 
# A short script to pull block-level Census data using the Census API
#
# Usage: perl get-census-by-blocks.pl tract-list.csv output.csv
# 
# Limitations: If you use a different source file for Census tract identifiers,
#              you may need to modify the "fields" array accordingly
###

use strict;
use warnings;
use Text::CSV;
use LWP::Simple;

# Census API key - signup here: http://api.census.gov/data/key_signup.html
my $key = "";
# Census variables to get
my $get = "H0030001,H0030002,H0030003";
# Header list should match the Census variables above, 
# but put each variable in quotes 
my $header_list = q("H0030001","H0030002","H0030003");

my $csv = Text::CSV->new ({
  binary    => 1,
  auto_diag => 1,
  sep_char  => ','
});

my $infile = $ARGV[0] or die "Need to get CSV file on the command line\n";
my $outfile = $ARGV[1] or die "Need to give output CSV file on the command line\n";

open(my $data, '<:encoding(utf8)', $infile) or die "Could not open '$infile' $!\n";

my $content = "";

open(OUTFILE, ">>$outfile") or die "Could not open '$outfile' $!\n";

# Prints the header at the top of the file only once. 
print OUTFILE qq($header_list,"state","county","tract","block",);

while (my $fields = $csv->getline( $data )) {

  # These variables are contigent on the source list of FIPS/Census tract codes
  # I got mine from http://www.census.gov/geo/maps-data/data/gazetteer2010.html
  my @fields = $csv->fields();
  my $state = $fields->[2];
  my $county = $fields->[3];
  my $tract = $fields->[4];

  print "FIPS: $state$county$tract\n";

  # This is the critical part, where you select which Census variables 
  # you're interested in and call out to the API
  # For more info, see: 
  # http://www.census.gov/data/developers/data-sets/decennial-census-data.html
  my $url = "http://api.census.gov/data/2010/sf1?key=$key&get=$get&for=block:*&in=state:$state+county:$county+tract:$tract";

  my $content = get $url;
  die "Couldn't get $url" unless defined $content;

  # Can remove the following line if you want a JSON-y file instead of CSV
  $content =~ s/[\[\]]//g;

  # The following line removes the header (sometimes—doesn't seem to always work)
  $content =~ s/$header_list,"state","county","tract","block",\n//g;

  $content = "\n" . $content;
  print OUTFILE $content;
}

print OUTFILE "\n";

close $data;
close OUTFILE;
