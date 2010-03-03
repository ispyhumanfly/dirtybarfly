use Test::More tests => 3;
use Test::Mojo;

use FindBin;
require "$FindBin::Bin/../user-auth.pl";

my $t = Test::Mojo->new;

$t
    # TEST
    ->get_ok('/')
    # TEST
    ->status_is(200)
    # TEST
    ->content_like(qr{
    <li><a\ href="[^"]*\blogin/">Login\ to\ an\ existing\ account</a></li>\s+
    <li><a\ href="[^"]*\bregister/">Register\ a\ new\ account</a></li>
    }x);
