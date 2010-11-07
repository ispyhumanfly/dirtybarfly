package Model::Schema::Result::Person;
use base qw/DBIx::Class::Core/;

__PACKAGE__->table('person');
__PACKAGE__->add_columns( qw/ person_id name first_name last_name gender birthday email timezone city region country lat lng avatar about popularity / );
__PACKAGE__->set_primary_key('person_id');

### Tracking

__PACKAGE__->has_many( tracks   => 'Model::Schema::Result::PersonTrack');
__PACKAGE__->has_many( tracking => 'Model::Schema::Result::PersonTracking');


### Pages

__PACKAGE__->has_many( places   => 'Model::Schema::Result::Place');
__PACKAGE__->has_many( events   => 'Model::Schema::Result::PlaceEvent');

1;
