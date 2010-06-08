package DR::SAP::Meta::Trait::SOAP;
BEGIN {
  $DR::SAP::Meta::Trait::SOAP::VERSION = '0.15';
}
BEGIN {
  $DR::SAP::Meta::Trait::SOAP::VERSION = '0.15';
}

# ABSTRACT: Moose attribute meta class to define conversion to/from SOAP data structures.

use Moose::Role;
use MooseX::Types::Moose qw(ClassName Str CodeRef);
use namespace::autoclean;


has soap_name => (
	is       => 'ro',
	isa      => Str,
	required => 1,
	default  => sub { shift->name }
);


has to_SOAP => (
	is       => 'ro',
	isa      => CodeRef,
	predicate => 'has_to_SOAP',
);


has from_SOAP => (
	is       => 'ro',
	isa      => CodeRef,
	predicate => 'has_from_SOAP',
);

package Moose::Meta::Attribute::Custom::Trait::SOAP;
BEGIN {
  $Moose::Meta::Attribute::Custom::Trait::SOAP::VERSION = '0.15';
}
BEGIN {
  $Moose::Meta::Attribute::Custom::Trait::SOAP::VERSION = '0.15';
}

sub register_implementation { 'DR::SAP::Meta::Trait::SOAP' }

1;


__END__
=pod

=head1 NAME

DR::SAP::Meta::Trait::SOAP - Moose attribute meta class to define conversion to/from SOAP data structures.

=head1 VERSION

version 0.15

=head1 ATTRIBUTES

=head2 soap_name

The (required) attribute name as it exists in the SOAP data structure.

=head2 to_SOAP

Optional callback for converting the attribute's value into the
corresponding SOAP data structure.

=head2 to_SOAP

Optional callback for converting the attribute's value from the SOAP
data structure into the corresponding Perl value.

=head1 AUTHOR

  Brian Phillips <bphillips@digitalriver.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2010 by Digital River, Inc

All rights reserved.

=cut

