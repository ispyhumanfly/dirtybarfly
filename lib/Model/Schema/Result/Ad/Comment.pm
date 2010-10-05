package Model::Schema::Result::Ad::Comment;
use base qw/DBIx::Class::Core/;

__PACKAGE__->table('ad_comment');
__PACKAGE__->add_columns( qw/ id title body date time ad / );
__PACKAGE__->set_primary_key('id');

__PACKAGE__->belongs_to( ad => 'Model::Schema::Result::Ad' );

1;
