#!/usr/bin/perl
use strict;
use warnings;
use lib 'lib';
use DR::SAP;
use Data::Dumper;
use Devel::SimpleTrace;

DR::SAP::WSDL::VendorMaintenance->initialize(file => 'share/VendorMaintenance.wsdl');
my $sap = DR::SAP->new(username => 'PIRMSSU', password => 'Digital123');

my $response = eval {
	$sap->display_vendor(
		platform_id      => 'RW',
		platform_account => 'TEST-1275585492',
		account_group    => 'vendor',
	);
};
if($@){
	$sap->trace->printResponse;
	die $@;
}
warn Dumper $response->vendor;
warn $response->trace->elapse('connect');
$response->trace->printTimings;
$response->trace->printRequest;
$response->trace->printResponse;
