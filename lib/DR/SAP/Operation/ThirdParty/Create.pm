package DR::SAP::Operation::ThirdParty::Create;
BEGIN {
  $DR::SAP::Operation::ThirdParty::Create::VERSION = '0.15';
}
BEGIN {
  $DR::SAP::Operation::ThirdParty::Create::VERSION = '0.15';
}

# ABSTRACT: Operation for creating third-party vendors in SAP

use Moose;
use namespace::autoclean;
extends 'DR::SAP::Operation::ThirdParty::Manage';

sub _build__transaction_type { 'C' };

sub response_class {
	return 'DR::SAP::Operation::ThirdParty::Create::response';
}

__PACKAGE__->meta->make_immutable;

1;

package DR::SAP::Operation::ThirdParty::Create::response;
BEGIN {
  $DR::SAP::Operation::ThirdParty::Create::response::VERSION = '0.15';
}
BEGIN {
  $DR::SAP::Operation::ThirdParty::Create::response::VERSION = '0.15';
}

use Moose;
use MooseX::Types::Moose qw(ArrayRef);
extends 'DR::SAP::Response';
with( 'DR::SAP::Response::WithMessages', 'DR::SAP::Response::WithBankingChecksum', 'DR::SAP::Meta::SOAPParams' );
use constant response_data_key => 'TP_VENDOR_MAINTENANCE';



=pod

=head1 NAME

DR::SAP::Operation::ThirdParty::Create - Operation for creating third-party vendors in SAP

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

