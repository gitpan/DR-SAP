package DR::SAP::Response::Vendor;
BEGIN {
  $DR::SAP::Response::Vendor::VERSION = '0.15';
}
BEGIN {
  $DR::SAP::Response::Vendor::VERSION = '0.15';
}

# ABSTRACT: Response class for vendor management SOAP operations

use Moose;
use MooseX::Types::Moose qw(ArrayRef);
extends 'DR::SAP::Response';
with( 'DR::SAP::Response::WithMessages', 'DR::SAP::Response::WithBankingChecksum', 'DR::SAP::Meta::SOAPParams' );
use constant response_data_key => 'VENDOR_MAINTENANCE';


has vendor => (
	traits    => ['SOAP'],
	is        => 'ro',
	isa       => 'DR::SAP::Data::Vendor',
	soap_name => '',
	from_SOAP => sub { $_->{ZACCOUNTGROUP} && $_->{ZACCOUNTGROUP} ne 'NULL' ? DR::SAP::Data::Vendor->from_SOAP($_) : undef },
);

1;

__END__
=pod

=head1 NAME

DR::SAP::Response::Vendor - Response class for vendor management SOAP operations

=head1 VERSION

version 0.15

=head1 ATTRIBUTES

=head2 vendor

A L<DR::SAP::Data::Vendor> object.

=head1 AUTHOR

  Brian Phillips <bphillips@digitalriver.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2010 by Digital River, Inc

All rights reserved.

=cut

