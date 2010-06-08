package DR::SAP::Operation::ThirdParty::Manage;
BEGIN {
  $DR::SAP::Operation::ThirdParty::Manage::VERSION = '0.15';
}
BEGIN {
  $DR::SAP::Operation::ThirdParty::Manage::VERSION = '0.15';
}

# ABSTRACT: Base class for operations managing third-party vendors in SAP

use Moose;
use DR::SAP::Meta::Trait::SOAP;
use DR::SAP::Meta::Types qw(PlatformID);
use MooseX::Types::Moose qw(Str HashRef);
use namespace::autoclean;
use Moose::Util::TypeConstraints;
use DR::SAP::Data::ThirdParty;
use DR::SAP::Data::Message;
use DR::SAP::WSDL::ThirdPartyVendor;
use DR::SAP::Response::ThirdParty;

extends 'DR::SAP::Operation';
sub _build_wsdl {
	return DR::SAP::WSDL::ThirdPartyVendor->instance;
}
with 'DR::SAP::Meta::SOAPParams';

has vendor => (
	is       => 'ro',
	does     => 'DR::SAP::Data::AccountLookupFields',
	required => 1,
	coerce   => 1,
	handles  => {
		_build__platform_id      => 'platform_id',
		_build__platform_account => 'platform_account',
	},
	trigger => sub { my $s = shift; $s->_platform_id; $s->_platform_account }
);

has _platform_id => (
	traits   => ['SOAP'],
	is       => 'ro',
	isa      => PlatformID,
	lazy_build => 1,
	soap_name => 'ZPLATFORMID',
);

has _platform_account => (
	traits   => ['SOAP'],
	is       => 'rw',
	lazy_build => 1,
	soap_name => 'ZPLATFORMACCT',
);

class_type('DR::SAP::Data::ThirdParty');
class_type('DR::SAP::Data::Vendor');
coerce 'DR::SAP::Data::ThirdParty', from HashRef, via { DR::SAP::Data::ThirdParty->new($_) };
coerce 'DR::SAP::Data::ThirdParty', from 'DR::SAP::Data::Vendor', via {
	DR::SAP::Data::ThirdParty->new( %$_, third_party_id => $_->platform_account );
};

has third_party => (
	traits   => ['SOAP'],
	is       => 'rw',
	isa      => 'DR::SAP::Data::ThirdParty',
	coerce   => 1,
	soap_name => 'VENDOR',
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
	isa      => Str,
	soap_name => 'ZCHECKSUM',
);


use constant name => 'ThirdPartyVendorMaintain_OUT';


sub BUILD {
	my $self = shift;
	die "transaction_type must be set" unless $self->_transaction_type;
}

around to_SOAP => sub {
	my $orig = shift;
	my $self = shift;
	return { TP_VENDOR_MAINTENANCE => $self->$orig(@_) };
};

__PACKAGE__->meta->make_immutable;



sub response_class {
	return 'DR::SAP::Response::ThirdParty';
}

1;

__END__
=pod

=head1 NAME

DR::SAP::Operation::ThirdParty::Manage - Base class for operations managing third-party vendors in SAP

=head1 VERSION

version 0.15

=head1 ATTRIBUTES

=head2 third_party

See L<DR::SAP::Data::ThirdParty>.  Will coerce from HashRef or L<DR::SAP::Data::Vendor>.

=head2 checksum

=head1 METHODS

=head2 name

Returns the SOAP name for these operations.

=head2 BUILD

Dies if the sub-class has not defined a _transaction_type attribute.

=head2 response_class

Specifies the response_class for these operations.

=head1 AUTHOR

  Brian Phillips <bphillips@digitalriver.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2010 by Digital River, Inc

All rights reserved.

=cut

