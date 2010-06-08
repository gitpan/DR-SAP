package DR::SAP::Operation::Vendor::Create;
BEGIN {
  $DR::SAP::Operation::Vendor::Create::VERSION = '0.15';
}
BEGIN {
  $DR::SAP::Operation::Vendor::Create::VERSION = '0.15';
}

# ABSTRACT: Client proxy class for the vendor creation web service

use Moose;
use namespace::autoclean;
extends 'DR::SAP::Operation::Vendor::Manage';
has '+vendor' => ( required => 1);

sub _build__transaction_type { 'C' };

__PACKAGE__->meta->make_immutable;

1;


__END__
=pod

=head1 NAME

DR::SAP::Operation::Vendor::Create - Client proxy class for the vendor creation web service

=head1 VERSION

version 0.15

=head1 SEE ALSO

=over 4

=item *

L<DR::SAP::Operation::Vendor::Manage>

=back

=head1 AUTHOR

  Brian Phillips <bphillips@digitalriver.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2010 by Digital River, Inc

All rights reserved.

=cut

