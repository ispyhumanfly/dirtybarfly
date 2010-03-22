#!/usr/bin/env perl

use strict;
use warnings;

use InsurgentSoftware::UserAuth::User;
use InsurgentSoftware::UserAuth::App;

use Mojolicious::Lite;
use MojoX::Session::Cookie;

use CGI qw();

use KiokuDB;

# Silence
app->log->level('error');

my $dir = KiokuDB->connect(
    "dbi:SQLite:dbname=./insurgent-auth.sqlite",
    create => 1,
    columns =>
    [
        email =>
        {
            data_type => "varchar",
            is_nullable => 1,
        },
    ],
);


get '/' => sub {
    my $self = shift;

    return $self->render(
        template => "index",
        layout => 'insurgent',
        title => "Main",
    );
} => "index";

my $app = InsurgentSoftware::UserAuth::App->new(
    {
        dir => $dir,
    }
);

my %actions_params =
(
    'get' =>
    [
        ['/register/', "register",],
        ['/login/' , "login",],
        ['/account' , "account_page",],
    ],
    'post' =>
    [
        ['/register-submit/', "register_submit",],
        ['/login-submit/' , "login_submit",],
    ],
);

while (my ($verb, $actions) = each(%actions_params))
{
    foreach my $action (@$actions)
    {
        my ($url, $action_name) = @$action;

        __PACKAGE__->can($verb)->(
            $url => sub {
                my $controller = shift;
                return $app->with_mojo($controller, $action_name); 
            } => $action_name
        );
    }
}

sub logout
{
    my $self = shift;

    delete($self->session->{'login'});

    $self->render_text(
        "<h1>You are now logged-out</h1>\n",
        layout => 'insurgent',
        title => "You are now logged-out",
    );

    return;
}

get '/logout' => (\&logout) => "logout";

sub account_change_user_info_submit
{
    my $self = shift;
    
    my $app = InsurgentSoftware::UserAuth::App->new(
        {
            mojo => $self,
            dir => $dir,
        }
    );

    return $app->change_user_info_submit();
}

post '/account/change-info' => (\&account_change_user_info_submit)
=> "change_user_info_submit";

sub confirm_register
{
    my $self = shift;
    
    my $app = InsurgentSoftware::UserAuth::App->new(
        {
            mojo => $self,
            dir => $dir,
        }
    );

    return $app->confirm_register();
}

get '/confirm-register' => (\&confirm_register) => "confirm_register";

sub password_reset
{
    my $self = shift;
    
    my $app = InsurgentSoftware::UserAuth::App->new(
        {
            mojo => $self,
            dir => $dir,
        }
    );

    return $app->password_reset();
}

get '/password-reset' => (\&password_reset) => "password_reset";

sub password_reset_submit
{
    my $self = shift;

    my $app = InsurgentSoftware::UserAuth::App->new(
        {
            mojo => $self,
            dir => $dir,
        }
    );

    return $app->password_reset_submit();
}

post '/password-reset-submit' => (\&password_reset_submit) => "password_reset_submit";

sub handle_password_reset
{
    my $self = shift;

    my $app = InsurgentSoftware::UserAuth::App->new(
        {
            mojo => $self,
            dir => $dir,
        }
    );

    return $app->handle_password_reset(); 
}

get '/handle-password-reset' => (\&handle_password_reset) => "handle_password_reset";


sub handle_password_reset_submit
{
    my $self = shift;

    my $app = InsurgentSoftware::UserAuth::App->new(
        {
            mojo => $self,
            dir => $dir,
        }
    );

    return $app->handle_password_reset_submit(); 
}

post '/handle-password-reset-submit' => (\&handle_password_reset_submit) => "handle_password_reset_submit";

shagadelic;

=head1 TODO

* Make sure that there are limits to the properties of a user (maximal length
of E-mail, password, etc.).

* Add a confirmation reminder feature to re-send the confirmation E-mail.

* Add a way to cancel a registration using the E-mail (in case it's an unwanted
registration.)

=cut

__DATA__

@@ index.html.ep
% layout 'insurgent';
<h1>Insurgent Software's User Management Application</h1>

<ul>
% if ($self->session->{'login'}) {
<li><a href="<%= url_for('account_page') %>">Go to Your Account</a></li>
% } else {
<li><a href="<%= url_for('login') %>">Login to an existing account</a></li>
<li><a href="<%= url_for('register') %>">Register a new account</a></li>
% }
</ul>

@@ register.html.ep
% layout 'insurgent';
<h1>Register an account</h1>
<%== $register_form %>

@@ login.html.ep
% layout 'insurgent';
<h1>Login form</h1>
<%== $login_form %>

@@ account.html.ep
% layout 'insurgent';
<h1>Account page for <%= $email %></h1>

<h2 id="change_info">Change User Information</h2>

<%== $change_user_info_form %>

@@ password_reset.html.ep
% layout 'insurgent';
<h1>Reset Your Password</h1>

<p>
The form below allows you to reset your password. Please enter the E-mail
with which you registered.
</p>

<%== $password_reset_form %>

@@ handle_password_reset.html.ep
% layout 'insurgent';
<h1>Reset Your Password</h1>

<p>
The form below allows you to reset your password. Please enter your new
password.
</p>

<%== $handle_password_reset_form %>


@@ layouts/insurgent.html.ep
<!doctype html><html>
    <head>
    <title><%= $title %> - Insurgent-Auth</title>
    <link rel="stylesheet" href="/style.css" type="text/css" media="screen, projection" title="Normal" />
    </head>
    <body>
    <div id="status">
    <ul>
% if ($self->session->{'login'}) {
    <li><b>Logged in as <%= $self->session->{'login'} %></b></li>
    <li><a href="<%= url_for('account_page') %>">Account</a></li>
    <li><a href="<%= url_for('logout') %>">Logout</a></li>
% } else {
    <li><b>Not logged in.</b></li>
    <li><a href="<%= url_for('login') %>/">Login</a></li>
    <li><a href="<%= url_for('register') %>">Register</a></li>
% }
    <li><a href="<%= url_for('password_reset') %>">Password Reset</a></li>
    </ul>
    </div>
    <%== content %>
    </body>
</html>
