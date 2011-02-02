package Model::Schema::Result::Event;
use base qw/DBIx::Class::Core/;

__PACKAGE__->table('event');
__PACKAGE__->add_columns(
    qw/ event_id title about street_address city region country lat lng person /
);

__PACKAGE__->load_components(qw/InflateColumn::DateTime/);
__PACKAGE__->add_columns(
    datetime       => {datetime => 'datetime'},
    start_datetime => {datetime => 'datetime'},
    stop_datetime  => {datetime => 'datetime'}
);

__PACKAGE__->set_primary_key('event_id');

__PACKAGE__->has_many(tracks   => 'Model::Schema::Result::EventTrack');
__PACKAGE__->has_many(comments => 'Model::Schema::Result::EventComment');

__PACKAGE__->belongs_to(person => 'Model::Schema::Result::Person');

1;
