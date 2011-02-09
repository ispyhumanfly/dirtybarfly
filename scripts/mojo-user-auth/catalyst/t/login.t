#!perl


use strict;
use warnings;

use InsurgentSoftware::MockEmailSender;

package MyTest::Mech;

use strict;
use warnings;

use Test::WWW::Mechanize::LibXML;
use Test::WWW::Mechanize::Catalyst;

use Moose;

extends (qw(Test::WWW::Mechanize::Catalyst Test::WWW::Mechanize::LibXML Moose::Object));

use Test::More;

sub _update_page
{
    my $self = shift;

    my $ret = $self->Test::WWW::Mechanize::Catalyst::_update_page(@_);
    $self->Test::WWW::Mechanize::LibXML::_update_page(@_);

    return $ret;
}

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

sub change_password
{
    my ($self, $pass) = @_;

    return $self->_active_user->set_new_password($pass);
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

# TODO : test that the user was registered properly.
# TEST:$c=0;
sub test_email
{
    my $mech = shift;
    my $url_ref = shift;
    my $blurb_base = shift;

    my $email_msg = Email::Sender::Simple::shift_email();

    my $url;
    my $ok = 1;

    # TEST:$c++;
    $ok = ok($email_msg, "$blurb_base - Email was sent.") && $ok;

    ($url) =
    ($email_msg->body() =~ 
        m{Go to the following URL:\r?\n\r?\n(https?:[^\n\r]*)\r?\n}ms
    );

    my $email1 = $mech->email();
    $email1 =~ s{\@}{%40};

    # TEST:$c++;
    $ok = like ($url, qr{email=\Q$email1\E}, "Got URL") && $ok;

    ${$url_ref} = $url;

    return $ok;
}
# TEST:$test_email=$c;


# TEST:$c=0;
sub register_with_confirmation
{
    my $mech = shift;
    my $blurb_base = shift;

    # local $Test::Builder::Level = $Test::Builder::Level + 1;

    # TEST:$c++;
    $mech->register_properly("$blurb_base - Submit the form - should succeed now.");

    # TEST:$c++;
    $mech->not_logged_in("$blurb_base - Status says not logged-in #2 .");

    # TEST:$c++;
    $mech->go_to_front();
    
    # TEST:$c++;
    $mech->follow_link_ok({text => "Register a new account"}, 
        "Was able to follow the link to register (2nd time)."
    );

    # TEST:$c++;
    $mech->register_with_diff_pass(
        "FooBarasdmk--34t+536'Y", "$blurb_base - Submit form with existing E-mail.",
    );

    # TEST:$c++;
    $mech->h1_is(
        "Registration failed - the email was already registered",
        "$blurb_base - Registration failed - E-mail already registered."
    );

    my $url;
    # TEST:$c=$c+$test_email
    $mech->test_email(\$url, "$blurb_base - Email");

    # TEST:$c++;
    $mech->go_to_front();

    # TEST:$c++;
    $mech->follow_link_ok({text => "Login to an existing account"},
        "Was able to follow the login link."
    );

    # TEST:$c++;
    $mech->h1_is("Login form", "Login page has an appropriate <h1> tag");

    # TEST:$c++;
    $mech->login_properly("Sophie login without confirmation.");

    # TEST:$c++;
    $mech->h1_is("You need to confirm first.", "Confirm first.");

    # TEST:$c++;
    $mech->get_ok($url, "$blurb_base - get confirmation.");

    # TEST:$c++;
    $mech->h1_is("Confirmed " . $mech->email(), 
        "$blurb_base - confirmed sophie's URL."
    );

    # TEST:$c++;
    $mech->go_to_front();

    # TEST:$c++;
    $mech->follow_link_ok({text => "Login to an existing account"},
        "Was able to follow the login link."
    );

    return 1;
}

# TEST:$register_with_confirmation=$c;

package MyTest::Mech::User;

use Moose;

has id => (isa => "Str", is => "ro");
has fullname => (isa => "Str", is => "ro");
has email => (isa => "Str", is => "ro");
has password => (isa => "Str", is => "rw");
has wrong_pass => (isa => "Str", is => "rw");

sub set_new_password
{
    my ($self, $pass) = @_;
    
    $self->password($pass);

    return;
}

package main;

use strict;
use warnings;

BEGIN
{
    # Reset the database.
    unlink("insurgent-auth.sqlite");
}

use Test::More tests => 118;

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

my $mech = MyTest::Mech->new(
    catalyst_app => 'InsurgentSoftware::UserAuth::Catalyst',
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
$mech->content_like(qr{
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

# TEST
$mech->register_with_diff_pass("heh", "sophie - too short password");

# TEST
$mech->not_logged_in("Status says not logged #2 .");

# TEST
$mech->h1_is(
    "Registration failed - password is too short.",
    "reg failed - password is too short."
    );

# TEST*$register_with_confirmation
$mech->register_with_confirmation("sophie");

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

$mech->select_user("jack");

# TEST*$register_with_confirmation
$mech->register_with_confirmation("jack - registered");

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

# TEST
$mech->follow_link_ok({text => "Password Reset"}, 
    "Could follow Password Reset OK."
);

# TEST
$mech->submit_form_ok(
    {
        form_id => "password_reset",
        fields =>
        {
            email => $mech->email(),
        },
    },
    "Submitted Password Reset Form",
);

my $new_sophie_pass = "F8nv[-=;KnT9nvlknsvsdv";

{
    my $pass_reset_url;
    # TEST*$test_email
    $mech->test_email(\$pass_reset_url,  "Sophie - password reset");

    # TEST*$logout_count
    $mech->logout_with_checks("sophie #3");

    # TEST
    $mech->get_ok($pass_reset_url, "Sophie - resetting password");

    # TEST
    $mech->submit_form_ok(
        {
            form_id => "handle_password_reset",
            fields =>
            {
                password => $new_sophie_pass,
                password2 => $new_sophie_pass,
            },
        },
        "Sophie - handle reset password",
    );

    $mech->change_password($new_sophie_pass);

    # TEST
    $mech->follow_link_ok({text => "Login"}, "Sophie after change pass login.");

    # TEST
    $mech->login_properly("Sophie after change pass login properly.");
}
