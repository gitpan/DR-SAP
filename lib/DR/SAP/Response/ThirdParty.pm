package DR::SAP::Response::ThirdParty;
BEGIN {
  $DR::SAP::Response::ThirdParty::VERSION = '0.15';
}
BEGIN {
  $DR::SAP::Response::ThirdParty::VERSION = '0.15';
}

# ABSTRACT: Represents a response from the third-party management SOAP operations
use Moose;
use MooseX::Types::Moose qw(ArrayRef);
extends 'DR::SAP::Response';
with( 'DR::SAP::Response::WithMessages', 'DR::SAP::Meta::SOAPParams' );
use constant response_data_key => 'TP_VENDOR_MAINTENANCE';



has third_parties => (
	traits    => ['Array','SOAP'],
	is        => 'ro',
	isa       => ArrayRef['DR::SAP::Data::ThirdParty'],
	required  => 1,
	soap_name => 'VENDOR',
	from_SOAP => sub { [map { DR::SAP::Data::ThirdParty->from_SOAP($_) } @$_] },
	handles => {
		all_third_parties => 'elements',
	}
);

1;

__END__
=pod

=head1 NAME

DR::SAP::Response::ThirdParty - Represents a response from the third-party management SOAP operations

=head1 VERSION

version 0.15

=head1 ATTRIBUTES

=head2 third_parties

An ArrayRef of all third-parties for this vendor

=head1 METHODS

=head2 all_third_parties

=head1 AUTHOR

  Brian Phillips <bphillips@digitalriver.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2010 by Digital River, Inc

All rights reserved.

=cut

