package Model::Schema::Result::EventTrack;
use base qw/DBIx::Class::Core/;

__PACKAGE__->table('event_track');
__PACKAGE__->add_columns(qw/ track_id comment link event /);

__PACKAGE__->load_components(qw/InflateColumn::DateTime/);
__PACKAGE__->add_columns(datetime => {datetime => 'datetime'});

__PACKAGE__->set_primary_key('track_id');

__PACKAGE__->belongs_to(event => 'Model::Schema::Result::Event');

1;
