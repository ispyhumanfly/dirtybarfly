package Model::Schema::Result::PlaceEvent;
use base qw/DBIx::Class::Core/;

__PACKAGE__->table('place_event');
__PACKAGE__->add_columns( qw/ event_id category title start_date stop_date start_time stop_time about date time popularity place person / );
__PACKAGE__->set_primary_key('event_id');

__PACKAGE__->belongs_to( place  => 'Model::Schema::Result::Place' );
__PACKAGE__->belongs_to( person   => 'Model::Schema::Result::Person' );

1;
