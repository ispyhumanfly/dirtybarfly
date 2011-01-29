package Model::Schema::Result::TopicTrack;
use base qw/DBIx::Class::Core/;

__PACKAGE__->table('topic_track');
__PACKAGE__->add_columns(qw/ track_id comment link topic /);

__PACKAGE__->load_components(qw/InflateColumn::DateTime/);
__PACKAGE__->add_columns(datetime => {datetime => 'datetime'});

__PACKAGE__->set_primary_key('track_id');

__PACKAGE__->belongs_to(topic => 'Model::Schema::Result::Topic');

1;
