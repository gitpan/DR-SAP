use strict;
use warnings;
use Test::More tests => 9;
use DR::SAP::Data::Vendor;

my $v = DR::SAP::Data::Vendor->new(
	vendor_name      => 'Test Vendor',
	payment_mode     => 'automatic',
	platform_account => 'v1234',
	account_group    => 'vendor',
	currency         => 'USD',
	street_address   => '123',
	city             => '123',
	country          => 'US',
	postal_code      => '123',
	payment_method   => 'C',
	platform_id      => 'RW',
	email            => 'foo@bar.com',
	main_contact     => 'Hi',
	primary_bank     => {
		account_holder => 'Test',
		address_1      => 'test',
		city           => 'test',
		postal_code    => 'test',
		name           => 'test',
		region         => 'MN',
		country        => 'US',
	},
	intermediary_bank => {
		address_1   => 'test',
		city        => 'test',
		postal_code => 'test',
		name        => 'test',
		region      => 'MN',
		country     => 'US',
	},
);
isa_ok( $v, 'DR::SAP::Data::Vendor' );
diag explain $v->to_SOAP;
is( $v->to_SOAP->{ZACCOUNTGROUP}, 'ZCLN', 'account_group translated' );
is( $v->to_SOAP->{ZPAYMODE}, 'AUTO', 'payment_mode translated' );
isa_ok($v->to_SOAP->{BANK}, 'HASH', 'primary_bank');
isa_ok($v->to_SOAP->{INTER_BANK}, 'HASH', 'intermediary_bank');
isa_ok($v->primary_bank, 'DR::SAP::Data::PrimaryBank', 'primary_bank coerced from HashRef');
isa_ok($v->intermediary_bank, 'DR::SAP::Data::IntermediaryBank', 'intermediary_bank coerced from HashRef');
is($v->intermediary_bank->region, 'MN', 'pre-SOAP intermediary bank region');
is($v->to_SOAP->{INTER_BANK}->{ZBANKREGION}, 'MN', 'intermediary bank region') or diag explain $v->to_SOAP;
