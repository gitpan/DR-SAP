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
my $response = eval { $sap->get_third_parties({platform_id => 'SW', platform_account => 1, account_group => 'vendor'} ) } or die $@;
my ($third_party) = grep { $_->third_party_id eq 'test-1274733412' } $response->all_third_parties;
$third_party->email(sprintf('email_%s@devnull.digitalriver.com', time));
$response = eval { $sap->update_third_party( { platform_id => 'SW', platform_account => 1, account_group => 'vendor' }, $third_party ) };
$sap->trace->printRequest;
$sap->trace->printResponse;
use Data::Dumper;
warn Dumper $response->messages;
