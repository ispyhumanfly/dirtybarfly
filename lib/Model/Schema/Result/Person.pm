package Model::Schema::Result::Person;
use base qw/DBIx::Class::Core/;

__PACKAGE__->table('person');
__PACKAGE__->add_columns(
    qw/ person_id name password first_name last_name gender birthday email city region country lat lng avatar blurp popularity tracking /
);
__PACKAGE__->set_primary_key('person_id');


__PACKAGE__->has_many( tracks => 'Model::Schema::Result::PersonTrack' );
__PACKAGE__->has_many( places => 'Model::Schema::Result::Place' );
__PACKAGE__->has_many( events => 'Model::Schema::Result::PlaceEvent' );

1;
