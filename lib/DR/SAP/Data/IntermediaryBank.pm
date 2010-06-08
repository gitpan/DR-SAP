package DR::SAP::Data::IntermediaryBank;
BEGIN {
  $DR::SAP::Data::IntermediaryBank::VERSION = '0.15';
}
BEGIN {
  $DR::SAP::Data::IntermediaryBank::VERSION = '0.15';
}

# ABSTRACT: Client-side proxy object for SAP intermediary bank

use Moose;
use namespace::autoclean;
use DR::SAP::Data::AbstractBank;
extends 'DR::SAP::Data::AbstractBank';

__PACKAGE__->meta->make_immutable;

1;


__END__
=pod

=head1 NAME

DR::SAP::Data::IntermediaryBank - Client-side proxy object for SAP intermediary bank

=head1 VERSION

version 0.15

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

