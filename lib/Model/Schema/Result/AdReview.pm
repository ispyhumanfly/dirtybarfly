package Model::Schema::Result::AdReview;
use base qw/DBIx::Class::Core/;

__PACKAGE__->table('adReview');
__PACKAGE__->add_columns( qw/ id title body date time ad / );
__PACKAGE__->set_primary_key('id');

__PACKAGE__->belongs_to( ad => 'Model::Schema::Result::Ad' );

1;