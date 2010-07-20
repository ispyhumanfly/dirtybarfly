# This file is under the MIT X11 License:
# http://www.opensource.org/licenses/mit-license.php

use strict;
use warnings;

use File::Spec;
use lib File::Spec->catdir(File::Spec->curdir(), "MB-inc");

use Test::Run::Builder;

my $build = Test::Run::Builder->new(
    module_name => "InsurgentSoftware::UserAuth::Catalyst",
    build_requires =>
    {
        "HTML::Lint" => 0,
        "Test::Trap" => 0,
        "Test::WWW::Mechanize::Catalyst" => 0,
    },
    requires => 
    {
        'Catalyst::Action::RenderView' => 0,
        'Catalyst::Authentication::Store::DBIx::Class' => 0,
        'Catalyst::Controller::HTML::FormFu' => 0,
        'Catalyst::Model::KiokuDB' => 0,
        'Catalyst::Plugin::Authentication' => '0.03',
        'Catalyst::Plugin::Authorization::Roles' => 0,
        'Catalyst::Plugin::ConfigLoader' => 0,
        'Catalyst::Plugin::Session' => 0,
        'Catalyst::Plugin::Session::State::Cookie' => 0,
        'Catalyst::Plugin::Session::Store::FastMmap' => 0,
        'Catalyst::Plugin::StackTrace' => 0,
        'Catalyst::Plugin::Static::Simple' => 0,
        'Catalyst::Runtime' => '5.80022',
        'Catalyst::View::TT' => 0,
        'CGI' => 0,
        'Data::UUID' => 0,
        'Digest' => 0,
        'Email::Sender::Simple' => 0,
        'Email::Simple' => 0,
        'Email::Simple::Creator' => 0,
        'HTML::Scrubber' => 0.08,
        'KiokuDB' => 0,
        'KiokuX::User' => 0,
        'KiokuX::User::Util' => 0,
        'Moose' => 0,
        'URI::Escape' => 0,
        'YAML' => 0,
    },
    license => "mit",
    # Commenting out so we'll have the catalyst.pl-generated M::I-base
    # Makefile.PL for safe-keeping.
    # create_makefile_pl => 'traditional',
    script_files => glob("script/*.pl"),
);

$build->create_build_script;

