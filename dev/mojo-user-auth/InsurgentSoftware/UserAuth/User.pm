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

sub verify_password
{
    my $self = shift;
    my $pass = shift;

    return ($self->password() eq $pass);
}

1;
