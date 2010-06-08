#!/usr/bin/perl
use strict;
use warnings;
use lib 'lib';
use DR::SAP;
use Data::Dumper;
use Devel::SimpleTrace;
use DR::SAP::WSDL::VendorMaintenance;

DR::SAP::WSDL::VendorMaintenance->initialize(file => 'share/VendorMaintenance.wsdl');
my $sap = DR::SAP->new(username => 'PIRMSSU', password => 'Digital123');

my $response = $sap->create_vendor(
	vendor => {
		vendor_name      => 'Vendor test',
		payment_mode     => 'automatic',
		main_contact     => 'Test',
		platform_account => 'TEST-' . time,
		account_group    => 'vendor',
		currency         => 'USD',
		street_address   => 'address 1',
		city             => 'Eden Prairie',
		postal_code      => '55344',
		region           => '',
		country          => 'US',
		payment_method   => 'C',
		platform_id      => 'RW',
		email            => 'foo@bar.com',
		primary_bank => {
			name => '',
			account_holder => '',
			account_number => '',
			routing_number => '',
			address_1 => '',
			city => '',
			region => 'MN',
			postal_code => '',
			country => 'US',
		}
	}
);
$response->trace->printRequest;
$response->trace->printResponse;
warn Dumper $response->vendor, $response->messages, { 'dpl?' => $response->dpl_review_required };
$response->trace->printTimings;
warn $response->trace->elapse('connect');
