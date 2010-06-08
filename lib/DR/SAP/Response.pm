package DR::SAP::Response;
BEGIN {
  $DR::SAP::Response::VERSION = '0.15';
}
BEGIN {
  $DR::SAP::Response::VERSION = '0.15';
}

# ABSTRACT: Base class for response objects from SAP web service calls

use Moose;
use namespace::autoclean;


has trace => (
	is       => 'rw',
	isa      => 'XML::Compile::SOAP::Trace',
	required => 1
);


has raw_response => (
	is       => 'rw',
	required => 1,
);

__PACKAGE__->meta->make_immutable;


sub response_data_key {
	my $class = shift;
	die "$class must override the response_data_key method";
}

1;

__END__
=pod

=head1 NAME

DR::SAP::Response - Base class for response objects from SAP web service calls

=head1 VERSION

version 0.15

=head1 ATTRIBUTES

=head2 trace

An L<XML::Compile::SOAP::Trace> object.

=head2 raw_response

The original, non-OO response from XML::Compile::SOAP (as HashRef)

=head1 METHODS

=head2 response_data_key
Abstract method indicating what top-level key the actual response data can be found in.

=head1 AUTHOR

  Brian Phillips <bphillips@digitalriver.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2010 by Digital River, Inc

All rights reserved.

=cut

