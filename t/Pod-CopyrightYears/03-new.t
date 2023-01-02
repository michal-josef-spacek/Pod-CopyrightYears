use strict;
use warnings;

use English;
use Error::Pure::Utils qw(clean);
use Pod::CopyrightYears;
use Test::More 'tests' => 3;
use Test::NoWarnings;

# Test.
my $obj = Pod::CopyrightYears->new;
isa_ok($obj, 'Pod::CopyrightYears');

# Test.
eval {
	Pod::CopyrightYears->new(
		'bad_param' => 'foo',
	);
};
is($EVAL_ERROR, "Unknown parameter 'bad_param'.\n", "Unknown parameter 'bad_param'.");
clean();
