package DR::SAP::Operation::RetrieveOpenItems;
BEGIN {
  $DR::SAP::Operation::RetrieveOpenItems::VERSION = '0.15';
}
BEGIN {
  $DR::SAP::Operation::RetrieveOpenItems::VERSION = '0.15';
}

# ABSTRACT: Operation for retrieving pending transfers

use Moose;
use namespace::autoclean;
use DR::SAP::WSDL::OpenItems;
use DR::SAP::Meta::Types qw(PlatformID);
extends 'DR::SAP::Operation';
with 'DR::SAP::Meta::SOAPParams';

sub _build_wsdl {
	return DR::SAP::WSDL::OpenItems->instance;
}

has platform_id => (
	traits   => ['SOAP'],
	is       => 'ro',
	isa      => PlatformID,
	required => 1,
	soap_name => 'ZPLATFORMID',
);
has platform_account => (
	traits   => ['SOAP'],
	is       => 'rw',
	required => 1,
	soap_name => 'ZPLATFORMACCT',
);


use constant name => 'ThirdParyOpenItems_OUT';

around to_SOAP => sub {
	my $orig = shift;
	my $self = shift;
	my $soap_data = $self->$orig(@_);
	return { ZFII0003_TP_OPENITEMS => $soap_data };
};

__PACKAGE__->meta->make_immutable;

1;

package DR::SAP::Operation::RetrieveOpenItems::response;
BEGIN {
  $DR::SAP::Operation::RetrieveOpenItems::response::VERSION = '0.15';
}
BEGIN {
  $DR::SAP::Operation::RetrieveOpenItems::response::VERSION = '0.15';
}

# ABSTRACT: Represents a response from the OpenItems SOAP operation
use Moose;
use MooseX::Types::Moose qw(Num);
use DR::SAP::Meta::Types qw(Currency PlatformID);
extends 'DR::SAP::Response';
with( 'DR::SAP::Response::WithMessages' => { soap_name => 'ZINIT_VALIDATION_ERR' }, 'DR::SAP::Meta::SOAPParams' );
use constant response_data_key => 'ZFII0003_TP_OPENITEMS';

has platform_id => (
	traits   => ['SOAP'],
	is       => 'ro',
	isa      => PlatformID,
	required => 1,
	soap_name => 'ZPLATFORMID',
);
has platform_account => (
	traits   => ['SOAP'],
	is       => 'ro',
	required => 1,
	soap_name => 'ZPLATFORMACCT',
);
has transaction_key => (
	traits   => ['SOAP'],
	is       => 'ro',
	required => 1,
	soap_name => 'ZTRANKEY',
);
has account_number => (
	traits   => ['SOAP'],
	is       => 'ro',
	required => 1,
	soap_name => 'ZACCTNUM',
);
has amount => (
	traits   => ['SOAP'],
	is       => 'ro',
	required => 1,
	soap_name => 'ZAMOUNT',
);
has currency => (
	traits   => ['SOAP'],
	is       => 'ro',
	required => 1,
	soap_name => 'ZCURRKEY',
);
has due_date => (
	traits   => ['SOAP'],
	is       => 'ro',
	required => 1,
	soap_name => 'ZBASELINE_DATE',
);
has text => (
	traits   => ['SOAP'],
	is       => 'ro',
	required => 1,
	soap_name => 'ZTEXT',
);

1;

__END__
=pod

=head1 NAME

DR::SAP::Operation::RetrieveOpenItems - Operation for retrieving pending transfers

=head1 VERSION

version 0.15

=head1 METHODS

=head2 name

Returns the SOAP name for this operation.

=head1 AUTHOR

  Brian Phillips <bphillips@digitalriver.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2010 by Digital River, Inc

All rights reserved.

=cut

