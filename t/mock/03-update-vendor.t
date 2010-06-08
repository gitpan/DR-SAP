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
	my $response = $sap->update_vendor(
		vendor => {
			main_contact     => 'Test Contact',
			vendor_name      => 'Test Vendor',
			payment_mode     => 'automatic',
			platform_account => 'TEST-1273757568',
			account_group    => 'vendor',
			currency         => 'USD',
			street_address   => '123',
			city             => 'Test City',
			postal_code      => '12345',
			country          => 'US',
			payment_method   => 'F',
			platform_id      => 'RW',
			email            => 'foo@bar.com',
			primary_bank => {
				name => 'Foo',
				account_holder => 'Account Holder',
				account_number => 12345,
				routing_number => '071000013',
				address_1 => '123',
				city => 'Eden Prairie',
				region => 'MN',
				postal_code => '55123',
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
<SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/"><SOAP-ENV:Body><p2:VENDOR_MAINTENANCE xmlns:p2="http://itasca.digitalriver.com/ECC/VendorMaintenance"><ZTRANSTYPE>U</ZTRANSTYPE><ZPLATFORMID>RW</ZPLATFORMID><ZPLATFORMACCT>TEST-1273757568</ZPLATFORMACCT><ZACCOUNTGROUP>ZCLN</ZACCOUNTGROUP><ZCOMPCODE></ZCOMPCODE><ZPURCHORG>1000</ZPURCHORG><ZVENDORNAME>Test Vendor</ZVENDORNAME><ZSTREET>123</ZSTREET><ZCITY>Test City</ZCITY><ZCOUNTRY>US</ZCOUNTRY><ZPOSTALCODE>12345</ZPOSTALCODE><ZPAYMODE>AUTO</ZPAYMODE><ZMAINCONTACT>Test Contact</ZMAINCONTACT><ZMAINEMAIL>foo@bar.com</ZMAINEMAIL><ZPAYCURR>USD</ZPAYCURR><ZPAYMETHOD>F</ZPAYMETHOD><ZSKIPCHKRUN> </ZSKIPCHKRUN><BANK><ZBANKACCTHOLDER>Account Holder</ZBANKACCTHOLDER><ZACCTNUM>12345</ZACCTNUM><ZROUTING>071000013</ZROUTING><ZBANKNAME>Foo</ZBANKNAME><ZBANKADDR01>123</ZBANKADDR01><ZBANKCITY>Eden Prairie</ZBANKCITY><ZBANKREGION>MN</ZBANKREGION><ZBANKPOSTCODE>55123</ZBANKPOSTCODE><ZBANKCOUNTRY>US</ZBANKCOUNTRY></BANK></p2:VENDOR_MAINTENANCE></SOAP-ENV:Body></SOAP-ENV:Envelope>
# default: RESPONSE
<SOAP:Envelope xmlns:SOAP='http://schemas.xmlsoap.org/soap/envelope/'><SOAP:Header/><SOAP:Body><n0:VENDOR_MAINTENANCE xmlns:n0='http://itasca.digitalriver.com/ECC/VendorMaintenance' xmlns:prx='urn:sap.com:proxy:HCD:/1SAI/TASFEB69AE3BBDD387C7F03:700:2008/06/25'><ZTRANSTYPE>U</ZTRANSTYPE><ZPLATFORMID>RW</ZPLATFORMID><ZPLATFORMACCT>TEST-1273757568</ZPLATFORMACCT><ZACCOUNTGROUP>ZCLN</ZACCOUNTGROUP><ZCOMPCODE>1220</ZCOMPCODE><ZPURCHORG>1000</ZPURCHORG><ZVENDORNAME>Test Vendor</ZVENDORNAME><ZSTREET>123</ZSTREET><ZOTHERADDR01>NULL</ZOTHERADDR01><ZPOBOX>NULL</ZPOBOX><ZCITY>Test City</ZCITY><ZCOUNTRY>US</ZCOUNTRY><ZREGION>NULL</ZREGION><ZPOSTALCODE>12345</ZPOSTALCODE><ZVATREG>NULL</ZVATREG><ZTIN>NULL</ZTIN><ZWEBURL>NULL</ZWEBURL><ZPAYTHRESHOLD>NULL</ZPAYTHRESHOLD><ZPRINTLOGO>NULL</ZPRINTLOGO><ZPAYMODE>AUTO</ZPAYMODE><ZMAINCONTACT>Test Contact</ZMAINCONTACT><ZMAINEMAIL>foo@bar.com</ZMAINEMAIL><ZBIZCONTACT>NULL</ZBIZCONTACT><ZSALESCONTACT>NULL</ZSALESCONTACT><ZKEYGENCONTACT>NULL</ZKEYGENCONTACT><ZPAYCONTACT>NULL</ZPAYCONTACT><ZREMITCONTACT>NULL</ZREMITCONTACT><ZPHONE>NULL</ZPHONE><ZFAX>NULL</ZFAX><ZPAYCURR>USD</ZPAYCURR><ZSETTLEMENTCURRENCY>NULL</ZSETTLEMENTCURRENCY><ZPAYMETHOD>F</ZPAYMETHOD><ZPAYTERMS>0013</ZPAYTERMS><ZEPASSPORT_WEBMONEY>NULL</ZEPASSPORT_WEBMONEY><ZSKIPCHKRUN>NULL</ZSKIPCHKRUN><BANK><ZBANKACCTHOLDER>Account Holder</ZBANKACCTHOLDER><ZIBAN>NULL</ZIBAN><ZACCTNUM>12345</ZACCTNUM><ZSWIFT>NULL</ZSWIFT><ZROUTING>071000013</ZROUTING><ZSORTCODE>NULL</ZSORTCODE><ZBANKNAME>Foo</ZBANKNAME><ZBANKADDR01>123</ZBANKADDR01><ZBANKADDR02>NULL</ZBANKADDR02><ZBANKCITY>Eden Prairie</ZBANKCITY><ZBANKREGION>MN</ZBANKREGION><ZBANKPOSTCODE>55123</ZBANKPOSTCODE><ZBANKCOUNTRY>US</ZBANKCOUNTRY><ZBANKCOMMENT>NULL</ZBANKCOMMENT></BANK><INTER_BANK><ZSWIFT>NULL</ZSWIFT><ZROUTING>NULL</ZROUTING><ZSORTCODE>NULL</ZSORTCODE><ZBANKNAME>NULL</ZBANKNAME><ZBANKADDR01>NULL</ZBANKADDR01><ZBANKADDR02>NULL</ZBANKADDR02><ZBANKCITY>NULL</ZBANKCITY><ZBANKREGION>NULL</ZBANKREGION><ZBANKPOSTCODE>NULL</ZBANKPOSTCODE><ZBANKCOUNTRY>NULL</ZBANKCOUNTRY></INTER_BANK><ZCHECKSUM>NULL</ZCHECKSUM><ZGLOBALMSG><TYPE>E</TYPE><ID>F2</ID><NUMBER>164</NUMBER><MESSAGE>Vendor 13653007 has not been created for company code 1220</MESSAGE><MESSAGE_V1>13653007</MESSAGE_V1><MESSAGE_V2>1220</MESSAGE_V2><ROW>1</ROW><SYSTEM>HCDCLNT300</SYSTEM></ZGLOBALMSG></n0:VENDOR_MAINTENANCE></SOAP:Body></SOAP:Envelope>

