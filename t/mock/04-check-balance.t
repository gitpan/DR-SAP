#!/usr/bin/perl
use strict;
use warnings;
use DR::SAP;
use DR::SAP::WSDL::VendorMaintenance;
use Try::Tiny;
use HTTP::Response;
use Test::More qw(no_plan);

DR::SAP::WSDL::BalanceCheck->initialize(file => 'share/BalanceCheck.wsdl');
my $sap = DR::SAP->new(username => 'PIRMSSU', password => 'Digital123');
$sap->transport_hook(transport_hook());
try {
	my $response = $sap->check_balance( platform_id => 'SW', platform_account => 1 );
	is($response->balance, '100.55', 'balance returned as expected');
} catch {
	diag $_;
	ok 0, 'failed!';
};

try {
	set_case('no-balance');
	my $response = $sap->check_balance( platform_id => 'SW', platform_account => 12 );
	is($response->balance, '0', 'no-balance returned as expected');
	ok $response->error_messages, 'has error messages';
} catch {
	diag $_;
	ok 0, 'failed!';
};

CHECK {
	my $xml = parse_xml();
	my $CASE = 'default';

	sub set_case {
		$CASE = shift;
	}

	sub transport_hook {
		return sub {
			my ( $request, $trace ) = @_;
			my $content = $request->decoded_content;
			is( $content, $xml->{$CASE}->{REQUEST}, "[$CASE] request translated as expected" );
			return HTTP::Response->new( 200, 'Constant', [ 'Content-Type' => 'text/xml' ], $xml->{$CASE}->{RESPONSE} );
		};

	}
}

sub parse_xml {
	my @data = <DATA>;
	my($all,$case,$phase);
	while(@data){
		my $l = shift @data;
		if ( $l =~ m/^# (?:(.+?): )?(REQUEST|RESPONSE)$/ ) {
			$case = $1 || 'default';
			$phase = $2;
		} elsif($l =~ m/^$/){
			next;
		} elsif($case && $phase){
			($all->{$case}->{$phase} ||= '') .= $l
		}
	}
	return $all;
}

__DATA__
# default: REQUEST
<?xml version="1.0" encoding="UTF-8"?>
<SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/"><SOAP-ENV:Body><p2:ZFII0001_BALANCE_CHECK xmlns:p2="http://itasca.digitalriver.com/ECC/Banking"><ZPLATFORMID>SW</ZPLATFORMID><ZPLATFORMACCT>1</ZPLATFORMACCT></p2:ZFII0001_BALANCE_CHECK></SOAP-ENV:Body></SOAP-ENV:Envelope>
# default: RESPONSE
<SOAP:Envelope xmlns:SOAP='http://schemas.xmlsoap.org/soap/envelope/'><SOAP:Header/><SOAP:Body><n0:ZFII0001_BALANCE_CHECK xmlns:n0='http://itasca.digitalriver.com/ECC/Banking' xmlns:prx='urn:sap.com:proxy:HCD:/1SAI/TAS574CFA6D32E5E6A94814:700:2008/06/25'><ZPLATFORMID>SW</ZPLATFORMID><ZPLATFORMACCT>1</ZPLATFORMACCT><ZBALANCE>-100.55</ZBALANCE><ZCURRKEY>USD</ZCURRKEY></n0:ZFII0001_BALANCE_CHECK></SOAP:Body></SOAP:Envelope>
# no-balance: REQUEST
<?xml version="1.0" encoding="UTF-8"?>
<SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/"><SOAP-ENV:Body><p2:ZFII0001_BALANCE_CHECK xmlns:p2="http://itasca.digitalriver.com/ECC/Banking"><ZPLATFORMID>SW</ZPLATFORMID><ZPLATFORMACCT>12</ZPLATFORMACCT></p2:ZFII0001_BALANCE_CHECK></SOAP-ENV:Body></SOAP-ENV:Envelope>
# no-balance: RESPONSE
<SOAP:Envelope xmlns:SOAP='http://schemas.xmlsoap.org/soap/envelope/'><SOAP:Header/><SOAP:Body><n0:ZFII0001_BALANCE_CHECK xmlns:n0='http://itasca.digitalriver.com/ECC/Banking' xmlns:prx='urn:sap.com:proxy:HCD:/1SAI/TAS574CFA6D32E5E6A94814:700:2008/06/25'><ZPLATFORMID>SW</ZPLATFORMID><ZPLATFORMACCT>12</ZPLATFORMACCT><ZINIT_VALIDATION_ERR><TYPE>E</TYPE><MESSAGE>Account ID is invalid. Please check.</MESSAGE></ZINIT_VALIDATION_ERR></n0:ZFII0001_BALANCE_CHECK></SOAP:Body></SOAP:Envelope>
