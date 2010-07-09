package InsurgentSoftware::UserAuth::App::Forms;

use Moose;

use InsurgentSoftware::UserAuth::FormSpec;

has _forms => (
    traits => ['Hash'],
    isa => "HashRef[InsurgentSoftware::UserAuth::FormSpec]",
    is => "rw",
    default => sub { return +{} },
    handles => { get_form => 'get', },
);

sub add_form
{
    my ($self, $args) = @_;

    my $id = $args->{'id'};
    my $fields = $args->{'fields'};
    my $action = $args->{'action'};

    $self->_forms->{$id} =
        InsurgentSoftware::UserAuth::FormSpec->new(
            {
                id => $id,
                to => ($action || ($id . "-submit")),
                fields => $fields,
            },
        );

    return;
}

1;

