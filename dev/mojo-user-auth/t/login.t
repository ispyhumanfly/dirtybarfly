#!perl

use strict;
use warnings;

use Test::More tests => 9;
use Test::Mojo;
use Test::WWW::Mechanize::Mojo '0.0.3';

use FindBin;
require "$FindBin::Bin/../user-auth.pl";

my $t = Test::Mojo->new;
my $mech = Test::WWW::Mechanize::Mojo->new(tester => $t);

# TEST
$mech->get_ok("/", "Got the page ok.");

# TEST
is ($mech->status(), 200, "Status is 200 for Root");

# TEST
$t->content_like(qr{
    <li><a\ href="[^"]*\blogin/">Login\ to\ an\ existing\ account</a></li>\s+
    <li><a\ href="[^"]*\bregister/">Register\ a\ new\ account</a></li>
    }x);

# TEST
$mech->follow_link_ok({text => "Register a new account"}, 
    "Was able to follow the link to register."
);

# TEST
$mech->has_tag("h1", "Register an account", "Has an appropriate <h1> tag.");

my $email = 'sophie@myhome.tld';
my $password = "Sophie-Iz-De-Ossum";

# TEST
$mech->submit_form_ok(
    {
        form_id => "register",
        fields =>
        {
            email => $email,
            password => $password,
            password2 => "Something else",
            fullname => "Sophie Esmeralda Johnson",
        },
    },
    "Submit form with different passwords.",
);

# TEST
$mech->has_tag("h1", "Registration failed - passwords don't match.");


# TEST
$mech->submit_form_ok(
    {
        form_id => "register",
        fields =>
        {
            email => $email,
            password => $password,
            password2 => "Something else",
            fullname => "Sophie Esmeralda Johnson",
        },
    },
    "Submit the new form on the rejection screen with different passwords.",
);

# TEST
$mech->has_tag("h1", "Registration failed - passwords don't match.");

