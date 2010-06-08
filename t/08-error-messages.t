use strict;
use warnings;
use Test::More qw(no_plan);

use DR::SAP::Data::Message;
my $m = DR::SAP::Data::Message->UNKNOWN_ERROR_MESSAGE;
isa_ok $m, 'DR::SAP::Data::Message';
ok $m->is_user_facing, 'DR-000 is user facing';

my $response = MyResponse->new(
	messages => [
		DR::SAP::Data::Message->new( id => 'ZW', message_number => '006', message => 'External', type => 'E' ),
		DR::SAP::Data::Message->new( id => 'ZW', message_number => '999', message => 'Internal', type => 'E' ),
		DR::SAP::Data::Message->new( id => 'ZW', message_number => '018', message => 'Internal', type => 'I' ),
	]
);
isa_ok $response, 'DR::SAP::Response';
is [$response->internal_error_messages]->[0]->message, 'Internal', 'internal message';
is [$response->user_facing_error_messages]->[0]->message, 'External', 'user-facing message';
ok $response->dpl_review_required, 'ZW-018 triggers DPL review flag';

BEGIN {
	package MyResponse;
	use Moose;
	extends 'DR::SAP::Response';
	with 'DR::SAP::Response::WithMessages';
	has '+trace'        => ( required => 0 );
	has '+raw_response' => ( required => 0 );
}
