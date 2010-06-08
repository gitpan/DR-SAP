package DR::SAP::Data::ThirdParty;
BEGIN {
  $DR::SAP::Data::ThirdParty::VERSION = '0.15';
}
BEGIN {
  $DR::SAP::Data::ThirdParty::VERSION = '0.15';
}

# ABSTRACT: Client-side proxy object for an SAP Z3RD record

use Moose;
use namespace::autoclean;
use DR::SAP::Meta::Types qw(AccountGroup);

with( 'DR::SAP::Meta::SOAPParams', 'DR::SAP::Data::AbstractAccount' );


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


has third_party_id => (
	traits   => ['SOAP'],
	is       => 'rw',
	soap_name => 'Z3RDPARTYID',
);



has third_party_name => (
	traits   => ['SOAP'],
	is       => 'rw',
	soap_name => 'Z3RDPARTYNAME',
);

__PACKAGE__->meta->make_immutable;

1;


__END__
=pod

=head1 NAME

DR::SAP::Data::ThirdParty - Client-side proxy object for an SAP Z3RD record

=head1 VERSION

version 0.15

=head1 ATTRIBUTES

=head2 account_group

=head2 third_party_id

Platform identifier for the third-party record.

=head2 third_party_name

I.e. company name

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

