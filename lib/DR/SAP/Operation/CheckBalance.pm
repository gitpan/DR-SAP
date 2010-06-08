package DR::SAP::Operation::CheckBalance;
BEGIN {
  $DR::SAP::Operation::CheckBalance::VERSION = '0.15';
}
BEGIN {
  $DR::SAP::Operation::CheckBalance::VERSION = '0.15';
}

# ABSTRACT: Operation for retrieving a vendor's balance from SAP.

use Moose;
use namespace::autoclean;
use DR::SAP::WSDL::BalanceCheck;
use DR::SAP::Meta::Types qw(PlatformID);
extends 'DR::SAP::Operation';
with 'DR::SAP::Meta::SOAPParams';

sub _build_wsdl {
	return DR::SAP::WSDL::BalanceCheck->instance;
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


use constant name => 'BalanceCheck_OUT';

around to_SOAP => sub {
	my $orig = shift;
	my $self = shift;
	my $soap_data = $self->$orig(@_);
	return { ZFII0001_BALANCE_CHECK => $soap_data };
};

__PACKAGE__->meta->make_immutable;

1;

package DR::SAP::Operation::CheckBalance::response;
BEGIN {
  $DR::SAP::Operation::CheckBalance::response::VERSION = '0.15';
}
BEGIN {
  $DR::SAP::Operation::CheckBalance::response::VERSION = '0.15';
}

# ABSTRACT: Represents a response from the CheckBalance SOAP operation
use Moose;
use Moose::Util::TypeConstraints;
use MooseX::Types::Moose qw(Num);
use DR::SAP::Meta::Types qw(Currency);
extends 'DR::SAP::Response';
with('DR::SAP::Response::WithMessages' => {
	soap_name => 'ZINIT_VALIDATION_ERR'
},'DR::SAP::Meta::SOAPParams');
use constant response_data_key => 'ZFII0001_BALANCE_CHECK';

my $my_num = subtype as Num;
coerce $my_num, from class_type('Math::BigFloat'), via { "$_" };
has balance => (
	traits    => ['SOAP'],
	is        => 'ro',
	isa       => $my_num,
	required  => 1,
	soap_name => 'ZBALANCE',
	coerce    => 1,
	default   => 0,
	from_SOAP => sub { $_ * -1 }, # SAP returns an inverted number
);


has currency => (
	traits    => ['SOAP'],
	is        => 'ro',
	isa       => Currency,
	required  => 1,
	soap_name => 'ZCURRKEY',
	default   => 'USD',
);

1;

__END__
=pod

=head1 NAME

DR::SAP::Operation::CheckBalance - Operation for retrieving a vendor's balance from SAP.

=head1 VERSION

version 0.15

=head1 ATTRIBUTES

=head2 balance

=head2 currency

=head1 METHODS

=head2 name

Returns the SOAP name for this operation.

=head1 AUTHOR

  Brian Phillips <bphillips@digitalriver.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2010 by Digital River, Inc

All rights reserved.

=cut

