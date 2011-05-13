package Model::Schema::Result::PlaceTrack;
use DBIx::Class::Candy -components => ['InflateColumn::DateTime'];

table 'place_track';

column track_id => {

    data_type         => 'int',
    is_auto_increment => 1,
};

column comment => {

    data_type => 'varchar',
    size      => 100,
};

column link => {

    data_type => 'varchar',
    size      => 100,
};

column datetime => {

    data_type => 'datetime',
    size      => 50,
};

column place => {

    data_type => 'int',
};

primary_key 'track_id';

belongs_to place => 'Model::Schema::Result::Place';

1;
