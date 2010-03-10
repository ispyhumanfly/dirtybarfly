package InsurgentSoftware::UserAuth::User;

use Moose;
use InsurgentSoftware::UserAuth::UserExtraData;

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

has extra_data => (
    isa => "InsurgentSoftware::UserAuth::UserExtraData",
    is => "rw",
    default => sub {
        return InsurgentSoftware::UserAuth::UserExtraData->new()
    },
);

sub verify_password
{
    my $self = shift;
    my $pass = shift;

    return ($self->password() eq $pass);
}

1;
