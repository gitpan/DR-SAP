use strict;
use warnings;
use Test::More qw(no_plan);

use_ok('DR::SAP::Data::LightweightVendor');
my $v = DR::SAP::Data::LightweightVendor->new( platform_id => 'SW', platform_account => 1, account_group => 'vendor');
can_ok($v, 'platform_id');
