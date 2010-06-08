package DR::SAP::Data::LightweightVendor;
BEGIN {
  $DR::SAP::Data::LightweightVendor::VERSION = '0.15';
}
BEGIN {
  $DR::SAP::Data::LightweightVendor::VERSION = '0.15';
}

# ABSTRACT: Concrete representation of the DR::SAP::Data::AccountLookupFields role

use Moose;
use Moose::Util::TypeConstraints;
use MooseX::Types::Moose qw(HashRef);
use namespace::autoclean;
use DR::SAP::Data::AccountLookupFields;
with 'DR::SAP::Data::AccountLookupFields';

__PACKAGE__->meta->make_immutable;

1;

__END__
=pod

=head1 NAME

DR::SAP::Data::LightweightVendor - Concrete representation of the DR::SAP::Data::AccountLookupFields role

=head1 VERSION

version 0.15

=head1 AUTHOR

  Brian Phillips <bphillips@digitalriver.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2010 by Digital River, Inc

All rights reserved.

=cut

