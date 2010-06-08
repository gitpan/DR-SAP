package DR::SAP;
BEGIN {
  $DR::SAP::VERSION = '0.15';
}
BEGIN {
  $DR::SAP::VERSION = '0.15';
}

# ABSTRACT: SOAP client for the SAP web services

use Moose;
use Carp qw(croak);
use namespace::autoclean;
use XML::Compile::WSDL11;
use XML::Compile::Transport::SOAPHTTP;
use MooseX::Types::Moose qw(Int Str CodeRef HashRef);
use DR::SAP::Meta::Types qw(PlatformID);

use Module::Pluggable (
	search_path => [qw(DR::SAP::Operation)],
	sub_name => 'operations',
	inner    => 0,
	require  => 1,
);
BEGIN {
__PACKAGE__->operations; # require all the operations
}


has username => (
	is       => 'ro',
	isa      => Str,
	required => 1,
);


has password => (
	is       => 'ro',
	isa      => Str,
	required => 1,
);

has platform_id => (
	is       => 'ro',
	isa      => PlatformID,
	required => 0,
);


has timeout => (
	is       => 'rw',
	isa      => Int,
	required => 1,
	default  => 300
);


has trace => (
	is       => 'rw',
	isa      => 'XML::Compile::SOAP::Trace',
	required => 0,
);


has transport_hook => (
	is       => 'rw',
	isa      => CodeRef,
);
has _operations => (
	is       => 'ro',
	isa      => HashRef[CodeRef],
	required => 1,
	default  => sub { +{} },
	init_arg => undef
);

sub _operation_args {
	my $self = shift;
	my $args = ref($_[0]) eq 'HASH' ? shift : {@_};
	if(my $p = $self->platform_id){
		$args->{platform_id} ||= $p;
	}
	return $args;
}


sub create_vendor {
	my $self = shift;
	my $operation = DR::SAP::Operation::Vendor::Create->new($self->_operation_args(@_));
	return $self->_call($operation);
}


sub update_vendor {
	my $self = shift;
	my $operation = DR::SAP::Operation::Vendor::Update->new($self->_operation_args(@_));
	return $self->_call($operation);
}


sub display_vendor {
	my $self = shift;
	my $operation = DR::SAP::Operation::Vendor::Display->new($self->_operation_args(@_));
	return $self->_call($operation);
}


sub link_vendors {
	my $self = shift;
	my ( $vendor_a, $vendor_b ) = @_;
	my $operation = DR::SAP::Operation::ThirdParty::Create->new( $self->_operation_args(vendor => $vendor_a, third_party => $vendor_b) );
	return $self->_call($operation);

}


sub add_third_party {
	my($self, $vendor, $third_party) = @_;
	my $operation = DR::SAP::Operation::ThirdParty::Create->new(
		$self->_operation_args( vendor => $vendor, third_party => $third_party ) );
	return $self->_call($operation);
	
}


sub get_third_parties {
	my($self, $vendor) = @_;

	my $operation = DR::SAP::Operation::ThirdParty::Display->new( $self->_operation_args(vendor => $vendor) );
	return $self->_call($operation);
}


sub update_third_party {
	my($self, $vendor, $third_party) = @_;
	my $operation = DR::SAP::Operation::ThirdParty::Update->new( $self->_operation_args(vendor => $vendor, third_party => $third_party) );
	return $self->_call($operation);
}


sub check_balance {
	my $self = shift;
	my $operation = DR::SAP::Operation::CheckBalance->new($self->_operation_args(@_));
	return $self->_call($operation);
}


sub retrieve_open_items {
	my $self = shift;
	my $operation = DR::SAP::Operation::RetrieveOpenItems->new($self->_operation_args(@_));
	return $self->_call($operation);
}


sub get_regions_by_country {
	my $self = shift;
	my $country = shift;
	return DR::SAP::Meta::Types::_get_regions($country);
}

sub get_countries_without_regions {
	my $self = shift;
	my %no_regions;
	my $countries = DR::SAP::Meta::Types::_get_countries();
	my $regions_by_country = DR::SAP::Meta::Types::_get_regions();
	foreach my $c(keys %$countries){
		$no_regions{$c} = $countries->{$c} if ! exists $regions_by_country->{$c}
	}
	return \%no_regions;
}


sub get_region_name {
	my($self, $country, $region) = @_;
	my $region_pair = DR::SAP::Meta::Types::_get_regions($country, $region);
	if ( exists $region_pair->{$region} ) {
		return $region_pair->{$region};
	}
	return;
}


sub get_region_code {
	my ( $self, $country, $region_name ) = @_;
	my $regions = DR::SAP::Meta::Types::_get_regions($country) || {};
	foreach my $code ( keys %$regions ) {
		return $code if lc($region_name) eq lc($regions->{$code});
	}
	return undef;
}

sub get_countries {
	return DR::SAP::Meta::Types::_get_countries();
}

