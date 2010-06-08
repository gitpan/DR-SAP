package DR::SAP::Data::PrimaryBank;
BEGIN {
  $DR::SAP::Data::PrimaryBank::VERSION = '0.15';
}
BEGIN {
  $DR::SAP::Data::PrimaryBank::VERSION = '0.15';
}

# ABSTRACT: Client-side proxy object for an SAP primary bank record

use Moose;
use namespace::autoclean;
extends 'DR::SAP::Data::AbstractBank';


has account_holder => (
	traits    => ['SOAP'],
	is        => 'rw',
	required  => 1,
	soap_name => 'ZBANKACCTHOLDER',
);


has iban => (
	traits    => ['SOAP'],
	is        => 'rw',
	required  => 0,
	soap_name => 'ZIBAN',
);


has account_number => (
	traits    => ['SOAP'],
	is        => 'rw',
	required  => 0,
	soap_name => 'ZACCTNUM',
);


has comment => (
	traits    => ['SOAP'],
	is        => 'ro',
	required  => 0,
	soap_name => 'ZBANKCOMMENT',
);

__PACKAGE__->meta->make_immutable;

1;


__END__
=pod

=head1 NAME

DR::SAP::Data::PrimaryBank - Client-side proxy object for an SAP primary bank record

=head1 VERSION

version 0.15

=head1 ATTRIBUTES

=head2 account_holder

Name of the account holder.

=head2 iban

=head2 account_number

=head2 comment

Payment instructions for bank.

=head1 SEE ALSO

=over 4

=item *

L<DR::SAP::Data::AbstractBank>

=back

=head1 AUTHOR

  Brian Phillips <bphillips@digitalriver.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2010 by Digital River, Inc

All rights reserved.

=cut

