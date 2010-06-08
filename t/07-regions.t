use strict;
use warnings;
use DR::SAP;

use Test::More qw(no_plan);

my $sap = DR::SAP->new(username => 'PIRMSSU', password => 'Digital123');

is $sap->get_region_name('US','MN'), 'Minnesota', 'US->MN == Minnesota';
ok !defined $sap->get_region_name('US','XY'), 'bogus region returns undef';
isa_ok $sap->get_regions_by_country('US'), 'HASH';
ok exists $sap->get_regions_by_country('US')->{MN}, 'MN exists in US region hash';
isa_ok $sap->get_regions_by_country(), 'HASH';
ok exists $sap->get_regions_by_country->{US}, 'US exists in country hash';
is $sap->get_region_code('US','Minnesota'), 'MN', 'US->Minnesota == MN';
is $sap->get_region_code('US','Minnesota'), 'MN', "US->Minnesota == MN (second time's the charm!)";

my $countries = $sap->get_countries_without_regions;
isa_ok $countries, 'HASH', '$countries';
