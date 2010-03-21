package InsurgentSoftware::UserAuth::User;

use Moose;
use InsurgentSoftware::UserAuth::UserExtraData;

use Crypt::SaltedHash;

use DateTime;

has fullname => (
    isa => "Str",
    is => "rw",
);

has email => (
    isa => "Str",
    is => "rw",
);

has salted_password => (
    isa => "Str",
    is => "rw",
);

has extra_data => (
    isa => "InsurgentSoftware::UserAuth::UserExtraData",
    is => "rw",
    default => sub {
        return InsurgentSoftware::UserAuth::UserExtraData->new()
    },
);

has confirmed => (
    isa => "Bool",
    is => "rw",
    default => 0,
);

has confirm_code => (
    isa => "Str",
    is => "rw",
);

has password_reset_code => (
    isa => "Maybe[Str]",
    is => "rw",
);

has last_confirmation_sent_at => (
    isa => "Maybe[DateTime]",
    is => "rw",
);

has last_password_reset_sent_at => (
    isa => "Maybe[DateTime]",
    is => "rw",
);

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

sub BUILD
{
    my ($self, $params) = @_;

    $self->assign_password($params->{password});

    return;
}

sub verify_password
{
    my $self = shift;
    my $pass = shift;

    return Crypt::SaltedHash->validate($self->salted_password(), $pass, 
        __PACKAGE__->get_salt_len());
}

sub get_salt_len
{
    return 8;
}

1;
