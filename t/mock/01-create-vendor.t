#!/usr/bin/perl
use strict;
use warnings;
use DR::SAP;
use DR::SAP::WSDL::VendorMaintenance;
use Try::Tiny;
use HTTP::Response;
use Test::More qw(no_plan);

DR::SAP::WSDL::VendorMaintenance->initialize(file => 'share/VendorMaintenance.wsdl');
my $sap = DR::SAP->new(username => 'PIRMSSU', password => 'Digital123');
$sap->transport_hook(transport_hook());
my $trace;
try {
	my $response = $sap->create_vendor(
		vendor => {
			vendor_name      => 'Test Vendor',
			main_contact     => 'Test',
			payment_mode     => 'automatic',
			platform_account => 'TEST-1273603453',
			account_group    => 'vendor',
			currency         => 'USD',
			street_address   => 'address 1',
			city             => 'Eden Prairie',
			postal_code      => '55344',
			region           => 'MN',
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
	isa_ok($response->vendor, 'DR::SAP::Data::Vendor', '$response->vendor');
	$trace = $response->trace;
} catch {
	diag $_;
	$trace = $sap->trace;
};

CHECK {
	my $xml = parse_xml();
	my $CASE = 'default';

	sub set_case {
		$CASE = shift;
	}

	sub transport_hook {
		my $case = shift || $CASE;
		return sub {
			my ( $request, $trace ) = @_;
			my $content = $request->decoded_content;
			is( $content, $xml->{$case}->{REQUEST}, 'request translated as expected' );
			return HTTP::Response->new( 200, 'Constant', [ 'Content-Type' => 'text/xml' ], $xml->{$case}->{RESPONSE} );
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
<SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/"><SOAP-ENV:Body><p2:VENDOR_MAINTENANCE xmlns:p2="http://itasca.digitalriver.com/ECC/VendorMaintenance"><ZTRANSTYPE>C</ZTRANSTYPE><ZPLATFORMID>RW</ZPLATFORMID><ZPLATFORMACCT>TEST-1273603453</ZPLATFORMACCT><ZACCOUNTGROUP>ZCLN</ZACCOUNTGROUP><ZCOMPCODE></ZCOMPCODE><ZPURCHORG>1000</ZPURCHORG><ZVENDORNAME>Test Vendor</ZVENDORNAME><ZSTREET>address 1</ZSTREET><ZCITY>Eden Prairie</ZCITY><ZCOUNTRY>US</ZCOUNTRY><ZREGION>MN</ZREGION><ZPOSTALCODE>55344</ZPOSTALCODE><ZPAYMODE>AUTO</ZPAYMODE><ZMAINCONTACT>Test</ZMAINCONTACT><ZMAINEMAIL>foo@bar.com</ZMAINEMAIL><ZPAYCURR>USD</ZPAYCURR><ZPAYMETHOD>C</ZPAYMETHOD><ZSKIPCHKRUN> </ZSKIPCHKRUN><BANK><ZBANKACCTHOLDER></ZBANKACCTHOLDER><ZACCTNUM></ZACCTNUM><ZROUTING></ZROUTING><ZBANKNAME></ZBANKNAME><ZBANKADDR01></ZBANKADDR01><ZBANKCITY></ZBANKCITY><ZBANKREGION>MN</ZBANKREGION><ZBANKPOSTCODE></ZBANKPOSTCODE><ZBANKCOUNTRY>US</ZBANKCOUNTRY></BANK></p2:VENDOR_MAINTENANCE></SOAP-ENV:Body></SOAP-ENV:Envelope>
# default: RESPONSE
<SOAP:Envelope xmlns:SOAP='http://schemas.xmlsoap.org/soap/envelope/'><SOAP:Header/><SOAP:Body><n0:VENDOR_MAINTENANCE xmlns:n0='http://itasca.digitalriver.com/ECC/VendorMaintenance' xmlns:prx='urn:sap.com:proxy:HCD:/1SAI/TASFEB69AE3BBDD387C7F03:700:2008/06/25'><ZTRANSTYPE>C</ZTRANSTYPE><ZPLATFORMID>RW</ZPLATFORMID><ZPLATFORMACCT>TEST-1273603453</ZPLATFORMACCT><ZACCOUNTGROUP>ZCLN</ZACCOUNTGROUP><ZCOMPCODE>1220</ZCOMPCODE><ZPURCHORG>1000</ZPURCHORG><ZVENDORNAME>Test Vendor</ZVENDORNAME><ZSTREET>address 1</ZSTREET><ZOTHERADDR01>NULL</ZOTHERADDR01><ZPOBOX>NULL</ZPOBOX><ZCITY>Eden Prairie</ZCITY><ZCOUNTRY>US</ZCOUNTRY><ZREGION>MN</ZREGION><ZPOSTALCODE>55344</ZPOSTALCODE><ZVATREG>NULL</ZVATREG><ZTIN>NULL</ZTIN><ZWEBURL>NULL</ZWEBURL><ZPAYTHRESHOLD>NULL</ZPAYTHRESHOLD><ZPRINTLOGO>0</ZPRINTLOGO><ZPAYMODE>AUTO</ZPAYMODE><ZMAINCONTACT>Test</ZMAINCONTACT><ZMAINEMAIL>foo@bar.com</ZMAINEMAIL><ZBIZCONTACT>NULL</ZBIZCONTACT><ZSALESCONTACT>NULL</ZSALESCONTACT><ZKEYGENCONTACT>NULL</ZKEYGENCONTACT><ZPAYCONTACT>NULL</ZPAYCONTACT><ZREMITCONTACT>NULL</ZREMITCONTACT><ZPHONE>NULL</ZPHONE><ZFAX>NULL</ZFAX><ZPAYCURR>USD</ZPAYCURR><ZSETTLEMENTCURRENCY>USD</ZSETTLEMENTCURRENCY><ZPAYMETHOD>C</ZPAYMETHOD><ZPAYTERMS>0013</ZPAYTERMS><ZEPASSPORT_WEBMONEY>NULL</ZEPASSPORT_WEBMONEY><ZSKIPCHKRUN>NULL</ZSKIPCHKRUN><BANK><ZBANKACCTHOLDER>NULL</ZBANKACCTHOLDER><ZIBAN>NULL</ZIBAN><ZACCTNUM>NULL</ZACCTNUM><ZSWIFT>NULL</ZSWIFT><ZROUTING>NULL</ZROUTING><ZSORTCODE>NULL</ZSORTCODE><ZBANKNAME>NULL</ZBANKNAME><ZBANKADDR01>NULL</ZBANKADDR01><ZBANKADDR02>NULL</ZBANKADDR02><ZBANKCITY>NULL</ZBANKCITY><ZBANKREGION>NULL</ZBANKREGION><ZBANKPOSTCODE>NULL</ZBANKPOSTCODE><ZBANKCOUNTRY>NULL</ZBANKCOUNTRY><ZBANKCOMMENT>NULL</ZBANKCOMMENT></BANK><INTER_BANK><ZSWIFT>NULL</ZSWIFT><ZROUTING>NULL</ZROUTING><ZSORTCODE>NULL</ZSORTCODE><ZBANKNAME>NULL</ZBANKNAME><ZBANKADDR01>NULL</ZBANKADDR01><ZBANKADDR02>NULL</ZBANKADDR02><ZBANKCITY>NULL</ZBANKCITY><ZBANKREGION>NULL</ZBANKREGION><ZBANKPOSTCODE>NULL</ZBANKPOSTCODE><ZBANKCOUNTRY>NULL</ZBANKCOUNTRY></INTER_BANK><ZCHECKSUM>NULL</ZCHECKSUM><ZGLOBALMSG><TYPE>I</TYPE><ID>ZW</ID><NUMBER>028</NUMBER><MESSAGE>Bank details ignored for payment method.</MESSAGE></ZGLOBALMSG><ZGLOBALMSG><TYPE>S</TYPE><ID>ZW</ID><NUMBER>016</NUMBER><MESSAGE>Your profile TEST-1273603453 was recorded successfully.</MESSAGE></ZGLOBALMSG></n0:VENDOR_MAINTENANCE></SOAP:Body></SOAP:Envelope>
