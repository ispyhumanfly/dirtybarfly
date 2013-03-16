package Model::Schema::Result::Person;
use DBIx::Class::Candy -components => ['InflateColumn::DateTime'];

table 'person';

column person_id => {

    data_type         => 'int',
    is_auto_increment => 1,
};

column name => {

    data_type => 'varchar',
    size      => 100,
};

column password => {

    data_type => 'varchar',
    size      => 1000,
};

column first_name => {

    data_type   => 'varchar',
    size        => 50,
    is_nullable => 1,
};

column last_name => {

    data_type   => 'varchar',
    size        => 50,
    is_nullable => 1,
};

column gender => {

    data_type   => 'varchar',
    size        => 25,
    is_nullable => 1,
};

column birthday => {

    data_type   => 'varchar',
    size        => 25,
    is_nullable => 1,
};

column email => {

    data_type => 'varchar',
    size      => 100,
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
    size      => 50,
};

column lng => {

    data_type => 'float',
    size      => 50,
};

column avatar => {

    data_type   => 'varchar',
    size        => 500,
    is_nullable => 1,
};

column blurb => {

    data_type   => 'varchar',
    size        => 1000,
    is_nullable => 1,
};

column tracking => {

    data_type   => 'datetime',
    size        => 50,
    is_nullable => 1,
};

column datetime => {

    data_type => 'datetime',
    size      => 50,
};

primary_key 'person_id';

__PACKAGE__->has_many(tracks      => 'Model::Schema::Result::PersonTrack');
__PACKAGE__->has_many(discussions => 'Model::Schema::Result::Discussion');

1;
