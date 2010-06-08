#!/usr/bin/perl
use strict;
use warnings;
use lib 'lib';
use DR::SAP;
use Data::Dumper;
use Devel::SimpleTrace;

DR::SAP::WSDL::VendorMaintenance->initialize(file => 'share/VendorMaintenance.wsdl');
my $sap = DR::SAP->new(username => 'PIRMSSU', password => 'Digital123');

my $response = $sap->update_vendor(
	vendor => {
		main_contact     => 'Test Contact',
		vendor_name      => 'Test Vendor',
		payment_mode     => 'automatic',
		platform_account => 'TEST-1275585492',
		account_group    => 'vendor',
		currency         => 'USD',
		street_address   => '123 - ' . localtime,
		city             => 'Test City',
		postal_code      => '12345',
		country          => 'US',
		payment_method   => 'F',
		platform_id      => 'RW',
		email            => 'foo@bar.com',
		#primary_bank => {
		#	name => 'Foo',
		#	account_holder => 'Account Holder',
		#	account_number => 123123123,
		#	routing_number => '321321321',
		#	address_1 => '123',
		#	city => 'Eden Prairie',
		#	region => 'MN',
		#	postal_code => '55123',
		#	country => 'US',
		#}
	}
);
$response->trace->printRequest;
$response->trace->printResponse;
warn Dumper $response->vendor, $response->messages;
$response->trace->printTimings;
warn $response->trace->elapse('connect');
