package Model::Schema::Result::ClassifiedComment;
use base qw/DBIx::Class::Core/;

__PACKAGE__->table('classified_comment');
__PACKAGE__->add_columns(
    qw/ comment_id date time comment classified person /);
__PACKAGE__->set_primary_key('comment_id');

__PACKAGE__->belongs_to(classified => 'Model::Schema::Result::Classified');

__PACKAGE__->belongs_to(person => 'Model::Schema::Result::Person');

1;
