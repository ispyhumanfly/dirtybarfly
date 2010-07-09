package InsurgentSoftware::UserAuth::User;

use Moose;
use InsurgentSoftware::UserAuth::UserExtraData;

use Crypt::SaltedHash;

use DateTime;

=head1 NAME 

InsurgentSoftware::UserAuth::User - a class representing the user-data.

=head1 METHODS

=head2 $user->fullname()

The fullname of the user.

=cut

has fullname => (
    isa => "Str",
    is => "rw",
);

=head2 $user->email()

The email address of the user.

=cut

has email => (
    isa => "Str",
    is => "rw",
);

=head2 $self->salted_password()

The salted password.

=cut

has salted_password => (
    isa => "Str",
    is => "rw",
);

=head2 $self->extra_data()

The associated InsurgentSoftware::UserAuth::UserExtraData .

=cut

has extra_data => (
    isa => "InsurgentSoftware::UserAuth::UserExtraData",
    is => "rw",
    default => sub {
        return InsurgentSoftware::UserAuth::UserExtraData->new()
    },
);

=head2 $user->confirmed()

Whether the user was confirmed or not.

=cut

has confirmed => (
    isa => "Bool",
    is => "rw",
    default => 0,
);

=head2 $user->confirm_code()

The confirmation code.

=cut

has confirm_code => (
    isa => "Str",
    is => "rw",
);

=head2 $user->password_reset_code()

The password reset code.

=cut

has password_reset_code => (
    isa => "Maybe[Str]",
    is => "rw",
);

=head2 $self->last_confirmation_sent_at()

The L<DateTime> of the last confirmation sent.

=cut

has last_confirmation_sent_at => (
    isa => "Maybe[DateTime]",
    is => "rw",
);

=head2 $self->last_password_reset_sent_at()

The L<DateTime> of the last password reset sent.

=cut

has last_password_reset_sent_at => (
    isa => "Maybe[DateTime]",
    is => "rw",
);

=head2 $user->assign_password($password)

Assign the password $password to the user.

=cut

sub assign_password
{
    my ($self, $password) = @_;

    my $csh = Crypt::SaltedHash->new(
        algorithm => 'SHA-256',
        salt_len => __PACKAGE__->get_salt_len(),
    );
    $csh->add($password);

    my $salted = $csh->generate;
    
    $self->salted_password($salted);

    return;
}

=head2 BUILD()

Catalyst stuff.

=cut

sub BUILD
{
    my ($self, $params) = @_;

    $self->assign_password($params->{password});

    return;
}

=head2 $self->verify_password($password)

Verify that the password is $password .

=cut

sub verify_password
{
    my $self = shift;
    my $pass = shift;

    return Crypt::SaltedHash->validate($self->salted_password(), $pass, 
        __PACKAGE__->get_salt_len());
}

=head2 $self->get_salt_len()

Returns the salt length for the password.

=cut

sub get_salt_len
{
    return 8;
}

1;
