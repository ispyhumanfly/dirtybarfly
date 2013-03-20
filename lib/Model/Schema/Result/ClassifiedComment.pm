package Model::Schema::Result::ClassifiedComment;
use DBIx::Class::Candy -components => ['InflateColumn::DateTime'];

table 'classified_comment';

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

column classified => {

    data_type => 'int',
};

column person => {

    data_type => 'int',
};

primary_key 'comment_id';

belongs_to classified => 'Model::Schema::Result::Classified';
belongs_to person     => 'Model::Schema::Result::Person';

1;

