#!perl

package MyTest::Mech::LibXML;

use strict;
use warnings;

use InsurgentSoftware::MockEmailSender;

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
        'email' => "email",
        '_password' => "password",
        '_fullname' => "fullname",
    },
);

sub get_user_pass
{
    my $self = shift;
    my $uid = shift;

    return $self->_get_user($uid)->password;
}

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

sub user_logged_in
{
    local $Test::Builder::Level = $Test::Builder::Level + 1;

    my ($self, $blurb) = @_;

    return $self->logged_in_as($self->_email(), $blurb);
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

sub _get_user
{
    my ($self, $uid) = @_;

    if (!exists($self->_users->{$uid}))
    {
        die "Could not find user '$uid'!";
    }

    return $self->_users->{$uid};
}

sub select_user
{
    my ($self, $uid) = @_;

    $self->_active_user($self->_get_user($uid));

    return;
}

sub register_generic
{
    my ($self, $fields, $blurb) = @_;

    local $Test::Builder::Level = $Test::Builder::Level + 1;

    return $self->submit_form_ok(
        {
            form_id => "register",
            fields =>
            {
                email => $fields->{email},
                password => $fields->{password},
                password2 => $fields->{password2},
                fullname => $fields->{fullname},
            },
        },
        $blurb,
    );
}

sub _register_with_passwords
{
    my ($self, $p1, $p2, $blurb) = @_;

    local $Test::Builder::Level = $Test::Builder::Level + 1;

    return $self->register_generic(
        {
            email => $self->_email(),
            password => $p1,
            password2 => $p2,
            fullname => $self->_fullname(),
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

sub login_with_pass
{
    my ($self, $pass, $blurb) = @_;

    local $Test::Builder::Level = $Test::Builder::Level + 1;

    return $self->submit_form_ok(
        {
            form_id => "login",
            fields =>
            {
                email => $self->_email,
                password => $pass,
            },
        },
        $blurb,
    );
}

sub login_properly
{
    my ($self, $blurb) = @_;

    local $Test::Builder::Level = $Test::Builder::Level + 1;

    return $self->login_with_pass($self->_password(), $blurb);
}

# TEST:$c=0;
sub logout_with_checks
{
    my ($mech, $blurb_base) = @_;

    local $Test::Builder::Level = $Test::Builder::Level + 1;

    my $num_fails = 0;
    # TEST:$c++;
    $mech->follow_link_ok({text => "Logout",},
        "$blurb_base - Was able to follow the logout link."
    ) or $num_fails++;

    # TEST:$c++;
    $mech->h1_is("You are now logged-out", "$blurb_base - Logged-out h1")
        or $num_fails++;

    # TEST:$c++;
    $mech->not_logged_in(
        "$blurb_base - Status says not logged in after logout."
    ) or $num_fails++;

    # TEST:$c++
    $mech->title_is("You are now logged-out - Insurgent-Auth",
        "You are now logged out title."
    ) or $num_fails++;

    return ($num_fails == 0);
}

# TEST:$logout_count=$c;

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

use Test::More tests => 85;
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
$mech->title_is("Main - Insurgent-Auth", "Title for main page is OK.");

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

# TEST
$mech->tree_matches_xpath(
    q{//form[@id='register']//input[@name='email']},
    "There is an email input.",
);

# TEST
$mech->tree_matches_xpath(
    q{//form[@id='register']//input[@name='password' and @type='password']},
    "There is a password input.",
);

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
{
    my $email = Email::Sender::Simple::shift_email();

    # TEST
    ok($email, "Email was sent.");


}

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
$mech->login_with_pass(
    "This-is-not-a-Password", "Submit form with the wrong password"
);

# TEST
$mech->h1_is(
    "Wrong Login or Incorrect Password", 
    "Could not login with incorrect password"
);

# TEST
$mech->login_properly("Submit login form with the right password");

# TEST
$mech->h1_is("Login successful", "Login was successful (<h1>)");

# TEST
$mech->user_logged_in("Now status shows logged in.");

# TEST
$mech->go_to_front();

# TEST
$mech->content_unlike(qr{Login|Register}i,
    "No links to login or register when logged-in."
);

# TEST
$mech->user_logged_in("Status shows logged in in the front page.");

# TEST*$logout_count
$mech->logout_with_checks("sophie");

# TEST
$mech->go_to_front();

# TEST
$mech->not_logged_in("Not logged in after visiting the front page.");

# TODO : abstract into the go-to-register screen function. 

# TEST
$mech->follow_link_ok({text => "Register a new account"}, 
    "Was able to follow the link to register."
);

# TEST
$mech->select_user("jack");

# TEST
$mech->register_properly("jack - registered");

# TEST
$mech->follow_link_ok({text => "Login"},
    "Was able to follow the login link."
);

# TEST
$mech->login_with_pass('Foobarmv8n3@#%VaSDV@VA', "jack - wrong pass");

# TEST
$mech->h1_is(
    "Wrong Login or Incorrect Password", 
    "jack - could not login with incorrect password"
);

# TEST
$mech->login_properly("jack - login properly.");

# TEST
$mech->user_logged_in("jack is logged in.");

# TEST
$mech->go_to_front();

# TEST
$mech->user_logged_in("jack is logged in in the front page.");

# TEST*$logout_count
$mech->logout_with_checks("jack #1");

# TEST
$mech->follow_link_ok({text => "Login"},
    "Was able to follow the login link."
);

# TEST
$mech->login_with_pass($mech->get_user_pass('sophie'), 
    "jack - login using Sophie's password");

# TEST
$mech->h1_is(
    "Wrong Login or Incorrect Password", 
    "jack - could not login with Sophie's password"
);

$mech->select_user("sophie");

# TEST
$mech->login_properly("sophie #2 - login proprely");

# TEST
$mech->tree_matches_xpath(
    q{//div[@id='status']//a[contains(text(), 'Account')]},
    "sophie #2 - contains a link to the account.",
);

# TEST
$mech->follow_link_ok({text => "Account"}, 
    "sophie #2 - follow link to account."
);

# TEST
$mech->html_lint_ok ("Account page is valid.");

# TEST
$mech->h1_is(
    "Account page for " . $mech->email(),
    "sophie #2 - Account page",
);

# TEST
$mech->tree_matches_xpath(
    q{//form[@id='change_user_info']//input[@name='fullname' and @value='Sophie Esmeralda Johnson']},
    "sophie #2 - fullname input contains the name",
);

# TEST
$mech->submit_form_ok(
    {
        form_id => "change_user_info",
        fields =>
        {
            fullname => "Sophie Clarissa Levi",
            bio => "My name is Sophie, and I like cats. Meow, meow!",
        }
    }
);

# TEST
$mech->follow_link_ok({text => "Return to your account"},
    "sophie #2 - return to the account."
);

# TEST
$mech->tree_matches_xpath(
    q{//form[@id='change_user_info']//input[@name='fullname' and @value='Sophie Clarissa Levi']},
    "sophie #2 - fullname input contains the new name",
);

# TEST
$mech->tree_matches_xpath(
    q{//form[@id='change_user_info']//textarea[@name='bio' and contains(text(), 'My name is Sophie, and I like cats')]},
    "sophie #2 - bio textarea contains the new bio",
);

# TEST*$logout_count
$mech->logout_with_checks("sophie #2");

# TEST
$mech->follow_link_ok({text => "Register"},
    "Followed the link to the registration."
);

# TEST
$mech->register_generic(
    {
        email => 'shlomif@' . ("iglu." x 1000) . ".org.il",
        password => "FooBarBazZadoom",
        password2 => "FooBarBazZadoom",
        fullname => "Shlomi Fish",
    },
    "Register with too long email.",
);

# TEST
$mech->h1_is(
    "Registration failed - E-mail is too long",
    "Registration failed - E-mail is too long."
);

# TEST
$mech->register_generic(
    {
        email => 'shlomif@iglu.org.il',
        password => ("FooBarBazZadoom" x 500),
        password2 => ("FooBarBazZadoom" x 500),
        fullname => "Shlomi Fish",
    },
    "Register with too long email.",
);

# TEST
$mech->h1_is(
    "Registration failed - password is too long",
    "Registration failed - Password is too long."
);

# TEST
$mech->register_generic(
    {
        email => 'shlomif@iglu.org.il',
        password => "FooBarBazZadoom",
        password2 => "FooBarBazZadoom",
        fullname => ("Stanislav Glorificianda Cassandra Jay " x 200),
    },
    "Register with too long email.",
);

# TEST
$mech->h1_is(
    "Registration failed - the full name is too long",
    "Registration failed - Full name is too long."
);

$mech->select_user("sophie");

# TEST
$mech->go_to_front();

# TEST
$mech->follow_link_ok({text => "Login"},
    "sophie #3 - was able to follow the login link."
);

# TEST
$mech->login_properly("sophie #3 - login proprely");


# TEST
$mech->follow_link_ok({text => "Account"}, 
    "sophie #3 - follow link to account."
);

# TEST
$mech->submit_form_ok(
    {
        form_id => "change_user_info",
        fields =>
        {
            fullname => ("Sophie Clarissa Levi" x 250),
            bio => "My name is Sophie, and I like cats. Meow, meow!",
        }
    }
);

# TEST
$mech->h1_is(
    "Error - the full name is too long",
    "Error - the full name is too long",
);

# TEST
$mech->submit_form_ok(
    {
        form_id => "change_user_info",
        fields =>
        {
            fullname => "Sophie Melinda Proofer",
            bio => ("My name is Sophie, and I like cats. Meow, meow!" x 2000),
        }
    }
);

# TEST
$mech->h1_is(
    "Error - the bio is too long",
    "Error - the bio is too long",
);

