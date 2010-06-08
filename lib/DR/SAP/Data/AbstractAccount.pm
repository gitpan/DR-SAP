package DR::SAP::Data::AbstractAccount;
BEGIN {
  $DR::SAP::Data::AbstractAccount::VERSION = '0.15';
}
BEGIN {
  $DR::SAP::Data::AbstractAccount::VERSION = '0.15';
}

# ABSTRACT: Abstract base class (role) that represents an account in SAP

use Moose::Role;
use Carp qw(croak);
use namespace::autoclean;
use MooseX::Types::Moose qw(Str Bool HashRef Maybe);
use Moose::Util::TypeConstraints;

use DR::SAP::Meta::Trait::SOAP;
use DR::SAP::Meta::Types qw(PlatformID Region Country PaymentTerms PaymentMethod);
use DR::SAP::Data::PrimaryBank;
use DR::SAP::Data::IntermediaryBank;


has street_address => (
	traits   => ['SOAP'],
	is       => 'rw',
	required => 1,
	soap_name => 'ZSTREET',
);

has other_address => (
	traits   => ['SOAP'],
	is       => 'rw',
	soap_name => 'ZOTHERADDR01',
);

has po_box => (
	traits   => ['SOAP'],
	is       => 'rw',
	soap_name => 'ZPOBOX',
);

has city => (
	traits   => ['SOAP'],
	is       => 'rw',
	required => 1,
	soap_name => 'ZCITY',
);

has country => (
	traits   => ['SOAP'],
	is       => 'rw',
	isa      => Maybe[Country],
	required => 1,
	soap_name => 'ZCOUNTRY',
);

has region => (
	traits   => ['SOAP'],
	is       => 'rw',
	isa      => Maybe[Region],
	soap_name => 'ZREGION',
);

has postal_code => (
	traits   => ['SOAP'],
	is       => 'rw',
	required => 1,
	soap_name => 'ZPOSTALCODE',
);

has email => (
	traits   => ['SOAP'],
	is       => 'rw',
	required => 1,
	soap_name => 'ZMAINEMAIL',
);

has payable_contact_name => (
	traits   => ['SOAP'],
	is       => 'rw',
	soap_name => 'ZPAYCONTACT',
);

has currency => (
	traits   => ['SOAP'],
	is       => 'rw',
	required => 1,
	soap_name => 'ZPAYCURR'
);

has payment_method => (
	traits    => ['SOAP'],
	is        => 'rw',
	isa       => PaymentMethod,
	required  => 1,
	soap_name => 'ZPAYMETHOD',
	from_SOAP => sub { m/[GHJKVW]/ ? 0 : $_ } # SAP returns specific wire types, we'll translate to the generic one
);


has payment_terms => (
	traits   => ['SOAP'],
	is       => 'rw',
	soap_name => 'ZPAYTERMS',
	isa => Maybe[PaymentTerms],
);


has skip_check_run => (
	traits    => ['SOAP'],
	is        => 'rw',
	isa       => Bool,
	required  => 1,
	default   => 0,
	soap_name => 'ZSKIPCHKRUN',
	from_SOAP => sub { return lc($_) eq '*' },
	to_SOAP   => sub { return $_ ? '*' : ' ' },
);

my $bank = Maybe['DR::SAP::Data::PrimaryBank'];
coerce $bank, from HashRef, via { DR::SAP::Data::PrimaryBank->new($_) };
has primary_bank => (
	traits    => ['SOAP'],
	is        => 'rw',
	isa       => $bank,
	coerce    => 1,
	soap_name => 'BANK',
	from_SOAP => sub { return DR::SAP::Data::PrimaryBank->from_SOAP(ref $_ eq 'ARRAY' ? $_->[0] : $_) }
);

my $int_bank = Maybe['DR::SAP::Data::IntermediaryBank'];
coerce $int_bank, from HashRef, via { DR::SAP::Data::IntermediaryBank->new($_) };
has intermediary_bank => (
	traits    => ['SOAP'],
	is        => 'rw',
	isa       => $int_bank,
	coerce    => 1,
	soap_name => 'INTER_BANK',
	from_SOAP => sub { return DR::SAP::Data::IntermediaryBank->from_SOAP(ref($_) eq 'ARRAY' ? $_->[0] : $_) }
);


has tax_id => (
	traits   => ['SOAP'],
	is       => 'rw',
	soap_name => 'ZTIN',
);


has payment_threshold => (
	traits   => ['SOAP'],
	is       => 'rw',
	soap_name => 'ZPAYTHRESHOLD',
);

1;

__END__
=pod

=head1 NAME

DR::SAP::Data::AbstractAccount - Abstract base class (role) that represents an account in SAP

=head1 VERSION

version 0.15

=head1 ATTRIBUTES

=head2 street_address

Required.

=head2 other_address

=head2 po_box

=head2 city

Required.

=head2 country

Required.

=head2 region

=head2 postal_code

Required.

=head2 email

Required.

=head2 payable_contact_name

SAP will look in this field for the PayPal e-mail address if the payment method is "P" (PayPal).

=head2 currency

Required.

=head2 payment_method

Required.  See L<DR::SAP::Meta::Types> for allowable values.

=head2 payment_terms

See L<DR::SAP::Meta::Types> for allowable values.

=head2 skip_check_run

Indicates that SAP should not generate any payments for this client.

=head2 primary_bank

See L<DR::SAP::Data::PrimaryBank>.  Will coerce from a HashRef.

=head2 intermediary_bank

See L<DR::SAP::Data::IntermediaryBank>.  Will coerce from a HashRef.

=head2 tax_id

Tax ID

=head2 payment_threshold

Minimum payment threshhold.

=head1 AUTHOR

  Brian Phillips <bphillips@digitalriver.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2010 by Digital River, Inc

All rights reserved.

=cut

