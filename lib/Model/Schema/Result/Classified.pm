package Model::Schema::Result::Classified;
use DBIx::Class::Candy -components => ['InflateColumn::DateTime'];

table 'classified';

column classified_id => {

    data_type         => 'int',
    is_auto_increment => 1,
};

column category => {

    data_type => 'varchar',
    size      => 100,
};

column title => {

    data_type => 'varchar',
    size      => 100,
};

column about => {

    data_type => 'varchar',
    size      => 1000,
};

column price => {

    data_type => 'int',
    size      => 10,
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

column datetime => {

    data_type => 'datetime',
    size      => 50,
};

column person => {

    data_type => 'int',
};

primary_key 'classified_id';

has_many tracks   => 'Model::Schema::Result::ClassifiedTrack',   'classified';
has_many comments => 'Model::Schema::Result::ClassifiedComment', 'classified';

belongs_to person => 'Model::Schema::Result::Person';

1;
