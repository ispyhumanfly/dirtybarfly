package Model::Schema::Result::Ads;
use base qw/DBIx::Class::Core/;

__PACKAGE__->table('ads');
__PACKAGE__->add_columns( qw/ ad_id category title body date time epoch / );
__PACKAGE__->set_primary_key('ad_id');

1;