sub get_country_name {
	my $self = shift;
	my $country = shift;
	return DR::SAP::Meta::Types::_get_country_name($country);
}

sub get_country_code {
	my $self = shift;
	my $country = shift;
	my $countries = DR::SAP::Meta::Types::_get_countries();
	foreach my $code ( keys %$countries ){
		return $code if lc($country) eq lc( $countries->{$code} );
	}
	return undef;
}

sub _call {
	my $self = shift;
	my $operation = shift;
	my $call = $self->_operations->{ $operation->name } ||= $operation->compile(
		username       => $self->username,
		password       => $self->password,
		timeout        => $self->timeout,
		transport_hook => $self->transport_hook
	);
	my $parameters = $operation->to_SOAP;

	my ($answer, $trace) = $call->( $parameters );
	$self->trace($trace); # in case it dies, for debugging

	if(!$answer){
		die sprintf("SAP call was unsucessful: %s\n%s", $trace->{error}, $trace->response->as_string);
	}
	return $operation->build_response( trace => $trace, raw_response => $answer );
}

__PACKAGE__->meta->make_immutable;

1;


__END__
=pod

=head1 NAME

DR::SAP - SOAP client for the SAP web services

=head1 VERSION

version 0.15

=head1 SYNOPSIS

	my $sap = DR::SAP->new(
		username => $sap_user,
		password => $sap_pwd,
	);

	my $response = $sap->create_vendor(
		vendor => {
			
		}
	);

=head1 ATTRIBUTES

=head2 username

The username to authenticate as when accessing the SAP web service.

=head2 password

The password to use when accessing the SAP web service.

=head2 timetout

=head2 trace

The most recent trace object that this client processed.  This may be useful if the response can

=head2 transport_hook

Provides an opportunity to hook into the transport process (primarily for unit testing).  See L<XML::Compile::Transport/"Use of the transport hook"> for more details.

=head1 METHODS

=head2 create_vendor

Creates a vendor.  All arguments will be passed to C<DR::SAP::Operation::Vendor::Create-E<gt>new>.  Returns a L<DR::SAP::Operation::Vendor::Manage::response> object.

=head2 update_vendor

Updates a vendor.  All arguments will be passed to C<DR::SAP::Operation::Vendor::Update-E<gt>new>.  Returns a L<DR::SAP::Operation::Vendor::Manage::response> object.

=head2 display_vendor

Retrieves a vendor.  All arguments will be passed to C<DR::SAP::Operation::Vendor::Create-E<gt>new>.  Returns a L<DR::SAP::Operation::Vendor::Manage::response> object.

=head2 link_vendors

Pass in two L<DR::SAP::Data::Vendor> objects (HashRef's will be coerced automatically) to create a link from the first to the second (for funds transfers).

=head2 add_third_party

Pass in a L<DR::SAP::Data::LightweightVendor> and
L<DR::SAP::Data::ThirdParty> (or something that can be coerced to those,
like HashRefs) and this method will create a connection between the two
of them.

=head2 get_third_parties

Pass in a L<DR::SAP::Data::LightweightVendor> a response object
(L<DR::SAP::Response::ThirdParty>) will be returned encapsulating the
current third-party payees connected to the vendor account.

=head2 update_third_party

=head2 check_balance

Retrieves a balance.  All arguments will be passed to C<DR::SAP::Operation::CheckBalance-E<gt>new>.  Returns a L<DR::SAP::Operation::CheckBalance::response> object.

=head2 retrieve_open_items

=head2 get_regions_by_country

Returns a HashRef that may vary depending on the arguments passed in.
If no arguments are passed in, it returns a HashRef keyed by country
codes whose values are HashRefs mapping region codes to region names.

If a country is passed in, a single-level HashRef is returned mapping
region codes to region names.

=head2 get_region_name

Accepts a country (code) and region (code) and returns the human-readable
name of that region.

=head2 get_region_code

Accepts a country (code) and region name and returns the corresponding
region code, assuming one exists.  A case-insensitive match is performed.

=head2 get_countries

Returns a HashRef mapping country codes to names.

=head2 get_country_name

Returns a country name for the code that's passed in, if it exists

=head2 get_country_code

Returns a country code for the name that's passed in, if it exists

=head1 CONFIGURATION

=over 4

=item SOAP WSDL, endpoint, etc

If you would like to use something other than the default endpoint or packaged WSDL file, you may call the following B<once>:

	# these settings will apply to all WSDLs
	DR::SAP::WSDL::Default->initialize(
		endpoint_host => 'some.endpoint.com',
		port => 'HTTP' # or HTTPS
	);

	# this only applies to the individual WSDL file
	DR::SAP::WSDL::VendorMaintenance->initialize(
		file     => '/path/to/VendorMaintenance.wsdl',
	);

=back

These may be set for each L<DR::SAP::WSDL> object.

=head1 AUTHOR

  Brian Phillips <bphillips@digitalriver.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2010 by Digital River, Inc

All rights reserved.

=cut

