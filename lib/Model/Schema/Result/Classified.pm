package Model::Schema::Result::Classified;
use base qw/DBIx::Class::Core/;

__PACKAGE__->table('classified');
__PACKAGE__->add_columns(
    qw/ classified_id category title about date time street_address city region country lat lng popularity person /
);
__PACKAGE__->set_primary_key('classified_id');

__PACKAGE__->has_many(comments => 'Model::Schema::Result::ClassifiedComment');

__PACKAGE__->belongs_to(person => 'Model::Schema::Result::Person');

1;
