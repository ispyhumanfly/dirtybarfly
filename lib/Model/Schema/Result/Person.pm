package Model::Schema::Result::Person;
use base qw/DBIx::Class::Core/;

__PACKAGE__->table('person');
__PACKAGE__->add_columns(
    qw/ person_id name password first_name last_name gender birthday email city region country lat lng avatar blurb popularity tracking /
);
__PACKAGE__->set_primary_key('person_id');

__PACKAGE__->has_many(tracks      => 'Model::Schema::Result::PersonTrack');
__PACKAGE__->has_many(events      => 'Model::Schema::Result::Event');
__PACKAGE__->has_many(discussions => 'Model::Schema::Result::Discussion');
__PACKAGE__->has_many(classifieds => 'Model::Schema::Result::Classified');

1;
