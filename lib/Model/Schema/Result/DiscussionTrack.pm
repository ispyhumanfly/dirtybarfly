package Model::Schema::Result::DiscussionTrack;
use base qw/DBIx::Class::Core/;

__PACKAGE__->table('discussion_track');
__PACKAGE__->add_columns(qw/ track_id comment link discussion /);

__PACKAGE__->load_components(qw/InflateColumn::DateTime/);
__PACKAGE__->add_columns(datetime => {data_type => 'datetime'});

__PACKAGE__->set_primary_key('track_id');

__PACKAGE__->belongs_to(discussion => 'Model::Schema::Result::Discussion');

1;
