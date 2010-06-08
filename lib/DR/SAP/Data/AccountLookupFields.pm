package DR::SAP::Data::AccountLookupFields;
BEGIN {
  $DR::SAP::Data::AccountLookupFields::VERSION = '0.15';
}
BEGIN {
  $DR::SAP::Data::AccountLookupFields::VERSION = '0.15';
}

# ABSTRACT: Expresses bare minimum number of fields that SAP needs for looking up a vendor/third-party/affiliate/etc

use Moose::Role;
use namespace::autoclean;
use Moose::Util::TypeConstraints;
use MooseX::Types::Moose qw(HashRef);
use DR::SAP::Meta::Types qw(PlatformID AccountGroup);
use DR::SAP::Meta::Trait::SOAP;

coerce 'DR::SAP::Data::AccountLookupFields', from HashRef, via { require DR::SAP::Data::LightweightVendor; DR::SAP::Data::LightweightVendor->new($_) };


has platform_id => (
	traits   => ['SOAP'],
	is       => 'rw',
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

has account_group => (
	traits    => ['SOAP'],
	is        => 'rw',
	isa       => AccountGroup,
	required  => 1,
	soap_name => 'ZACCOUNTGROUP',
	to_SOAP   => \&DR::SAP::Meta::Types::_translate_account_group_to_SAP,
	from_SOAP => \&DR::SAP::Meta::Types::_translate_account_group_from_SAP,
);
has _company_code => (
	traits    => ['SOAP'],
	is        => 'rw',
	required  => 1,
	default   => '',
	soap_name => 'ZCOMPCODE',
);

has _purchasing_organization => (
	traits   => ['SOAP'],
	is       => 'rw',
	required => 1,
	default  => '1000',
	soap_name => 'ZPURCHORG',
);

1;

__END__
=pod

=head1 NAME

DR::SAP::Data::AccountLookupFields - Expresses bare minimum number of fields that SAP needs for looking up a vendor/third-party/affiliate/etc

=head1 VERSION

version 0.15

=head1 ATTRIBUTES

=head2 platform_id

See L<DR::SAP::Meta::Types/PlatformID>

=head2 platform_account

The platform's ID for this specific account.

=head2 account_group

=head1 AUTHOR

  Brian Phillips <bphillips@digitalriver.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2010 by Digital River, Inc

All rights reserved.

=cut

