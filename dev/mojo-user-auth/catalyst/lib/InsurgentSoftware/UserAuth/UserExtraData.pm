package InsurgentSoftware::UserAuth::UserExtraData;

use Moose;

=head1 NAME 

InsurgentSoftware::UserAuth::UserExtraData - place holder for the user extra
data of the application.

=head1 METHODS

=head2 bio

A long string containing the bio of the user. Just for demonstration purposes.

=cut

has bio => (
    isa => "Str",
    is => "rw",
);

=head1 AUTHOR

Shlomi Fish, L<http://www.shlomifish.org/> ( L<shlomif@insurgentsoftware.com> ).

=head1 LICENSE

Copyright by Insurgent Software.

=cut

1;
