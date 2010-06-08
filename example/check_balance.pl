#!/usr/bin/perl
use strict;
use warnings;
use lib 'lib';
use DR::SAP;
use Data::Dumper;
use Devel::SimpleTrace;

DR::SAP::WSDL::BalanceCheck->initialize(file => 'share/BalanceCheck.wsdl');
my $sap = DR::SAP->new(username => 'PIRMSSU', password => 'Digital123');

my $response = eval { $sap->check_balance(
	platform_id      => 'SW',
	platform_account => '1',
)};
if($@){
	warn $@;
	$sap->trace->printRequest;
	$sap->trace->printResponse;
	die $@;
}
warn sprintf('%.2f %s', $response->balance, $response->currency);
warn $response->trace->elapse('connect');
$response->trace->printTimings;
$response->trace->printRequest;
$response->trace->printResponse;
