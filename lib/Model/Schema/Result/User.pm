package Model::Schema::Result::User;
use base qw/DBIx::Class::Core/;

__PACKAGE__->table('user');
__PACKAGE__->add_columns( qw/ user_id name first_name last_name gender birthday email timezone location city region country lat lng popularity / );
__PACKAGE__->set_primary_key('user_id');

__PACKAGE__->has_many( places   => 'Model::Schema::Result::Place');
__PACKAGE__->has_many( events   => 'Model::Schema::Result::PlaceEvent');

1;
