#!perl

use strict;
use warnings;

BEGIN
{
    # Reset the database.
    unlink("insurgent-auth.sqlite");
}

use Test::More tests => 16;
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

my $short_pass = "heh";

# TEST
$mech->submit_form_ok(
    {
        form_id => "register",
        fields =>
        {
            email => $email,
            password => $short_pass,
            password2 => $short_pass,
            fullname => "Sophie Esmeralda Johnson",
        },
    },
    "Submit the new form on the rejection screen with different passwords.",
);

# TEST
$mech->has_tag("h1", "Registration failed - password is too short.");

# TEST
$mech->submit_form_ok(
    {
        form_id => "register",
        fields =>
        {
            email => $email,
            password => $password,
            password2 => $password,
            fullname => "Sophie Esmeralda Johnson",
        },
    },
    "Submit the form - should succeed now.",
);

# TODO : test that the user was registered properly.

# TEST
$mech->get_ok("/", "Got the front page again.");

# TEST
$mech->follow_link_ok({text => "Register a new account"}, 
    "Was able to follow the link to register (2nd time)."
);

my $pass2 = "FooBarasdmk--34t+536'Y";
# TEST
$mech->submit_form_ok(
    {
        form_id => "register",
        fields =>
        {
            email => $email,
            password => $pass2,,
            password2 => $pass2,
            fullname => "Sophie Goringa Lactor",
        },
    },
    "Submit form with existing E-mail.",
);

# TEST
$mech->has_tag("h1", "Registration failed - the email was already registered");
