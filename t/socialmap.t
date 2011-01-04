use Test::More tests => 3;
use Test::Mojo;

use FindBin;
$ENV{MOJO_HOME} = "$FindBin::Bin/../";
require "$ENV{MOJO_HOME}/konekt";

my $t = Test::Mojo->new;
$t->get_ok('/')->status_is(200)->content_like(qr/Konekt/);
