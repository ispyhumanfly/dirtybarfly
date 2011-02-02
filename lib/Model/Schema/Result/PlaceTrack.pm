package Model::Schema::Result::PlaceTrack;
use base qw/DBIx::Class::Core/;

__PACKAGE__->table('place_track');
__PACKAGE__->add_columns(qw/ track_id comment link place /);

__PACKAGE__->load_components(qw/InflateColumn::DateTime/);
__PACKAGE__->add_columns(datetime => {datetime => 'datetime'});

__PACKAGE__->set_primary_key('track_id');

__PACKAGE__->belongs_to(place => 'Model::Schema::Result::Place');

1;
