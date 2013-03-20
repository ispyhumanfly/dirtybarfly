package Model::Schema::Result::Event;
use DBIx::Class::Candy -components => ['InflateColumn::DateTime'];

table 'event';

column event_id => {

    data_type         => 'int',
    is_auto_increment => 1,
};

column title => {

    data_type => 'varchar',
    size      => 100,
};

column about => {

    data_type => 'varchar',
    size      => 1000,
};

column street_address => {

    data_type => 'varchar',
    size      => 50,
};

column city => {

    data_type => 'varchar',
    size      => 50,
};

column region => {

    data_type => 'varchar',
    size      => 25,
};

column country => {

    data_type => 'varchar',
    size      => 25,
};

column lat => {

    data_type => 'float',
    size      => 25,
};

column lng => {

    data_type => 'float',
    size      => 25,
};

column start_datetime => {

    data_type => 'datetime',
    size      => 50,
};

column stop_datetime => {

    data_type => 'datetime',
    size      => 50,
};

column datetime => {

    data_type => 'datetime',
    size      => 50,
};

column person => {

    data_type => 'INTEGER',
};

primary_key 'event_id';

has_many tracks   => 'Model::Schema::Result::EventTrack',   'event';
has_many comments => 'Model::Schema::Result::EventComment', 'event';

belongs_to person => 'Model::Schema::Result::Person';

1;

