package Model::Schema::Result::EventComment;
use base qw/DBIx::Class::Core/;

__PACKAGE__->table('event_comment');
__PACKAGE__->add_columns(qw/ comment_id comment event person /);

__PACKAGE__->load_components(qw/InflateColumn::DateTime/);
__PACKAGE__->add_columns(datetime => {datetime => 'datetime'});

__PACKAGE__->set_primary_key('comment_id');

__PACKAGE__->belongs_to(event => 'Model::Schema::Result::Event');

__PACKAGE__->belongs_to(person => 'Model::Schema::Result::Person');

1;
