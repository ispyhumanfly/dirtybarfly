#!perl -T

use Test::More tests => 1;

BEGIN {
    use_ok( 'WWW::Mechanize::LibXML' );
}

diag( "Testing WWW::Mechanize::LibXML $WWW::Mechanize::LibXML::VERSION, Perl $], $^X" );
