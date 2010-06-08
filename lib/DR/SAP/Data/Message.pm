package DR::SAP::Data::Message;
BEGIN {
  $DR::SAP::Data::Message::VERSION = '0.15';
}
BEGIN {
  $DR::SAP::Data::Message::VERSION = '0.15';
}

# ABSTRACT: Local proxy class for SAP messages that are returned

use Moose;
use MooseX::Types::Moose qw(Str);
use Moose::Util::TypeConstraints;
use namespace::autoclean;

BEGIN { with 'DR::SAP::Meta::SOAPParams' };


use constant {
	ERROR => 'E',
	SUCCESS => 'S',
	WARNING => 'W',
	INFO    => 'I',
	ABORT   => 'A',
};


has type => (
	traits    => ['SOAP'],
	is        => 'rw',
	isa       => enum( [qw(S E W I A)] ),
	soap_name => 'TYPE'
);


has id => (
	traits    => ['SOAP'],
	is        => 'rw',
	soap_name => 'ID',
	default   => 'UN',
);

has message_number => (
	traits    => ['SOAP'],
	is        => 'ro',
	soap_name => 'NUMBER',
	default   => '000'
);


has message_code => (
	is         => 'ro',
	lazy_build => 1,
	init_arg   => undef
);
sub _build_message_code {
	my $self = shift;
	return sprintf('%s-%03d', $self->id, $self->message_number);
}


has message => (
	traits    => ['SOAP'],
	is       => 'ro',
	soap_name => 'MESSAGE'
);


has log_number => (
	traits    => ['SOAP'],
	is       => 'ro',
	soap_name => 'LOG_NO'
);

has log_message_number => (
	traits    => ['SOAP'],
	is       => 'ro',
	soap_name => 'LOG_MSG_NO'
);
has message_v1 => (
	traits    => ['SOAP'],
	is       => 'ro',
	soap_name => 'MESSAGE_V1'
);
has message_v2 => (
	traits    => ['SOAP'],
	is       => 'ro',
	soap_name => 'MESSAGE_V2'
);
has message_v3 => (
	traits    => ['SOAP'],
	is       => 'ro',
	soap_name => 'MESSAGE_V3'
);
has message_v4 => (
	traits    => ['SOAP'],
	is       => 'ro',
	soap_name => 'MESSAGE_V4'
);
has parameter => (
	traits    => ['SOAP'],
	is       => 'ro',
	soap_name => 'PARAMETER'
);
has row => (
	traits    => ['SOAP'],
	is       => 'ro',
	soap_name => 'ROW'
);
has field => (
	traits    => ['SOAP'],
	is       => 'ro',
	soap_name => 'FIELD'
);
has system => (
	traits    => ['SOAP'],
	is       => 'ro',
	soap_name => 'SYSTEM'
);


{
	my %user_facing_message_codes = map { $_ => undef }
			('DR-000'),
			( map { sprintf( 'ZW-%03d', $_ ) } 6 .. 23, 25 .. 28, 31 .. 32 );

	sub is_user_facing {
		my $self = shift;
		return exists $user_facing_message_codes{ $self->message_code };
	}
}


sub UNKNOWN_ERROR_MESSAGE {
	return DR::SAP::Data::Message->new(
		type           => ERROR,
		id             => 'DR',
		message_number => '000',
		message        => 'An unknown error has occurred'
	);
}

__PACKAGE__->meta->make_immutable;

1;

__END__
=pod

=head1 NAME

DR::SAP::Data::Message - Local proxy class for SAP messages that are returned

=head1 VERSION

version 0.15

=head1 ATTRIBUTES

=head2 type

=head2 id

SAP message ID

=head2 message_number

SAP message number

=head2 message_code

Composite of id and message_number (i.e. ZW-001)

=head2 message

=head2 log_number

=head2 log_message_number

=head1 METHODS

=head2 is_user_facing

Returns a boolean indicating whether the error message is in a list of
"safe" messages to present to the user.

=head1 FUNCTIONS

=head2 UNKNOWN_ERROR_MESSAGE

Returns an "unknown error" message object.

=head1 CONSTANTS

=over 4

=item ERROR

=item SUCCESS

=item WARNING

=item INFO

=item ABORT

=back

=head1 AUTHOR

  Brian Phillips <bphillips@digitalriver.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2010 by Digital River, Inc

All rights reserved.

=cut

