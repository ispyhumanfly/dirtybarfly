package Posts;
use Moose;

has 'type' => ( is => 'rw', isa => 'Str' );
has 'category'  => ( is => 'rw', isa => 'Str' );
has 'title'  => ( is => 'rw', isa => 'Str' );
has 'body'  => ( is => 'rw', isa => 'Str' );

sub BUILD {

}

no Moose;
__PACKAGE__->meta->make_immutable;

1;
