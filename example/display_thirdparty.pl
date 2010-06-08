#!/usr/bin/perl
use strict;
use warnings;
use lib 'lib';
use DR::SAP;
use Data::Dumper;
use Devel::SimpleTrace;
use DR::SAP::WSDL::Default;
use DR::SAP::WSDL::ThirdPartyVendor;

DR::SAP::WSDL::ThirdPartyVendor->initialize(file => 'share/ThirdPartyVendor.wsdl');
my $sap = DR::SAP->new(username => 'PIRMSSU', password => 'Digital123');
my $response = eval { $sap->get_third_parties({platform_id => 'SW', platform_account => 1, account_group => 'vendor'} ) };
use Data::Dumper;
print Dumper $response->all_third_parties;
