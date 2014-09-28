# Pragmas.
use strict;
use warnings;

# Modules.
use Class::Params qw(params);
use English;
use Error::Pure::Utils qw(clean);
use Test::More 'tests' => 12;
use Test::NoWarnings;

# Test.
my $self = {};
my $def_hr = {};
eval {
	params($self, $def_hr, ['foo', 'bar']);
};
is($EVAL_ERROR, "Unknown parameter 'foo'.\n", "Unknown parameter 'foo'.");
clean();

# Test.
$self = {};
$def_hr = {
	'foo' => ['_foo', 'SCALAR', 0],
};
params($self, $def_hr, ['foo', 'bar']);
is_deeply(
	$self,
	{
		'_foo' => 'bar',
	},
	"Right check for parameter 'foo' (SCALAR).",
);

# Test.
$self = {};
$def_hr = {
	'foo' => ['_foo', 'SCALAR', 1],
	'bar' => ['_bar', 'SCALAR', 0],
};
eval {
	params($self, $def_hr, ['bar', 'baz']);
};
is($EVAL_ERROR, "Parameter 'foo' is required.\n",
	"Parameter 'foo' is required (SCALAR).");
clean();

# Test.
$self = {};
$def_hr = {
	'foo' => ['_foo', 'SCALAR', 1],
};
params($self, $def_hr, ['foo', 'bar']);
is_deeply(
	$self,
	{
		'_foo' => 'bar',
	},
	"Right check for required parameter 'foo' (SCALAR).",
);

# Test.
$self = {};
$def_hr = {
	'foo' => ['_foo', 'HASH', 0],
};
eval {
	params($self, $def_hr, ['foo', 'bar']);
};
is($EVAL_ERROR, "Bad parameter 'foo' type.\n",
	"Bad parameter 'foo' type (HASH).");
clean();

# Test.
$self = {};
$def_hr = {
	'foo' => ['_foo', 'HASH', 0],
};
params($self, $def_hr, ['foo', {'xxx' => 'yyy'}]);
is_deeply(
	$self,
	{
		'_foo' => {
			'xxx' => 'yyy',
		},
	},
	"Right check for parameter 'foo' (HASH).",
);

# Test.
$self = {};
$def_hr = {
	'foo' => ['_foo', 'ARRAY', 0],
};
eval {
	params($self, $def_hr, ['foo', 'bar']);
};
is($EVAL_ERROR, "Bad parameter 'foo' type.\n",
	"Bad parameter 'foo' type (ARRAY).");
clean();

# Test.
$self = {};
$def_hr = {
	'foo' => ['_foo', 'ARRAY', 0],
};
params($self, $def_hr, ['foo', ['xxx', 'yyy']]);
is_deeply(
	$self,
	{
		'_foo' => ['xxx', 'yyy'],
	},
	"Right check for parameter 'foo' (ARRAY).",
);

# Test.
$self = {};
$def_hr = {
	'foo' => ['_foo', ['SCALAR', 'ARRAY'], 0],
};
params($self, $def_hr, ['foo', 'bar']);
is_deeply(
	$self,
	{
		'_foo' => 'bar',
	},
	"Right check for parameter 'foo' with multiple types (SCALAR).",
);
params($self, $def_hr, ['foo', ['xxx', 'yyy']]);
is_deeply(
	$self,
	{
		'_foo' => ['xxx', 'yyy'],
	},
	"Right check for parameter 'foo' with multiple types (ARRAY).",
);

# Test.
$self = {};
$def_hr = {
	'foo' => ['_foo', ['SCALAR', 'ARRAY'], 0],
};
eval {
	params($self, $def_hr, ['foo', {}]);
};
is($EVAL_ERROR, "Bad parameter 'foo' type.\n",
	"Bad parameter 'foo' type with multiple types.");
clean();
