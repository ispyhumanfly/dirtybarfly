#!/usr/bin/env perl

use Mojolicious::Lite;

get '/' => 'index';

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

@@ layouts/funky.html.ep
<!doctype html><html>
    <head><title>Insurgent Software's User Management Application</title></head>
    <body><%== content %></body>
</html>
