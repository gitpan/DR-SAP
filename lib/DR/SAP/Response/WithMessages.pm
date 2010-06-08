package DR::SAP::Response::WithMessages;
BEGIN {
  $DR::SAP::Response::WithMessages::VERSION = '0.15';
}
BEGIN {
  $DR::SAP::Response::WithMessages::VERSION = '0.15';
}

# ABSTRACT: role for response objects that include messages

use MooseX::Role::Parameterized;
use namespace::autoclean;
use DR::SAP::Data::Message;
use DR::SAP::Meta::Trait::SOAP;
use MooseX::Types::Moose qw(ArrayRef);

parameter soap_name => (
	is       => 'ro',
	required => 1,
	default => 'ZGLOBALMSG'
);

role {
	my $p = shift;

	has messages => (
		traits => [ 'Array', 'SOAP' ],
		is     => 'ro',
		isa => ArrayRef ['DR::SAP::Data::Message'],
		required  => 1,
		default   => sub { [] },
		soap_name => $p->soap_name,
		handles   => {
			all_messages  => 'elements',
			grep_messages => 'grep',
		},
		from_SOAP => sub {
			[ map { DR::SAP::Data::Message->from_SOAP($_) } (ref($_) eq 'ARRAY' ? @$_ : $_) ];
		}
	);


	method error_messages => sub {
		my $self = shift;
		return ( $self->user_facing_error_messages, $self->internal_error_messages );
	};


	method internal_error_messages => sub {
		my $self = shift;
		return grep { !$_->is_user_facing } $self->find_messages_by_type( DR::SAP::Data::Message->ERROR );
	};


	method user_facing_error_messages => sub {
		my $self        = shift;
		my @all_errors  = $self->find_messages_by_type( DR::SAP::Data::Message->ERROR );
		my @user_errors = grep { $_->is_user_facing } @all_errors;
		if ( !@user_errors && @all_errors ) {
			push @user_errors, DR::SAP::Data::Message->UNKNOWN_ERROR_MESSAGE;
		}
		return @user_errors;
	};


	method find_messages_by_type => sub {
		my $self = shift;
		my $type = shift;
		return $self->grep_messages( sub { $_->type eq $type } );
	};


	method dpl_review_required => sub {
		my $self = shift;
		return
				scalar( grep { $_->message_code eq 'ZW-018' }
					$self->find_messages_by_type( DR::SAP::Data::Message->INFO ) );
	};

};

1;

__END__
=pod

=head1 NAME

DR::SAP::Response::WithMessages - role for response objects that include messages

=head1 VERSION

version 0.15

=head1 METHODS

=head2 error_messages

Returns all messages with an "error" type.

=head2 internal_error_messages

Returns only messages with an "error" type that are not in the "whitelist"
of messages that have been identified as safe to present to the user.

=head2 user_facing_error_messages

Returns only messages with an "error" type that are also in the
"whitelist" of messages that have been identified as safe to present to
the user.

=head2 find_messages_by_type

Filters messages based on the type passed in.

=head2 dpl_review_required

Returns a boolean indicating whether this response requires a DPL review.

=head1 AUTHOR

  Brian Phillips <bphillips@digitalriver.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2010 by Digital River, Inc

All rights reserved.

=cut

