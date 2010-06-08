package DR::SAP::WSDL;
BEGIN {
  $DR::SAP::WSDL::VERSION = '0.15';
}
BEGIN {
  $DR::SAP::WSDL::VERSION = '0.15';
}

# ABSTRACT: Role defining attributes for WSDLs

use Moose::Role;
use namespace::autoclean;
use File::ShareDir qw(dist_file);
use XML::Compile::WSDL11;
use XML::Compile::SOAP11;
use MooseX::Types::Moose qw(Str);
use Moose::Util::TypeConstraints;
use Carp qw(confess);
use DR::SAP::Meta::Types qw(Uri);
use URI;
use constant LEGACY_XML_COMPILE => XML::Compile::SOAP->VERSION < 2;

has _default_wsdl_options => (
	is         => 'ro',
	lazy_build => 1,
);
sub _build__default_wsdl_options {
	require DR::SAP::WSDL::Default;
	return DR::SAP::WSDL::Default->instance;
}


has name => (
	is       => 'ro',
	isa      => Str,
	lazy_build => 1,
);
sub _build_name {
	my $self = shift;
	(my $class = ref($self)) =~ s/.*:://;
	return "$class.wsdl";
}

has file => (
	is         => 'ro',
	isa        => Str,
	lazy_build => 1,
);
sub _build_file {
	my $self = shift;
	return dist_file( 'DR-SAP', $self->name );
}


has wsdl => (
	is         => 'ro',
	isa        => 'XML::Compile::WSDL11',
	lazy_build => 1,
);
sub _build_wsdl {
	my $self = shift;
	return XML::Compile::WSDL11->new($self->file);
}

has port => (
	is       => 'ro',
	isa      => enum(['HTTP','HTTPS']),
	lazy_build => 1,
);

sub _build_port {
	my $self = shift;
	if($self->_default_wsdl_options->has_port){
		return $self->_default_wsdl_options->port;
	} else {
		return 'HTTP';
	}
}


has endpoint => (
	is         => 'ro',
	isa        => Uri,
	coerce     => 1,
	lazy_build => 1,
);

sub _build_endpoint {
	my $self = shift;
	my $wsdl = $self->wsdl;
	my ($op) = grep { ( LEGACY_XML_COMPILE ? $_->port->{name} : $_->portName ) eq $self->port . "_Port" }
			   $wsdl->operations( LEGACY_XML_COMPILE ? ( produce => "OBJECTS" ) : () );

	my ($address) = URI->new( LEGACY_XML_COMPILE ? $op->endPointAddresses : $op->endPoints );
	if ( $self->has_endpoint_host ) {
		$address->host( $self->endpoint_host );
	} elsif ( $self->_default_wsdl_options->has_endpoint_host ) {
		$address->host( $self->_default_wsdl_options->endpoint_host );
	}
	return $address;
}

has endpoint_host => (
	is         => 'ro',
	isa        => Str,
	lazy_build => 1,
);
sub _build_endpoint_host {
	my $self = shift;
	if ( $self->_default_wsdl_options->has_endpoint_host ) {
		return $self->_default_wsdl_options->endpoint_host;
	} else {
		return $self->endpoint->host;
	}
}


has security_realm => (
	is       => 'ro',
	isa      => Str,
	required => 1,
	default  => 'XISOAPApps'
);

1;

__END__
=pod

=head1 NAME

DR::SAP::WSDL - Role defining attributes for WSDLs

=head1 VERSION

version 0.15

=head1 ATTRIBUTES

=head2 name

Defaults to the last segment of the package name.

=head2 file

Defaults to the C<$self-E<gt>name.wsdl> as originally installed with the distribution.

=head2 wsdl

An L<XML::Compile::WSDL11> object, typically just the compiled version of C<$self-E<gt>file>.

=head2 port

HTTP/HTTPS (Defaults to HTTP for now)

=head2 endpoint

The endpoint for the web service this WSDL represents.  Defaults to the first operation's endpoint address (matching on C<$self-E<gt>port>).

=head2 security_realm

The HTTP BasicAuth security realm for this WSDL's web service.  Defaults to "XISOAPApps".

=head1 AUTHOR

  Brian Phillips <bphillips@digitalriver.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2010 by Digital River, Inc

All rights reserved.

=cut

