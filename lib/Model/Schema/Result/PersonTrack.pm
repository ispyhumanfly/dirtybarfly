package Model::Schema::Result::PersonTrack;
use base qw/DBIx::Class::Core/;

__PACKAGE__->table('person_track');
__PACKAGE__->add_columns( qw/ track_id date time action comment person / );
__PACKAGE__->set_primary_key('track_id');

__PACKAGE__->belongs_to( person   => 'Model::Schema::Result::Person' );

1;