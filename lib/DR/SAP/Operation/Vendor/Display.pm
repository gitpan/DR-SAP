package DR::SAP::Operation::Vendor::Display;
BEGIN {
  $DR::SAP::Operation::Vendor::Display::VERSION = '0.15';
}
BEGIN {
  $DR::SAP::Operation::Vendor::Display::VERSION = '0.15';
}

# ABSTRACT: Operation for retrieving vendor information from SAP

use Moose;
use namespace::autoclean;
use DR::SAP::Meta::Types qw(PlatformID);
use DR::SAP::Meta::Trait::SOAP;
use DR::SAP::WSDL::VendorMaintenance;
use Moose::Util::TypeConstraints;
use DR::SAP::Response::Vendor;

use constant name => 'VendorCreate_OUT';

extends 'DR::SAP::Operation';
with( 'DR::SAP::Meta::SOAPParams', 'DR::SAP::Data::AccountLookupFields' );

sub _build_wsdl {
	return DR::SAP::WSDL::VendorMaintenance->instance;
}

has _transaction_type => (
	traits   => ['SOAP'],
	is       => 'ro',
	init_arg => undef,
	default => 'D',
	soap_name => 'ZTRANSTYPE',
);

has '+account_group' => ( default => 'vendor' );

around to_SOAP => sub {
	my $orig = shift;
	my $self = shift;
	my $soap_data = $self->$orig(@_);
	return { VENDOR_MAINTENANCE => $soap_data };
};

sub response_class {
	return 'DR::SAP::Response::Vendor';
}

__PACKAGE__->meta->make_immutable;

1;

__END__
=pod

=head1 NAME

DR::SAP::Operation::Vendor::Display - Operation for retrieving vendor information from SAP

=head1 VERSION

version 0.15

=head1 AUTHOR

  Brian Phillips <bphillips@digitalriver.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2010 by Digital River, Inc

All rights reserved.

=cut

