package Model::Schema::Result::Stories;
use base qw/DBIx::Class::Core/;

__PACKAGE__->table('stories');
__PACKAGE__->add_columns( qw/ story_id category title body date time epoch / );
__PACKAGE__->set_primary_key('story_id');

1;
