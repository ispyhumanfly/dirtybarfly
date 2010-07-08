package InsurgentSoftware::UserAuth::Catalyst::Controller::Auth;

use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller'; }

# Temporary - for :
    # use InsurgentSoftware::UserAuth::User;
    # use InsurgentSoftware::UserAuth::App;

use lib '../';

use InsurgentSoftware::UserAuth::User;
use InsurgentSoftware::UserAuth::App;

#
# Sets the actions in this controller to be registered with no prefix
# so they function identically to actions created in MyApp.pm
#
__PACKAGE__->config(namespace => '');

=head1 NAME

InsurgentSoftware::UserAuth::Catalyst::Controller::Auth - 
Root Controller for the authentication.

=head1 DESCRIPTION

[enter your description here]

=head1 METHODS

=head2 index

The root page (/)

=cut

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

sub index :Path('/auth') :Args(0) {
    my ( $self, $c ) = @_;

    # Hello World
    $c->stash->{template} = 'index.html.tt2';
    $c->stash->{title} = 'Main';

    return;
}

=head2 default

Standard 404 error page

=cut

sub default :Path {
    my ( $self, $c ) = @_;
    $c->response->body( 'Page not found' );
    $c->response->status(404);
}

=head2 end

Attempt to render a view, if needed.

=cut

sub end : ActionClass('RenderView') {}

=head1 AUTHOR

Catalyst developer

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
