package DR::SAP::Data::Vendor;
BEGIN {
  $DR::SAP::Data::Vendor::VERSION = '0.15';
}
BEGIN {
  $DR::SAP::Data::Vendor::VERSION = '0.15';
}

# ABSTRACT: Client-side proxy object for an SAP Vendor account

use Moose;
use MooseX::Types::Moose qw(Str Bool HashRef);
use Moose::Util::TypeConstraints;
use namespace::autoclean;
use DR::SAP::Meta::Trait::SOAP;
use DR::SAP::Data::PrimaryBank;
use DR::SAP::Data::IntermediaryBank;
use DR::SAP::Meta::Types qw(PlatformID);
with( 'DR::SAP::Meta::SOAPParams', 'DR::SAP::Data::AbstractAccount', 'DR::SAP::Data::AccountLookupFields' );


has vendor_name => (
	traits   => ['SOAP'],
	is       => 'rw',
	required => 1,
	soap_name => 'ZVENDORNAME',
);


has vat_registration => (
	traits   => ['SOAP'],
	is       => 'rw',
	soap_name => 'ZVATREG',
);


has website_url => (
	traits   => ['SOAP'],
	is       => 'rw',
	soap_name => 'ZWEBURL',
);
my %payment_modes = (
	manual    => 'MANU',
	automatic => 'AUTO',
	immediate => 'IMME',
);
my %SAP_payment_modes = reverse %payment_modes;


has payment_mode => (
	traits    => ['SOAP'],
	isa       => enum( [ keys %payment_modes ] ),
	is        => 'rw',
	required  => 1,
	soap_name => 'ZPAYMODE',
	to_SOAP   => sub { $payment_modes{$_} },
	from_SOAP => sub { $SAP_payment_modes{$_} || "UNKNOWN: $_" },
);


has main_contact => (
	traits   => ['SOAP'],
	is       => 'rw',
	soap_name => 'ZMAINCONTACT',
	required  => 1,
);


has business_email => (
	traits   => ['SOAP'],
	is       => 'rw',
	soap_name => 'ZBIZCONTACT',
);


has sales_email => (
	traits   => ['SOAP'],
	is       => 'rw',
	soap_name => 'ZSALESCONTACT',
);


has keygen_failure_email => (
	traits   => ['SOAP'],
	is       => 'rw',
	soap_name => 'ZKEYGENCONTACT',
);


has remittance_email => (
	traits   => ['SOAP'],
	is       => 'rw',
	soap_name => 'ZREMITCONTACT'
);


has phone => (
	traits   => ['SOAP'],
	is       => 'rw',
	soap_name => 'ZPHONE'
);


has fax => (
	traits   => ['SOAP'],
	is       => 'rw',
	soap_name => 'ZFAX'
);


has webmoney_id => (
	traits   => ['SOAP'],
	is       => 'rw',
	soap_name => 'ZEPASSPORT_WEBMONEY'
);

__PACKAGE__->meta->make_immutable;

1;


__END__
=pod

=head1 NAME

DR::SAP::Data::Vendor - Client-side proxy object for an SAP Vendor account

=head1 VERSION

version 0.15

=head1 ATTRIBUTES

=head2 vendor_name

=head2 vat_registration

=head2 website_url

=head2 payment_mode

Allowed payment modes:

=over 4

=item *

manual

=item *

automatic

=item *

immediate

=back

=head2 main_contact

=head2 business_email

=head2 sales_email

=head2 keygen_failure_email

=head2 remittance_email

=head2 phone

=head2 fax

=head2 webmoney_id

=head1 SEE ALSO

=over 4

=item *

L<DR::SAP::Data::AbstractAccount>

=back

=head1 AUTHOR

  Brian Phillips <bphillips@digitalriver.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2010 by Digital River, Inc

All rights reserved.

=cut

