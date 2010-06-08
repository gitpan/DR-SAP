use strict;
use warnings;
use Test::More qw(no_plan);
use XML::Compile::SOAP::Trace;

BEGIN { use_ok 'DR::SAP::Operation::Vendor::Display' };
use DR::SAP::Data::Vendor;

my $op = DR::SAP::Operation::Vendor::Display->new(platform_id => 'RW', platform_account => 'v1234');
isa_ok($op, 'DR::SAP::Operation::Vendor::Display', 'operation');
is($op->to_SOAP->{VENDOR_MAINTENANCE}->{ZPLATFORMACCT}, 'v1234', 'platform_account');
