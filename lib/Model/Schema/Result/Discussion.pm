package Model::Schema::Result::Discussion;
use base qw/DBIx::Class::Core/;

__PACKAGE__->table('discussion');
__PACKAGE__->add_columns(
    qw/ discussion_id category title about street_address city region country lat lng person /
);

__PACKAGE__->load_components(qw/InflateColumn::DateTime/);
__PACKAGE__->add_columns(datetime => {datetime => 'datetime'});

__PACKAGE__->set_primary_key('discussion_id');

__PACKAGE__->has_many(tracks   => 'Model::Schema::Result::DiscussionTrack');
__PACKAGE__->has_many(comments => 'Model::Schema::Result::DiscussionComment');

__PACKAGE__->belongs_to(person => 'Model::Schema::Result::Person');

1;
