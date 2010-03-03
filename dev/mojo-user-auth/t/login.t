use Test::More tests => 3;
use Test::Mojo;
use Test::WWW::Mechanize::Mojo;

use FindBin;
require "$FindBin::Bin/../user-auth.pl";

my $t = Test::Mojo->new;
my $mech = Test::WWW::Mechanize::Mojo->new(tester => $t);

# TEST
$mech->get_ok("/", "Got the page ok.");

# TEST
is ($mech->status(), 200, "Status is 200 for Root");

# TEST
$t->content_like(qr{
    <li><a\ href="[^"]*\blogin/">Login\ to\ an\ existing\ account</a></li>\s+
    <li><a\ href="[^"]*\bregister/">Register\ a\ new\ account</a></li>
    }x);


