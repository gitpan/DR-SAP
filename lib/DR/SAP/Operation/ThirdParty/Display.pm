package DR::SAP::Operation::ThirdParty::Display;
BEGIN {
  $DR::SAP::Operation::ThirdParty::Display::VERSION = '0.15';
}
BEGIN {
  $DR::SAP::Operation::ThirdParty::Display::VERSION = '0.15';
}

# ABSTRACT: Operation for retrieving third-party vendors from SAP.

use Moose;
use namespace::autoclean;
use DR::SAP::Meta::Types qw(PlatformID);
extends 'DR::SAP::Operation::ThirdParty::Manage';
with 'DR::SAP::Meta::SOAPParams';

sub _build__transaction_type { 'D' };

__PACKAGE__->meta->make_immutable;

1;

__END__
=pod

=head1 NAME

DR::SAP::Operation::ThirdParty::Display - Operation for retrieving third-party vendors from SAP.

=head1 VERSION

version 0.15

=head1 AUTHOR

  Brian Phillips <bphillips@digitalriver.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2010 by Digital River, Inc

All rights reserved.

=cut

