package Model::Schema::Result::User;
use base qw/DBIx::Class::Core/;

__PACKAGE__->table('user');
__PACKAGE__->add_columns( qw/ user_id facebook_id name gender link email location timezone / );
__PACKAGE__->set_primary_key('user_id');

__PACKAGE__->has_many( places   => 'Model::Schema::Result::Place');
__PACKAGE__->has_many( stories  => 'Model::Schema::Result::Story');
__PACKAGE__->has_many( ads      => 'Model::Schema::Result::Ad');

1;
