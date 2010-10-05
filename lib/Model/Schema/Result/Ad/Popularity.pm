package Model::Schema::Result::Ad::Popularity;
use base qw/DBIx::Class::Core/;

__PACKAGE__->table('ad_popularity');
__PACKAGE__->add_columns( qw/ id title body date time ad / );
__PACKAGE__->set_primary_key('id');

__PACKAGE__->belongs_to( ad => 'Model::Schema::Result::Ad' );

1;