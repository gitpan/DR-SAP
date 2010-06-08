use strict;
use warnings;
use Test::More qw(no_plan);
use XML::Compile::SOAP::Trace;

BEGIN { use_ok 'DR::SAP::Operation::Vendor::Create' };
use DR::SAP::Data::Vendor;

my $v = DR::SAP::Data::Vendor->new(
	vendor_name      => 'Test Vendor',
	payment_mode     => 'automatic',
	platform_account => 'v1234',
	account_group    => 'vendor',
	currency         => 'USD',
	street_address   => '123',
	other_address    => 'NULL',
	city             => '123',
	email            => 'foo@bar.com',
	country          => 'US',
	main_contact     => 'Hi',
	postal_code      => '123',
	payment_method   => 'C',
	platform_id      => 'RW',
	primary_bank     => DR::SAP::Data::PrimaryBank->new(
		account_holder => 'Test',
		address_1      => 'test',
		city           => 'NULL',
		postal_code    => 'test',
		name           => 'test',
		region         => 'MN',
		country        => 'US',
	),
	intermediary_bank => DR::SAP::Data::IntermediaryBank->new(
		address_1   => 'test',
		address_2   => 'NULL',
		city        => 'test',
		postal_code => 'test',
		name        => 'test',
		region      => 'MN',
		country     => 'US',
	),
);
my $op = DR::SAP::Operation::Vendor::Create->new(vendor => $v, checksum => 123);
isa_ok($op, 'DR::SAP::Operation::Vendor::Create', 'operation');
ok($op->wsdl->does('DR::SAP::WSDL'), 'wsdl does DR::SAP::WSDL');
is($op->to_SOAP->{VENDOR_MAINTENANCE}->{ZTRANSTYPE}, 'C', 'transaction_type is placed correctly');
is($op->to_SOAP->{VENDOR_MAINTENANCE}->{ZCHECKSUM}, '123', 'checksum is placed correctly');

is($op->name, 'VendorCreate_OUT', 'operation name');
my $res = $op->build_response(
	trace        => XML::Compile::SOAP::Trace->new( {} ),
	raw_response => $op->to_SOAP
);
isa_ok($res, 'DR::SAP::Response', '$response');
isa_ok($res->vendor, 'DR::SAP::Data::Vendor', '$res->vendor');
is($res->vendor->street_address, '123', '$vendor->street_address');
is($res->vendor->other_address, undef, '$vendor->other_address');
isa_ok($res->vendor->primary_bank, 'DR::SAP::Data::PrimaryBank', '$vendor->primary_bank');
is($res->vendor->primary_bank->city, undef, '$vendor->primary_bank->city');
isa_ok($res->vendor->intermediary_bank, 'DR::SAP::Data::IntermediaryBank', '$vendor->intermediary_bank');

#diag explain $res;
