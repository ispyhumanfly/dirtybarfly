package Model::Schema::Result::AdComment;
use base qw/DBIx::Class::Core/;

__PACKAGE__->table('adComment');
__PACKAGE__->add_columns( qw/ id title body date time ad / );
__PACKAGE__->set_primary_key('id');

__PACKAGE__->belongs_to( ad => 'Model::Schema::Result::Ad' );

1;
