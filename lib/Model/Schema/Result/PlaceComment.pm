package Model::Schema::Result::PlaceComment;
use DBIx::Class::Candy -components => ['InflateColumn::DateTime'];

table 'place_comment';

column comment_id => {

    data_type         => 'int',
    is_auto_increment => 1,
};

column comment => {

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

column person => {

    data_type => 'int',
};

primary_key 'comment_id';

belongs_to place  => 'Model::Schema::Result::Place';
belongs_to person => 'Model::Schema::Result::Person';

1;

