package Model::Schema::Result::Place;
use base qw/DBIx::Class::Core/;

__PACKAGE__->table('place');
__PACKAGE__->add_columns( qw/ place_id category title body date time user / );
__PACKAGE__->set_primary_key('place_id');

__PACKAGE__->belongs_to( user => 'Model::Schema::Result::User' );

1;
