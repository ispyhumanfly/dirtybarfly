package InsurgentSoftware::UserAuth::App::Forms;

use Moose;

use InsurgentSoftware::UserAuth::FormSpec;

has _forms => (
    isa => "HashRef[InsurgentSoftware::UserAuth::FormSpec]",
    is => "rw",
    default => sub { return +{} },
);

sub get_form
{
    my $self = shift;
    my $form_id = shift;

    return $self->_forms->{$form_id};
}

sub add_form
{
    my ($self, $args) = @_;

    my $id = $args->{'id'};
    my $fields = $args->{'fields'};

    $self->_forms->{$id} =
        InsurgentSoftware::UserAuth::FormSpec->new(
            {
                id => $id,
                to => $id . "_submit",
                fields => $fields,
            },
        );

    return;
}

1;

