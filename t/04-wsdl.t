use strict;
use warnings;
use Test::More qw(no_plan);
use File::Basename qw(dirname);

BEGIN {
use_ok 'DR::SAP::WSDL::VendorMaintenance';
use_ok 'DR::SAP::WSDL::Default';
DR::SAP::WSDL::Default->initialize(endpoint_host => 'testing.com', port => 'HTTPS');
DR::SAP::WSDL::VendorMaintenance->initialize(file => dirname($0) . '/../share/VendorMaintenance.wsdl');
}

my $wsdl = DR::SAP::WSDL::VendorMaintenance->instance;
ok $wsdl->endpoint, 'has endpoint';
is $wsdl->endpoint->host, 'testing.com', 'uses hostname override';
is $wsdl->endpoint->port, '443', 'uses port override';
