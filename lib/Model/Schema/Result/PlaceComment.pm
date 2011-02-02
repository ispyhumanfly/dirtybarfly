package Model::Schema::Result::PlaceComment;
use base qw/DBIx::Class::Core/;

__PACKAGE__->table('place_comment');
__PACKAGE__->add_columns( qw/ comment_id comment place person / );

__PACKAGE__->load_components(qw/InflateColumn::DateTime/);
__PACKAGE__->add_columns(datetime => {datetime => 'datetime'});

__PACKAGE__->set_primary_key('comment_id');

__PACKAGE__->belongs_to( place  => 'Model::Schema::Result::Place' );

__PACKAGE__->belongs_to( person   => 'Model::Schema::Result::Person' );

1;
