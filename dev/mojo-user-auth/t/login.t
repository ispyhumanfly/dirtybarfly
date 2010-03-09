#!perl

package MyTest::Mech::LibXML;

use strict;
use warnings;

use Test::WWW::Mechanize::Mojo '0.0.3';
use base 'Test::WWW::Mechanize::Mojo';

use HTML::TreeBuilder::LibXML;

use Test::More;

sub contains_tag
{
    local $Test::Builder::Level = $Test::Builder::Level + 1;

    my $mech = shift;
    my $tag_spec = shift;
    my $blurb = shift;

    my $tree = HTML::TreeBuilder::LibXML->new;
    $tree->parse($mech->content());
    $tree->eof();

    my $ret = $tree->look_down(@$tag_spec);

    ok($ret, $blurb);

    return $ret;
}

sub tree_matches_xpath
{
    local $Test::Builder::Level = $Test::Builder::Level + 1;

    my $mech = shift;
    my $xpath = shift;
    my $blurb = shift;

    my $tree = HTML::TreeBuilder::LibXML->new;
    $tree->parse($mech->content());
    $tree->eof();

    my @nodes = $tree->findnodes($xpath);
    return ok(scalar(@nodes), $blurb);
}

package MyTest::Mech;

use strict;
use warnings;

use Moose;

extends (qw(MyTest::Mech::LibXML Moose::Object));

sub new
{
    my $class = shift;

    my $obj = $class->SUPER::new(@_);

    return $class->meta->new_object(
        __INSTANCE__ => $obj,
        @_,
    );
}

has '_users_list' =>
(
    is => "ro",
    isa => "ArrayRef[MyTest::Mech::User]",
    init_arg => "users",
);

has '_users' =>
(
    is => "rw",
    isa => "HashRef[MyTest::Mech::User]",
    lazy => 1,
    builder => "_calc_users",
);

sub _calc_users
{
    my $self = shift;

    return 
    {
        map { $_->id() => $_ } @{$self->_users_list()},
    };
}

has '_active_user' =>
(
    isa => "MyTest::Mech::User",
    is => "rw",
    handles =>
    {
        '_active_uid' => "id",
        '_email' => "email",
        '_password' => "password",
        '_fullname' => "fullname",
    },
);

sub go_to_front
{
    my ($self, $blurb) = @_;

    $blurb ||= "Got the front page";

    local $Test::Builder::Level = $Test::Builder::Level + 1;

    return $self->get_ok("/", $blurb);
}

sub not_logged_in
{
    local $Test::Builder::Level = $Test::Builder::Level + 1;

    my $mech = shift;
    my $blurb = shift;

    return $mech->tree_matches_xpath(
        q{//div[@id='status']//b[contains(text(), 'Not logged in')]},
        $blurb,
    );
}

sub logged_in_as
{
    local $Test::Builder::Level = $Test::Builder::Level + 1;

    my $mech = shift;
    my $email = shift;
    my $blurb = shift;

    return $mech->tree_matches_xpath(
        qq{//div[\@id='status']//b[contains(text(), 'Logged in as ${email}')]},
        $blurb,
    );
}

sub h1_is
{
    my $self = shift;
    my $tag_text = shift;
    my @blurb = @_;

    if (@blurb > 1)
    {
        die "Too many arguments to h1_is!";
    }

    local $Test::Builder::Level = $Test::Builder::Level + 1;
    
    return $self->has_tag("h1", $tag_text, @blurb);
}

sub select_user
{
    my ($self, $uid) = @_;

    if (!exists($self->_users->{$uid}))
    {
        die "Could not find user '$uid'!";
    }

    $self->_active_user($self->_users->{$uid});

    return;
}

sub _register_with_passwords
{
    my ($self, $p1, $p2, $blurb) = @_;

    local $Test::Builder::Level = $Test::Builder::Level + 1;

    return $self->submit_form_ok(
        {
            form_id => "register",
            fields =>
            {
                email => $self->_email(),
                password => $p1,
                password2 => $p2,
                fullname => $self->_fullname(),
            },
        },
        $blurb,
    );
}

sub register_with_wrong_pass
{
    my ($self, $wrong_pass, $blurb) = @_;

    local $Test::Builder::Level = $Test::Builder::Level + 1;

    return $self->_register_with_passwords(
        $self->_password(),
        $wrong_pass,
        $blurb
    );

}

sub register_with_diff_pass
{
    my ($self, $diff_pass, $blurb) = @_;

    local $Test::Builder::Level = $Test::Builder::Level + 1;

    return $self->_register_with_passwords(
        $diff_pass, $diff_pass, $blurb
    );
}

sub register_properly
{
    my ($self, $blurb) = @_;

    local $Test::Builder::Level = $Test::Builder::Level + 1;

    return $self->_register_with_passwords(
        (($self->_password()) x 2), $blurb
    );
}

package MyTest::Mech::User;

use Moose;

has id => (isa => "Str", is => "ro");
has fullname => (isa => "Str", is => "ro");
has email => (isa => "Str", is => "ro");
has password => (isa => "Str", is => "ro");
has wrong_pass => (isa => "Str", is => "rw");

package main;

use strict;
use warnings;

BEGIN
{
    # Reset the database.
    unlink("insurgent-auth.sqlite");
}

use Test::More tests => 35;
use Test::Mojo;

use FindBin;
require "$FindBin::Bin/../user-auth.pl";

my @users =
(
    MyTest::Mech::User->new(
        {
            id => "sophie",
            email => q{sophie@myhome.tld},
            password => q{Sophie-Iz-De-Ossum},
            fullname => "Sophie Esmeralda Johnson",
        },
    ),
    MyTest::Mech::User->new(
        {
            id => "jack",
            email => q{jack@freedom.tld},
            password => q{I-love-5600-Sophie},
            fullname => "Jack David Johnson",
        },
    ),
    MyTest::Mech::User->new(
        {
            id => "peter",
            email => q{peter@hoffman.tld},
            password => q{n7bnc9acm9cnacvmf},
            fullname => "Peter Hoffman",
        },
    ),
    MyTest::Mech::User->new(
        {
            id => "john",
            email => q{john@galt.tld},
            password => q{Who-is-John-Galt? Not me},
            fullname => "John Galt",
        },
    ),
);

my $t = Test::Mojo->new;
my $mech = MyTest::Mech->new(
    tester => $t,
    users => \@users,
);

# TEST
$mech->go_to_front();

# TEST
is ($mech->status(), 200, "Status is 200 for Root");

# TEST
$mech->not_logged_in("Status says not logged in.");

# TEST
$t->content_like(qr{
    <li><a\ href="[^"]*\blogin/?">Login\ to\ an\ existing\ account</a></li>\s+
    <li><a\ href="[^"]*\bregister/?">Register\ a\ new\ account</a></li>
    }x);

