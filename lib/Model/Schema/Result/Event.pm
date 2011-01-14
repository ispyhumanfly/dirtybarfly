package Model::Schema::Result::Event;
use base qw/DBIx::Class::Core/;

__PACKAGE__->table('event');
__PACKAGE__->add_columns( qw/ event_id category title start_date stop_date start_time stop_time about date time street_address city region country lat lng popularity person / );
__PACKAGE__->set_primary_key('event_id');

__PACKAGE__->has_many( comments => 'Model::Schema::Result::EventComment' );

__PACKAGE__->belongs_to( person   => 'Model::Schema::Result::Person' );

1;
