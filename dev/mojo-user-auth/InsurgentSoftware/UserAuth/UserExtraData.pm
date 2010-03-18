package InsurgentSoftware::UserAuth::UserExtraData;

use Moose;

has bio => (
    isa => "Str",
    is => "rw",
);

1;