# TEST
$mech->follow_link_ok({text => "Register a new account"}, 
    "Was able to follow the link to register."
);

# TEST
$mech->h1_is("Register an account", "Has an appropriate <h1> tag.");

my $email = 'sophie@myhome.tld';
my $password = "Sophie-Iz-De-Ossum";

$mech->select_user("sophie");

# TEST
$mech->register_with_wrong_pass(
    "Something else",
    "sophie - Submit form with different passwords."
);

# TEST
$mech->h1_is(
    "Registration failed - passwords don't match.",
    "passwords don't match."
);

# TEST
$mech->register_with_wrong_pass(
    "Something else",
    "sophie - Submit the new form on the rejection screen with different passwords.",
);

# TEST
$mech->h1_is(
    "Registration failed - passwords don't match.",
    "passwords don't match",
);

$mech->register_with_diff_pass("heh", "sophie - too short password");

# TEST
$mech->not_logged_in("Status says not logged #2 .");

# TEST
$mech->h1_is(
    "Registration failed - password is too short.",
    "reg failed - password is too short."
    );

# TEST
$mech->register_properly("sophie - Submit the form - should succeed now.");

# TEST
$mech->not_logged_in("Status says not logged-in #2 .");

# TODO : test that the user was registered properly.

# TEST
$mech->go_to_front();

# TEST
$mech->follow_link_ok({text => "Register a new account"}, 
    "Was able to follow the link to register (2nd time)."
);

# TEST
$mech->register_with_diff_pass(
    "FooBarasdmk--34t+536'Y", "Submit form with existing E-mail.",
);

# TEST
$mech->h1_is(
    "Registration failed - the email was already registered",
    "Registration failed - E-mail already registered."
);


# TEST
$mech->go_to_front();

# TEST
$mech->follow_link_ok({text => "Login to an existing account"},
    "Was able to follow the login link."
);

# TEST
$mech->h1_is("Login form", "Login page has an appropriate <h1> tag");

# TEST
$mech->submit_form_ok(
    {
        form_id => "login",
        fields =>
        {
            email => $email,
            password => "This-is-not-a-Password",
        },
    },
    "Submit form with the wrong password",
);

# TEST
$mech->h1_is(
    "Wrong Login or Incorrect Password", 
    "Could not login with incorrect password"
);

# TEST
$mech->submit_form_ok(
    {
        form_id => "login",
        fields =>
        {
            email => $email,
            password => $password,
        },
    },
    "Submit login form with the right password",
);

# TEST
$mech->h1_is("Login successful", "Login was successful (<h1>)");

# TEST
$mech->logged_in_as($email, "Now status shows logged in.");

# TEST
$mech->go_to_front();

# TEST
$mech->logged_in_as($email, "Status shows logged in in the front page.");

# TEST
$mech->follow_link_ok({text => "Logout",},
    "Was able to follow the logout link."
);

# TEST
$mech->h1_is("You are now logged-out", "Logged-out h1");

# TEST
$mech->not_logged_in("Status says not logged in after logout.");

# TEST
$mech->go_to_front();

# TEST
$mech->not_logged_in("Not logged in after visiting the front page.");

# TEST
$mech->follow_link_ok({text => "Login"},
    "Go to the login screen."
);

