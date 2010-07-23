use strict;
use warnings;
use Module::Build;

my $builder = Module::Build->new(
    module_name         => 'WWW::Mechanize::LibXML',
    license             => 'mit',
    dist_author         => q{Shlomi Fish <shlomif@insurgentsoftware.com>},
    dist_version_from   => 'lib/WWW/Mechanize/LibXML.pm',
    build_requires => {
        'Test::More' => 0,
    },
    add_to_cleanup      => [ 'WWW-Mechanize-LibXML-*' ],
    create_makefile_pl => 'traditional',
);

$builder->create_build_script();
