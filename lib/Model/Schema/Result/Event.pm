package Model::Schema::Result::Event;
use base qw/DBIx::Class::Core/;

__PACKAGE__->table('event');
__PACKAGE__->add_columns( qw/ event_id category title body date time user / );
__PACKAGE__->set_primary_key('event_id');

__PACKAGE__->belongs_to( user => 'Model::Schema::Result::User' );

1;
