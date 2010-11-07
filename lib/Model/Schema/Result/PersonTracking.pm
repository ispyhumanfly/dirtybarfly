package Model::Schema::Result::PersonTracking;
use base qw/DBIx::Class::Core/;

__PACKAGE__->table('person_tracking');
__PACKAGE__->add_columns( qw/ tracking_id person / );
__PACKAGE__->set_primary_key('tracking_id');

__PACKAGE__->belongs_to( person   => 'Model::Schema::Result::Person' );

1;
