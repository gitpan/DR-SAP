package DR::SAP::Operation::ThirdParty::Update;
BEGIN {
  $DR::SAP::Operation::ThirdParty::Update::VERSION = '0.15';
}
BEGIN {
  $DR::SAP::Operation::ThirdParty::Update::VERSION = '0.15';
}

# ABSTRACT: Operation for updating third-party vendors in SAP

use Moose;
use namespace::autoclean;
extends 'DR::SAP::Operation::ThirdParty::Manage';

sub _build__transaction_type { 'U' };

__PACKAGE__->meta->make_immutable;

1;


=pod

=head1 NAME

DR::SAP::Operation::ThirdParty::Update - Operation for updating third-party vendors in SAP

=head1 VERSION

version 0.15

=head1 SEE ALSO

=over 4

=item *

extends L<DR::SAP::Operation::ThirdParty::Manage>

=back

=head1 AUTHOR

  Brian Phillips <bphillips@digitalriver.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2010 by Digital River, Inc

All rights reserved.

=cut


__END__

