#!/usr/bin/env perl

use Mojolicious::Lite;
use CGI qw();


sub register_form
{
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

    if ($self->param("password") ne $self->param("password2"))
    {
        $self->render_text(
            (
                  "<h1>"
                . "Registration failed - passwords don't match."
                . "</h1>\n"
                . register_form(
                    +{ map { $_ => $self->param($_) } qw(email fullname) }
                  )
            ),
            layout => 'funky',
        );
        return;
    }

    $self->render_text("You registered the E-mail - " . 
        CGI::escapeHTML($self->param("email")),
        layout => 'funky',
    );
}

get '/' => 'index';

get '/register/' => sub {
    my $self = shift;

    $self->render(
        template => "register",
        layout => 'funky',
        register_form => register_form({}),
    );
};

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
