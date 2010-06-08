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

my $vendor = {
	account_group    => 'vendor',
	platform_id      => 'SW',
	platform_account => 1,
};

my $third_party = {
	account_group      => 'third_party',
	'payment_terms'    => '0001',
	'third_party_name' => 'Third Test',
	'account_group'    => 'third_party',
	'currency'         => 'USD',
	'email'            => 'foo@digitalriver.com',
	'street_address'   => '1234 Fleet',
	'city'             => 'Eden Prairie',
	'postal_code'      => '55344',
	'skip_check_run'   => '',
	'third_party_id'   => 'test-' . time,
	'country'          => 'US',
	'region'           => 'MN',
	'payment_method'   => 'F',
	'po_box'           => 'N',
};

my $response = $sap->add_third_party( $vendor => $third_party );
$response->trace->printRequest;
$response->trace->printResponse;
warn Dumper $response->raw_response;
