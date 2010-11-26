package Model::Schema::Result::PlaceImage;
use base qw/DBIx::Class::Core/;

__PACKAGE__->table('place_image');
__PACKAGE__->add_columns( qw/ id title content url width height place / );
__PACKAGE__->set_primary_key('id');

__PACKAGE__->belongs_to( place => 'Model::Schema::Result::Place' );