package InsurgentSoftware::UserAuth::Catalyst::Controller::Auth;

use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller'; }

# Temporary - for :
    # use InsurgentSoftware::UserAuth::User;
    # use InsurgentSoftware::UserAuth::App;

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

=head2 begin

Global initialisation for this controller.

=cut

sub begin :Private {
    my ($self, $c) = @_;

    $c->stash->{app} =
        InsurgentSoftware::UserAuth::App->new(
            {
                dir => $c->model('KiokuDB')->directory(),
            }
        );

    return;
}

sub _with_mojo {
    my ($self, $c, $action) = @_;

    return $c->stash->{app}->with_mojo($c,$action);
}

=head2 index

The root page (/)

=cut

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;

    # Hello World
    $c->stash->{template} = 'index.html.tt2';
    $c->stash->{title} = 'Main';

    return;
}

=head2 register

Registration form handler.

=cut

sub register :Local {
    my ( $self, $c ) = @_;

    return $self->_with_mojo($c, 'register');
}

=head2 confirm_register

Confirm a registration.

=cut

sub confirm_register :Path('confirm-register') {
    my ( $self, $c ) = @_;

    return $self->_with_mojo($c, 'confirm_register');
}

=head2 login

Login handler.

=cut

sub login :Path('/login') {
    my ($self, $c ) = @_;

    return $self->_with_mojo($c, 'login');
}

=head2 logout

Logout handler.

=cut

sub logout :Path('/logout') {
    my ($self, $c ) = @_;

    $c->logout();

    $c->stash->{template} = 'render_text.html.tt2';
    $c->stash->{template_text} = "<h1>You are now logged-out</h1>\n";
    $c->stash->{title} = 'You are now logged-out';

    return;
}

=head2 account_page()

Handler for the account page.

=cut

sub account_page :Path('/account') {
    my ($self, $c) = @_;

    return $self->_with_mojo($c, 'account_page');
}

=head2 password_reset

Reset a password handler.

=cut

sub password_reset :Path('/password-reset') {
    my ($self, $c) = @_;

    return $self->_with_mojo($c, 'password_reset');
}

=head2 handle_password_reset

Handle a password reset.

=cut

sub handle_password_reset :Path('/handle-password-reset') {
    my ($self, $c) = @_;

    return $self->_with_mojo($c, 'handle_password_reset');
}

=head2 password_reset_submit

Password reset submit.

=cut

sub password_reset_submit :Path('/password-reset-submit') {
    my ($self, $c) = @_;

    return $self->_with_mojo($c, 'password_reset_submit');
}

=head2 handle_password_reset_submit

Submit the handle password reset.

=cut

sub handle_password_reset_submit :Path('/handle-password-reset-submit') {
    my ($self, $c) = @_;

    return $self->_with_mojo($c, 'handle_password_reset_submit');
}

=head2 register_submit

Submit the registration form.

=cut

sub register_submit :Path('/register-submit/') {
    my ($self, $c) = @_;

    return $self->_with_mojo($c, 'register_submit');
}

=head2 login_submit

Submit a login handler.

=cut

sub login_submit :Path('/login-submit/') {
    my ($self, $c) = @_;

    return $self->_with_mojo($c, 'login_submit');
}

=head2 change_user_info_submit

Handler for the submission of change_user_info.

=cut

sub change_user_info_submit :Path('/account/change-info') {
    my ($self, $c) = @_;

    return $self->_with_mojo($c, 'change_user_info_submit');
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
