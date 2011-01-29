package Model::Schema::Result::TopicComment;
use base qw/DBIx::Class::Core/;

__PACKAGE__->table('topic_comment');
__PACKAGE__->add_columns( qw/ comment_id comment topic person / );

__PACKAGE__->load_components(qw/InflateColumn::DateTime/);
__PACKAGE__->add_columns(datetime => {datetime => 'datetime'});

__PACKAGE__->set_primary_key('comment_id');

__PACKAGE__->belongs_to( topic  => 'Model::Schema::Result::Topic' );

__PACKAGE__->belongs_to( person   => 'Model::Schema::Result::Person' );

1;
