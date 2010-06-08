package DR::SAP::Response::WithBankingChecksum;
BEGIN {
  $DR::SAP::Response::WithBankingChecksum::VERSION = '0.15';
}
BEGIN {
  $DR::SAP::Response::WithBankingChecksum::VERSION = '0.15';
}

# ABSTRACT: role for response objects that include a banking info checksum

use Moose::Role;
use namespace::autoclean;
use DR::SAP::Data::Message;
use DR::SAP::Meta::Trait::SOAP;
use MooseX::Types::Moose qw(Str);

requires 'error_messages';

has checksum => (
	traits   => ['SOAP'],
	is       => 'ro',
	soap_name => 'ZCHECKSUM',
);


sub failed_bank_validation {
	my $self = shift;
	return scalar( grep { $_->message_code eq 'ZW-014' } $self->error_messages );
}

1;

__END__
=pod

=head1 NAME

DR::SAP::Response::WithBankingChecksum - role for response objects that include a banking info checksum

=head1 VERSION

version 0.15

=head1 METHODS

=head2 failed_bank_validation
Returns true/false indicating whether the response from SAP includes a
specific message related to needing to verify the bank details.

=head1 AUTHOR

  Brian Phillips <bphillips@digitalriver.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2010 by Digital River, Inc

All rights reserved.

=cut

