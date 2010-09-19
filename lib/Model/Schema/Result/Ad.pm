package Model::Schema::Result::Ad;
use base qw/DBIx::Class::Core/;

__PACKAGE__->table('ad');
__PACKAGE__->add_columns( qw/ ad_id category title body date time user / );
__PACKAGE__->set_primary_key('ad_id');

__PACKAGE__->has_many( comments   => 'Model::Schema::Result::AdComment');
__PACKAGE__->has_many( reviews    => 'Model::Schema::Result::AdReview');

__PACKAGE__->belongs_to( user => 'Model::Schema::Result::User' );

1;
