package DR::SAP::WSDL::Default;
BEGIN {
  $DR::SAP::WSDL::Default::VERSION = '0.15';
}
BEGIN {
  $DR::SAP::WSDL::Default::VERSION = '0.15';
}

# ABSTRACT: Singleton class for collecting default values for the WSDL singletons

use MooseX::Singleton;
use namespace::autoclean;
use Carp qw(croak);

with 'DR::SAP::WSDL' => { -excludes => [qw(_build_name)] };

__PACKAGE__->meta->make_immutable;

sub _build_name {
	croak "This class is not intended to be used as a true WSDL object";
}

1;


=pod

=head1 NAME

DR::SAP::WSDL::Default - Singleton class for collecting default values for the WSDL singletons

=head1 VERSION

version 0.15

=head1 SEE ALSO

=over 4

=item *

L<DR::SAP::WSDL>

=back

=head1 AUTHOR

  Brian Phillips <bphillips@digitalriver.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2010 by Digital River, Inc

All rights reserved.

=cut


__END__
