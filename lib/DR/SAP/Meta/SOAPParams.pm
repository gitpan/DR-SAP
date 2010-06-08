package DR::SAP::Meta::SOAPParams;
BEGIN {
  $DR::SAP::Meta::SOAPParams::VERSION = '0.15';
}
BEGIN {
  $DR::SAP::Meta::SOAPParams::VERSION = '0.15';
}

# ABSTRACT: Moose Role to handle conversion to and from SOAP data structures

use Moose::Role;
use namespace::autoclean;
use Scalar::Util qw(blessed);
use DR::SAP::Meta::Trait::SOAP;


sub to_SOAP {
	my $self = shift;
	my $meta = $self->meta;
	my @soap_params = grep {$_->does('DR::SAP::Meta::Trait::SOAP') } $meta->get_all_attributes;
	my $out = {};
	foreach my $p(@soap_params){
		my $k = $p->soap_name;
		next unless $p->has_value($self);
		my $v = $p->get_value($self);
		if($p->has_to_SOAP){
			local $_ = $v;
			$v = $p->to_SOAP->($_);
		} else {
			$v = _value_to_SOAP($v);
		}
		$out->{$k} = $v;
	}
	return $out;
}



sub from_SOAP {
	my $class = shift;
	my $data  = shift;
	my $meta  = $class->meta;
	my @soap_params = grep { $_->does('DR::SAP::Meta::Trait::SOAP') } $meta->get_all_attributes;
	my $new_params = {%$data};
	foreach my $p (@soap_params) {
		my $k = $p->soap_name;

		my $v;
		if($k eq ''){
			$v = $data;
		} else {
			next unless exists $data->{$k};
			$v = $data->{$k};
		}

		if($p->has_from_SOAP){
			local $_ = $v;
			$v = $p->from_SOAP->($_);
		} elsif($v eq 'NULL' || $v eq 'NUL'){
			undef $v; # sic
		}
		next if !defined $v && !$p->is_required;
		$new_params->{ $p->init_arg } = $v;
	}
	return $class->new($new_params);
}

sub _value_to_SOAP {
	my $v = shift;
	if ( blessed($v) && $v->can('to_SOAP') ) {
		$v = $v->to_SOAP;
	} elsif ( ref($v) eq 'ARRAY' ) {
		$v = [ map { _value_to_SOAP($_) } @$v ];
	}
	return $v;
}

1;

__END__
=pod

=head1 NAME

DR::SAP::Meta::SOAPParams - Moose Role to handle conversion to and from SOAP data structures

=head1 VERSION

version 0.15

=head1 METHODS

=head2 to_SOAP

Converts the object in question to the corresponding SOAP data structure
as defined by the L<DR::SAP::Meta::Trait::SOAP> traits for each attribute.

=head2 from_SOAP

Converts the SOAP data structure back into the local object using the
L<DR::SAP::Meta::Trait::SOAP> traits defined on each attribute.

=head1 AUTHOR

  Brian Phillips <bphillips@digitalriver.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2010 by Digital River, Inc

All rights reserved.

=cut

