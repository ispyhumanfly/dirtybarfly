package Model;
use Moose;

has 'title' => ( is => 'rw', isa => 'Str' );
has 'body'  => ( is => 'rw', isa => 'Str' );
has 'date'  => ( is => 'rw', isa => 'Str' );
has 'tags'  => ( is => 'rw', isa => 'Str' );

sub BUILD {

}

no Moose;
__PACKAGE__->meta->make_immutable;

1;
