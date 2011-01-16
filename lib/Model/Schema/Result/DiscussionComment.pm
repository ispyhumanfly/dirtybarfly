package Model::Schema::Result::DiscussionComment;
use base qw/DBIx::Class::Core/;

__PACKAGE__->table('discussion_comment');
__PACKAGE__->add_columns( qw/ comment_id date time comment discussion person / );
__PACKAGE__->set_primary_key('comment_id');

__PACKAGE__->belongs_to( discussion  => 'Model::Schema::Result::Discussion' );

__PACKAGE__->belongs_to( person   => 'Model::Schema::Result::Person' );

1;
