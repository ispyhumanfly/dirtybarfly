package InsurgentSoftware::UserAuth::FormSpec::Field;

use Moose;

use CGI ();

has type => (
    isa => "Str", is => "ro",
);

has id => (
    isa => "Str", is => "ro",
);

has label => (
    isa => "Str", is => "ro",
);

sub _get_value
{
    my ($self,$args) = @_;

    my $value = $args->{'value'};

    if (!defined($value))
    {
        $value = "";
    }

    return CGI::escapeHTML($value);
}

sub _render_password
{
    my ($self,$args) = @_;
    
    return qq{<input name="} . $self->id(). qq{" type="password" />};
}


sub _render_input
{
    my ($self,$args) = @_;
    
    return q{<input name="} . $self->id(). 
        q{" value="} . $self->_get_value($args). q{"/>}
        ;
}

sub _render_textarea
{
    my ($self,$args) = @_;

    return q{<textarea name="} . $self->id(). 
        q{">} . $self->_get_value($args). q{</textarea>}
        ;
}

sub render
{
    my ($self,$args) = @_;

    my $type = $self->type();
    my $label = CGI::escapeHTML($self->label());

    my $ret = "";
    
    $ret .= "<tr>\n";
    $ret .= "<td>$label</td>\n";

    my $meth = "_render_${type}";
    $ret .= "<td>" .  $self->$meth($args) . "</td>\n";

    $ret .= "</tr>\n";

    return $ret;
}

package InsurgentSoftware::UserAuth::FormSpec;

use Moose;

has fields => (
    is => "ro",
    isa => "ArrayRef[InsurgentSoftware::UserAuth::FormSpec::Field]",
);

has _id => (
    is => "ro",
    isa => "Str",
    init_arg => "id",
);

has _action => (
    is => "ro",
    isa => "Str",
    init_arg => "to",
);

sub render_fields
{
    my ($self,$values) = @_;

    return
        join("",
            map { $_->render({ value => $values->{$_->id()}}) }
            @{$self->fields()}
        );
}

sub render_form
{
    my ($self, $mojo, $values) = @_;

    my $action = CGI::escapeHTML($mojo->url_for($self->_action()));
    my $id = $self->_id();

    my $inner = $self->render_fields($values);

    return <<"EOF";
<form id="$id" action="$action" method="post">
<table>
$inner
<tr>
<td colspan="2">
<input type="submit" value="Submit" />
</td>
</tr>
</table>
</form>
EOF
}

1;
