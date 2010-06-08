#!/usr/bin/perl
use strict;
use warnings;
use lib 'lib';
use DR::SAP;
use Data::Dumper;
use Devel::SimpleTrace;
use DR::SAP::WSDL::VendorMaintenance;
use DR::SAP::WSDL::ThirdPartyVendor;

DR::SAP::WSDL::VendorMaintenance->initialize(file => 'share/VendorMaintenance.wsdl');
DR::SAP::WSDL::ThirdPartyVendor->initialize(file => 'share/ThirdPartyVendor.wsdl');
my $sap = DR::SAP->new(username => 'PIRMSSU', password => 'Digital123');

my $vendor = create_vendor("Mine");
my $other = create_vendor("Other");

my $response = $sap->link_vendors($vendor => $other);
$response->trace->printRequest;
$response->trace->printResponse;
warn Dumper $response;
$response->trace->printTimings;
warn $response->trace->elapse('connect');

sub create_vendor {
	my $name = shift || 'Test';
	my $response = $sap->create_vendor(
		vendor => {
			vendor_name      => "$name Vendor",
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
			primary_bank     => {
				name           => '',
				account_holder => '',
				account_number => '',
				routing_number => '',
				address_1      => '',
				city           => '',
				region         => 'MN',
				postal_code    => '',
				country        => 'US',
			}
		}
	);
	return $response->vendor;
}
