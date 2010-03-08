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
            is_nullable => 0,
        },
    ],
);


get '/' => 'index';

get '/register/' => sub {
    my $self = shift;
    
    my $app = InsurgentSoftware::UserAuth::App->new(
        {
            mojo => $self,
            dir => $dir,
        }
    );

    return $app->register();

};

sub register_submit
{
    my $self = shift;

    my $app = InsurgentSoftware::UserAuth::App->new(
        {
            mojo => $self,
            dir => $dir,
        }
    );

    return $app->register_submit();
}

post '/register-submit/' => \&register_submit;

get '/login/' => sub {
    my $self = shift;
    
    my $app = InsurgentSoftware::UserAuth::App->new(
        {
            mojo => $self,
            dir => $dir,
        }
    );

    return $app->login();
};

sub login_submit
{
    my $self = shift;

    my $app = InsurgentSoftware::UserAuth::App->new(
        {
            mojo => $self,
            dir => $dir,
        }
    );

    return $app->login_submit();
}

post '/login-submit/' => \&login_submit;

sub logout
{
    my $self = shift;

    delete($self->session->{'login'});

    $self->render_text(
        "<h1>You are now logged-out</h1>\n",
        layout => 'funky',
    );

    return;
}

get '/logout' => (\&logout) => "logout";

shagadelic;

=head1 TODO

* Add a status (Not logged-in / Logged in as something) ruler to the top.

=cut

__DATA__

@@ index.html.ep
% layout 'funky';
<h1>Insurgent Software's User Management Application</h1>

<ul>
<li><a href="login/">Login to an existing account</a></li>
<li><a href="register/">Register a new account</a></li>
</ul>

@@ register.html.ep
% layout 'funky';
<h1>Register an account</h1>
<%== $register_form %>

@@ login.html.ep
% layout 'funky';
<h1>Login form</h1>
<%== $login_form %>

@@ layouts/funky.html.ep
<!doctype html><html>
    <head>
    <title>Insurgent Software's User Management Application</title>
    <link rel="stylesheet" href="/style.css" type="text/css" media="screen, projection" title="Normal" />
    </head>
    <body>
    <div id="status">
    <ul>
% if ($self->session->{'login'}) {
    <li><b>Logged in as <%= $self->session->{'login'} %></b></li>
    <li><a href="<%= url_for('logout') %>">Logout</a></li>
% } else {
    <li><b>Not logged in.</b></li>
    <li><a href="/login/">Login</a></li>
    <li><a href="/register/">Register</a></li>
% }
    </ul>
    </div>
    <%== content %>
    </body>
</html>
