package Model::Schema::Result::PersonTrack;
use DBIx::Class::Candy -components => ['InflateColumn::DateTime'];

table 'person_track';

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

column person => {
    
    data_type => 'int',
};

column datetime => {
    
    data_type => 'datetime',
    size      => 50,
};

primary_key 'track_id';

belongs_to person => 'Model::Schema::Result::Person';

1;
