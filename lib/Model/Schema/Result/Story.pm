package Model::Schema::Result::Story;
use base qw/DBIx::Class::Core/;

__PACKAGE__->table('story');
__PACKAGE__->add_columns( qw/ story_id category title body date time user / );
__PACKAGE__->set_primary_key('story_id');

__PACKAGE__->belongs_to( user => 'Model::Schema::Result::User' );

1;
