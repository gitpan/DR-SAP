package DR::SAP::Operation::TransferFunds;
BEGIN {
  $DR::SAP::Operation::TransferFunds::VERSION = '0.15';
}
BEGIN {
  $DR::SAP::Operation::TransferFunds::VERSION = '0.15';
}

# ABSTRACT: Operation for transferring funds between one account and another in SAP

use Moose;
use MooseX::Types::Moose qw(Num Str);
use Moose::Util::TypeConstraints;
use namespace::autoclean;
use DR::SAP::WSDL::BalanceCheck;
use DR::SAP::Meta::Types qw(PlatformID Currency);
extends 'DR::SAP::Operation';
with 'DR::SAP::Meta::SOAPParams';

sub _build_wsdl {
	return DR::SAP::WSDL::FundsTransfer->instance;
}
has platform_id => (
	traits   => ['SOAP'],
	is       => 'ro',
	isa      => PlatformID,
	required => 1,
	soap_name => 'ZPLATFORMID',
);
has from => (
	traits   => ['SOAP'],
	is       => 'rw',
	required => 1,
	soap_name => 'ZSENDERVENDOR',
);
has to => (
	traits   => ['SOAP'],
	is       => 'rw',
	required => 1,
	soap_name => 'ZRECEIVERVENDOR',
);
my $date = subtype Str, where { m/\d{4}(?:0[1-9]|1[0-2])(?:0[1-9]|1[0-9]|2[0-9]|3[01])/ }, message { "This value ($_) is not a date in YYYYMMDD format" };
has date => (
	traits   => ['SOAP'],
	is       => 'rw',
	required => 1,
	isa => $date,
	soap_name => 'ZDUE_DATE',
	default  => sub {
		my @d = localtime;
		return sprintf( '%04d%02d%02d', $d[5] + 1900, $d[4] + 1, $d[3] );
	}
);
has amount => (
	traits   => ['SOAP'],
	is       => 'rw',
	isa => Num,
	required => 1,
	soap_name => 'ZAMOUNT',
);

has currency => (
	traits   => ['SOAP'],
	is       => 'ro',
	isa      => Currency,
	required => 1,
	soap_name => 'ZCURRKEY'
);

has text => (
	traits    => ['SOAP'],
	is        => 'ro',
	soap_name => 'ZTEXT'
);


has aggr_value => (
	traits    => ['SOAP'],
	is        => 'ro',
	soap_name => 'ZAGGR_VALUE'
);


use constant name => 'FundsTransfer_OUT';

around to_SOAP => sub {
	my $orig = shift;
	my $self = shift;
	my $soap_data = $self->$orig(@_);
	return { ZFII0002_FUNDS_TRANSFER => $soap_data };
};

__PACKAGE__->meta->make_immutable;

1;

package DR::SAP::Operation::TransferFunds::response;
BEGIN {
  $DR::SAP::Operation::TransferFunds::response::VERSION = '0.15';
}
BEGIN {
  $DR::SAP::Operation::TransferFunds::response::VERSION = '0.15';
}

# ABSTRACT: Represents a response from the TransferFunds SOAP operation
use Moose;
use MooseX::Types::Moose qw(Num);
use DR::SAP::Meta::Types qw(Currency);
extends 'DR::SAP::Response';
with('DR::SAP::Response::WithMessages','DR::SAP::Meta::SOAPParams');
use constant response_data_key => 'ZFII0002_FUNDS_TRANSFER';


has amount => (
	traits    => ['SOAP'],
	is        => 'ro',
	isa       => Num,
	required  => 1,
	soap_name => 'ZAMOUNT'
);


has currency => (
	traits    => ['SOAP'],
	is        => 'ro',
	isa       => Currency,
	required  => 1,
	soap_name => 'ZCURRKEY',
);

1;

__END__
=pod

=head1 NAME

DR::SAP::Operation::TransferFunds - Operation for transferring funds between one account and another in SAP

=head1 VERSION

version 0.15

=head1 ATTRIBUTES

=head2 platform_id
See L<DR::SAP::Meta:Types> for allowed platform IDs.

=head2 from

=head2 to

=head2 date
The earliest date the transfer should be completed.

=head2 amount
The amount of the transfer.

=head2 currency
Currency of amount to be transferred.

=head2 text
No clue...

=head2 aggr_value
No clue...

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

