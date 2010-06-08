package DR::SAP::WSDL::FundsTransfer;
BEGIN {
  $DR::SAP::WSDL::FundsTransfer::VERSION = '0.15';
}
BEGIN {
  $DR::SAP::WSDL::FundsTransfer::VERSION = '0.15';
}

# ABSTRACT: Singleton class representing the FundsTransfer WSDL

use MooseX::Singleton;
use namespace::autoclean;

with 'DR::SAP::WSDL';

__PACKAGE__->meta->make_immutable;

1;


=pod

=head1 NAME

DR::SAP::WSDL::FundsTransfer - Singleton class representing the FundsTransfer WSDL

=head1 VERSION

version 0.15

=head1 SEE ALSO

=over 4

=item *

L<DR::SAP::WSDL>

=back

=head1 AUTHOR

  Brian Phillips <bphillips@digitalriver.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2010 by Digital River, Inc

All rights reserved.

=cut


__END__