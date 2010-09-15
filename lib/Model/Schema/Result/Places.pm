package Model::Schema::Result::Places;
use base qw/DBIx::Class::Core/;

__PACKAGE__->table('places');
__PACKAGE__->add_columns( qw/ place_id category title body date time / );
__PACKAGE__->set_primary_key('place_id');

1;
