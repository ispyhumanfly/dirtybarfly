package InsurgentSoftware::UserAuth::Catalyst::View::TT;

use strict;
use warnings;

use base 'Catalyst::View::TT';

use InsurgentSoftware::UserAuth::Catalyst;

__PACKAGE__->config(
    # Change default TT extension
    TEMPLATE_EXTENSION => '.tt2',
    # Set the location for TT files
    INCLUDE_PATH => [
    InsurgentSoftware::UserAuth::Catalyst->path_to( 'root', 'src' ),
    ],
    # WRAPPER => "wrapper.tt2",
);

=head1 NAME

InsurgentSoftware::UserAuth::Catalyst::View::TT - TT View for InsurgentSoftware::UserAuth::Catalyst

=head1 DESCRIPTION

TT View for InsurgentSoftware::UserAuth::Catalyst

=head1 SEE ALSO

L<InsurgentSoftware::UserAuth::Catalyst>

=head1 AUTHOR

Shlomi Fish, L<http://www.shlomifish.org/>

=head1 LICENSE

Based on L<App::Catable::View::TT>.

This module is distributed under the MIT/X11 License: 

L<http://www.opensource.org/licenses/mit-license.php>

=cut

1;


