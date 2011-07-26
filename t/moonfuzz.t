use Test::More tests => 3;
use Test::Mojo;

use FindBin;
$ENV{MOJO_HOME} = "$FindBin::Bin/../";
require "$ENV{MOJO_HOME}/konekt";

use Test::WWW::Mechanize::Mojo;

  my $tester = Test::Mojo->new();

  # To test a Mojo application 
  my $mech = Test::WWW::Mechanize::Mojo->new(tester => $tester);

  $mech->get_ok("/"); # no hostname needed
  is($mech->ct, "text/html");
  $mech->title_is("Root", "On the root page");
  $mech->content_contains("This is the root page", "Correct content");
  $mech->follow_link_ok({text => 'Hello'}, "Click on Hello");
  # ... and all other Test::WWW::Mechanize methods
  
  # White label site testing
  $mech->host("foo.com");
  $mech->get_ok("/");