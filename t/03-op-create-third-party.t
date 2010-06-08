use strict;
use warnings;
use Test::More qw(no_plan);
use XML::Compile::SOAP::Trace;

BEGIN { use_ok 'DR::SAP::Operation::ThirdParty::Create' };
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
my $op = DR::SAP::Operation::ThirdParty::Create->new(vendor => $v, third_party => $v);
#diag explain $op->to_SOAP;
