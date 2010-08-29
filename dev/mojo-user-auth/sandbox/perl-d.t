#!perl

package User;

use Moose;

has email => (
    isa => "Str",
    is => "rw",
);

package main;

use KiokuDB;
use KiokuDB::TypeMap::Entry::MOP;

use strict;
use warnings;

my $dir = KiokuDB->connect(
    "dbi:SQLite:dbname=./insurgent-auth.sqlite",
    create => 1,
    columns =>
    [
        email =>
        {
            data_type => "varchar",
            is_nullable => 0,
        },
    ],
);

{
    my $scope = $dir->new_scope;

    my $new_user = User->new(
        {
            email =>  'jack@myhome.tld',
        }
    );

    $dir->store($new_user);
}

print "1\n";
