package DR::SAP::Data::AbstractBank;
BEGIN {
  $DR::SAP::Data::AbstractBank::VERSION = '0.15';
}
BEGIN {
  $DR::SAP::Data::AbstractBank::VERSION = '0.15';
}

# ABSTRACT: Abstract base class (role) for bank master data in SAP.

use Moose;
use MooseX::Types::Moose qw(Maybe);
use namespace::autoclean;
use DR::SAP::Meta::Trait::SOAP;
use DR::SAP::Meta::Types qw(Country Region);
use Carp qw(croak);
with 'DR::SAP::Meta::SOAPParams';


has swift => (
	traits    => ['SOAP'],
	is        => 'rw',
	required  => 0,
	soap_name => 'ZSWIFT',
);

has routing_number => (
	traits    => ['SOAP'],
	is        => 'rw',
	required  => 0,
	soap_name => 'ZROUTING',
);

has sort_code => (
	traits    => ['SOAP'],
	is        => 'rw',
	required  => 0,
	soap_name => 'ZSORTCODE',
);

has name => (
	traits    => ['SOAP'],
	is        => 'rw',
	required  => 1,
	soap_name => 'ZBANKNAME',
);

has address_1 => (
	traits    => ['SOAP'],
	is        => 'rw',
	required  => 1,
	soap_name => 'ZBANKADDR01',
);

has address_2 => (
	traits    => ['SOAP'],
	is        => 'rw',
	required  => 0,
	soap_name => 'ZBANKADDR02',
);

has city => (
	traits    => ['SOAP'],
	is        => 'rw',
	required  => 1,
	soap_name => 'ZBANKCITY',
);

has region => (
	traits    => ['SOAP'],
	is        => 'rw',
	required  => 1,
	isa       => Maybe[Region],
	soap_name => 'ZBANKREGION',
);

has postal_code => (
	traits    => ['SOAP'],
	is        => 'rw',
	required  => 1,
	soap_name => 'ZBANKPOSTCODE',
);

has country => (
	traits    => ['SOAP'],
	is        => 'rw',
	required  => 1,
	isa       => Maybe[Country],
	soap_name => 'ZBANKCOUNTRY',
);

sub BUILDARGS {
	my $class = shift;
	croak sprintf('%s is an abstract class.  Please use a concrete class instead', __PACKAGE__) if $class eq __PACKAGE__;
	return $class->SUPER::BUILDARGS(@_);
}

__PACKAGE__->meta->make_immutable;

1;

__END__
=pod

=head1 NAME

DR::SAP::Data::AbstractBank - Abstract base class (role) for bank master data in SAP.

=head1 VERSION

version 0.15

=head1 ATTRIBUTES

=head2 swift

=head2 routing_number

=head2 sort_code

=head2 name

=head2 address_1

=head2 address_2

=head2 city

=head2 region

=head2 postal_code

=head2 country

=head1 AUTHOR

  Brian Phillips <bphillips@digitalriver.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2010 by Digital River, Inc

All rights reserved.

=cut

