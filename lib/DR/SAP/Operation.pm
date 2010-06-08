package DR::SAP::Operation;
BEGIN {
  $DR::SAP::Operation::VERSION = '0.15';
}
BEGIN {
  $DR::SAP::Operation::VERSION = '0.15';
}

# ABSTRACT: Base class for all SAP web service operation objects

use Moose;
use namespace::autoclean;
use XML::Compile::SOAP;
use constant LEGACY_XML_COMPILE => XML::Compile::SOAP->VERSION < 2;


has wsdl => (
	is       => 'ro',
	isa      => 'DR::SAP::WSDL',
	required => 1,
	lazy_build => 1,
);

before BUILDARGS => sub {
	my $class = shift;
	die "you must sub-class $class to use this" if ( $class eq __PACKAGE__ );
	die "$class must implement a to_SOAP method" unless $class->can('to_SOAP');
	return;
};

__PACKAGE__->meta->make_immutable;


sub name {
	my $self = shift;
	# strip __PACKAGE__:: from the front of the operation name
	my $class = substr(ref($self),length(__PACKAGE__) + 2);
	return $class;
}


sub build_response {
	my $self           = shift;
	my %args = @_;
	my $response_class = $self->response_class;
	if ( !eval { $response_class->isa('DR::SAP::Response') } ) {
		die sprintf(
			'response class %s (as determined by %s->response_class) must have an isa relationship to DR::SAP::Response',
			$response_class, ref($self)
		);
	}
	if( $response_class->does('DR::SAP::Meta::SOAPParams')){
		%args = (%{ $args{raw_response}->{ $response_class->response_data_key } }, %args);
		return $response_class->from_SOAP(\%args);
	} else {
		return $response_class->new(%args);
	}
}


sub response_class {
	my $self = shift;
	return ref($self) . '::response';
}


sub compile {
	my $self  = shift;
	my %args  = @_;
	my $wsdl  = $self->wsdl;
	my $compiled = $wsdl->wsdl;
	my $op    = $compiled->operation( $self->name, port => $wsdl->port . '_Port' );
	my $trans = XML::Compile::Transport::SOAPHTTP->new( charset => 'utf-8', address => $wsdl->endpoint, timeout => $args{timeout} );
	$trans->userAgent->credentials(
		$wsdl->endpoint->host_port, $wsdl->security_realm, $args{username}, $args{password}
	);
	my $send = $trans->compileClient(
		name   => $op->name,
		kind   => $op->kind,
		soap   => LEGACY_XML_COMPILE ? $op->soapVersion : $op->version,
		action => LEGACY_XML_COMPILE ? $op->soapAction  : $op->action,
		$args{transport_hook} ? ( hook => $args{transport_hook} ) : (),
	);
	my $call = $op->compileClient( transport => $send );
	return $call;
}

1;

__END__
=pod

=head1 NAME

DR::SAP::Operation - Base class for all SAP web service operation objects

=head1 VERSION

version 0.15

=head1 ATTRIBUTES

=head2 wsdl

=head1 METHODS

=head2 name

=head2 build_response

Creates a response object from the SOAP response data.

=head2 response_class

Intended to be overridden by the sub-class.  Defaults to C<<ref($self) . '::response'>>.

=head2 compile

Accepts named arguments (user, password and transport_hook) and returns
the compiled (using XML::Compile's definition of compiled) client.

=head1 AUTHOR

  Brian Phillips <bphillips@digitalriver.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2010 by Digital River, Inc

All rights reserved.

=cut

