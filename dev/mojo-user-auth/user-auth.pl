#!/usr/bin/env perl

use strict;
use warnings;

package InsurgentSoftware::UserAuth::User;

use Moose;

has fullname => (
    isa => "Str",
    is => "rw",
);

has email => (
    isa => "Str",
    is => "rw",
);

has password => (
    isa => "Str",
    is => "rw",
);

package InsurgentSoftware::UserAuth::App;

use Moose;

has _mojo => (
    isa => "Mojolicious::Controller",
    is => "ro",
    init_arg => "mojo",
    handles =>
    {
        "param" => "param",
        render_text => "render_text",
        render => "render",
    },
);

has _dir => (
    isa => "KiokuDB",
    is => "ro",
    init_arg => "dir",
);

sub render_failed_reg
{
    my $self = shift;

    my $header = shift;
    my $explanation = shift || "";

    $self->render_text(
        sprintf("<h1>%s</h1>%s%s",
            $header, $explanation, 
            $self->register_form(
                +{ map { $_ => $self->param($_) } qw(email fullname) }
            )
        ),
        layout => 'funky',
    );

    return;
}

sub too_short
{
    my $p = shift;

    return (($p =~ s/[\w\d]//g) < 6);
}

sub register_form
{
    my $self = shift;
    my $args = shift;

    my $email = CGI::escapeHTML($args->{'email'} || "");
    my $fullname = CGI::escapeHTML($args->{'fullname'} || "");

    return <<"EOF";
<form id="register" action="/register-submit/" method="post">
<table>

<tr>
<td>Email:</td>
<td><input name="email" value="$email" /></td>
</tr>

<tr>
<td>Password:</td>
<td><input name="password" type="password" /></td>
</tr>

<tr>
<td>Password (confirmation):</td>
<td><input name="password2" type="password" /></td>
</tr>

<tr>
<td>Full name (optional):</td>
<td><input name="fullname" value="$fullname" /></td>
</tr>

<tr>
<td colspan="2">
<input type="submit" value="Submit" />
</td>
</tr>

</table>
</form>
EOF
}

sub register_submit
{
    my $self = shift;

    my $dir = $self->_dir;

    my $password = $self->param("password");

    my $render_reg_failed = sub {
        return $self->render_failed_reg(@_);
    };

    if ($password ne $self->param("password2"))
    {
        return $render_reg_failed->(
            "Registration failed - passwords don't match."
        );
    }

    if (too_short($password))
    {
        return $render_reg_failed->(
             "Registration failed - password is too short.",
             <<"EOF",
<p>
The password must contain at least 6 alphanumeric (A-Z, a-z, 0-9) characters.
</p>
EOF
        );
    }

    my $scope = $dir->new_scope;

    my $email = $self->param("email");

    my $find_if_email_exists = sub {
        my $stream = $dir->search({email => $email});

        FIND_EMAIL:
        while ( my $block = $stream->next )
        {
            foreach my $object ( @$block )
            {
                return 1;
            }
        }

        return;
    };
    
    if ($find_if_email_exists->())
    {
        return $render_reg_failed->(
            "Registration failed - the email was already registered",
            "The email " . CGI::escapeHTML($email) . " already exists in our database.",
        );
    }

    # Register a new user.
    my $new_user = InsurgentSoftware::UserAuth::User->new(
        {
            fullname => $self->param("fullname"),
            # TODO : don't store the password as plaintext.
            password => $password,
            email => $email,
        }
    );

    $dir->store($new_user);

    $self->render_text("You registered the E-mail - " .
        CGI::escapeHTML($email),
        layout => 'funky',
    );
}

sub register
{
    my $self = shift;

    return $self->render(
        template => "register",
        layout => 'funky',
        register_form => $self->register_form({}),
    );
}

package main;

use Mojolicious::Lite;
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

get '/:groovy' => sub {
    my $self = shift;
    $self->render_text($self->param('groovy'), layout => 'funky');
};

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

@@ layouts/funky.html.ep
<!doctype html><html>
    <head><title>Insurgent Software's User Management Application</title></head>
    <body><%== content %></body>
</html>
