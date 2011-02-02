package Model::Schema::Result::Place;
use base qw/DBIx::Class::Core/;

__PACKAGE__->table('place');
__PACKAGE__->add_columns(
    qw/ place_id category title about street_address city region country lat lng person /
);

__PACKAGE__->load_components(qw/InflateColumn::DateTime/);
__PACKAGE__->add_columns(datetime => {datetime => 'datetime'});

__PACKAGE__->set_primary_key('place_id');

__PACKAGE__->has_many(tracks   => 'Model::Schema::Result::PlaceTrack');
__PACKAGE__->has_many(comments => 'Model::Schema::Result::PlaceComment');

__PACKAGE__->belongs_to(person => 'Model::Schema::Result::Person');

1;
