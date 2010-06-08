package DR::SAP::Operation::Vendor::Manage;
BEGIN {
  $DR::SAP::Operation::Vendor::Manage::VERSION = '0.15';
}
BEGIN {
  $DR::SAP::Operation::Vendor::Manage::VERSION = '0.15';
}

# ABSTRACT: Base class for all vendor operations

use Moose;
use DR::SAP::Meta::Trait::SOAP;
use MooseX::Types::Moose qw(Maybe Str HashRef);
use namespace::autoclean;
use Moose::Util::TypeConstraints;
use DR::SAP::Data::Vendor;
use DR::SAP::Data::Message;
use DR::SAP::WSDL::VendorMaintenance;
use DR::SAP::Response::Vendor;

extends 'DR::SAP::Operation';
sub _build_wsdl {
	return DR::SAP::WSDL::VendorMaintenance->instance;
}

with 'DR::SAP::Meta::SOAPParams';
class_type('DR::SAP::Data::Vendor');
coerce 'DR::SAP::Data::Vendor', from HashRef, via { DR::SAP::Data::Vendor->new($_) };


has vendor => (
	traits   => ['SOAP'],
	is       => 'ro',
	isa      => 'DR::SAP::Data::Vendor',
	coerce   => 1,
	soap_name => 'VENDOR_MAINTENANCE',
);

has _transaction_type => (
	traits   => ['SOAP'],
	is       => 'ro',
	isa      => enum([qw(C U D)]), # Create, Update, Display
	lazy_build => 1,
	init_arg => undef,
	soap_name => 'ZTRANSTYPE',
);


has checksum => (
	traits   => ['SOAP'],
	is       => 'ro',
	isa      => Maybe[Str],
	soap_name => 'ZCHECKSUM',
);

use constant name => 'VendorCreate_OUT';


sub BUILD {
	my $self = shift;
	die "_transaction_type must be set by sub-class" unless $self->_transaction_type;
}

around to_SOAP => sub {
	my $orig = shift;
	my $self = shift;
	my $soap_data = $self->$orig(@_);
	foreach my $k(qw(ZTRANSTYPE ZCHECKSUM)){
		$soap_data->{VENDOR_MAINTENANCE}->{$k} = delete $soap_data->{$k} if exists $soap_data->{$k};
	}
	return $soap_data;
};

__PACKAGE__->meta->make_immutable;


sub response_class {
	return 'DR::SAP::Response::Vendor';
}

1;

__END__
=pod

=head1 NAME

DR::SAP::Operation::Vendor::Manage - Base class for all vendor operations

=head1 VERSION

version 0.15

=head1 ATTRIBUTES

=head2 vendor

A L<DR::SAP::Data::Vendor> object.  A HashRef coercion is set up and additional coercions could be defined to allow platform domain objects to be passed in.

=head2 checksum

The checksum value that SAP may return when creating or updating a vendor.

=head1 METHODS

=head2 BUILD

Dies if _transaction_type is not set by sub-class.

=head1 AUTHOR

  Brian Phillips <bphillips@digitalriver.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2010 by Digital River, Inc

All rights reserved.

=cut

