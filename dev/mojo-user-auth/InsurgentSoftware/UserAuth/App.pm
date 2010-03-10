package InsurgentSoftware::UserAuth::App;

use Moose;

use InsurgentSoftware::UserAuth::User;
use InsurgentSoftware::UserAuth::FormSpec;

use KiokuDB;

use CGI ();

has _mojo => (
    isa => "Mojolicious::Controller",
    is => "ro",
    init_arg => "mojo",
    handles =>
    {
        "param" => "param",
        render_text => "render_text",
        render => "render",
        session => "session",
    },
);

has _dir => (
    isa => "KiokuDB",
    is => "ro",
    init_arg => "dir",
    handles =>
    {
        _new_scope => "new_scope",
        _search => "search",
    }
);

has _forms => (
    isa => "HashRef[InsurgentSoftware::UserAuth::FormSpec]",
    is => "rw",
    default => sub { return +{} },
);

sub BUILD
{
    my $self = shift;

    $self->_forms->{"register"} = InsurgentSoftware::UserAuth::FormSpec->new(
        {
            id => "register",
            to => "register_submit",
            fields =>
            [
                InsurgentSoftware::UserAuth::FormSpec::Field->new(
                    { type => "input", id => "email", label => "Email:",},
                ),
                InsurgentSoftware::UserAuth::FormSpec::Field->new(
                    { type => "password", id => "password", 
                        label => "Password:",
                    },
                ),
                InsurgentSoftware::UserAuth::FormSpec::Field->new(
                    { type => "password", id => "password2", 
                        label => "Password (confirmation):", 
                    },
                ),
                InsurgentSoftware::UserAuth::FormSpec::Field->new(
                    { type => "input", id => "fullname", 
                        label => "Full name (optional):",
                    },
                ),
            ],
        },
    );

    $self->_forms->{"login"} = InsurgentSoftware::UserAuth::FormSpec->new(
        {
            id => "login",
            to => "login_submit",
            fields => 
            [
                InsurgentSoftware::UserAuth::FormSpec::Field->new(
                    { type => "input", id => "email", label => "Email:",},
                ),
                InsurgentSoftware::UserAuth::FormSpec::Field->new(
                    { type => "password", id => "password", 
                        label => "Password:",
                    },
                ),
            ],
        },
    );

    $self->_forms->{"change_user_info"} = 
        InsurgentSoftware::UserAuth::FormSpec->new(
        { 
            id => "change_user_info", 
            to => "change_user_info_submit", 
            fields => 
            [
                InsurgentSoftware::UserAuth::FormSpec::Field->new(
                    { type => "input", id => "fullname", 
                        label => "Full name:",
                    },
                ),
                InsurgentSoftware::UserAuth::FormSpec::Field->new(
                    { type => "textarea", id => "bio", 
                        label => "Bio:",
                    },
                ),
            ],
        },
    );

    return;
}


sub _password
{
    my $self = shift;

    return $self->param("password");
}

sub _email
{
    my $self = shift;

    return $self->param("email");
}

sub render_failed_reg
{
    my $self = shift;

    my $header = shift;
    my $explanation = shift || "";

    $self->render_text(
        sprintf("<h1>%s</h1>%s%s",
            $header, $explanation, 
            $self->register_form(
                +{ map { $_ => $self->param($_) } qw(email fullname) }
            )
        ),
        layout => 'funky',
    );

    return;
}

sub render_failed_login
{
    my $self = shift;

    my $header = shift;
    my $explanation = shift || "";

    $self->render_text(
        sprintf("<h1>%s</h1>%s%s",
            $header, $explanation, 
            $self->login_form(
                +{ map { $_ => $self->param($_) } qw(email) }
            )
        ),
        layout => 'funky',
    );

    return;
}

sub _render_form
{
    my ($self, $form_id, $values) = @_;

    return $self->_forms->{$form_id}->render_form($self->_mojo(), $values);
}

sub register_form
{
    my $self = shift;
    my $values = shift;

    return $self->_render_form("register", $values)
}

sub login_form
{
    my $self = shift;
    my $values = shift;

    return $self->_render_form("login", $values);
}

sub change_user_info_form
{
    my $self = shift;
    my $values = shift;

    return $self->_render_form("change_user_info", $values);
}

sub _find_user_by_param
{
    my $self = shift;

    return $self->_generic_find_user($self->_email());
}

sub _find_user_by_login
{
    my $self = shift;

    return $self->_generic_find_user($self->_login);
}

sub _generic_find_user
{
    my $self = shift;
    my $user_id = shift;

    if (! $user_id)
    {
        return;
    }

    my $stream = $self->_search({email => $user_id});

    FIND_EMAIL:
    while ( my $block = $stream->next )
    {
        foreach my $object ( @$block )
        {
            return $object;
        }
    }

    return;
}

sub _too_short
{
    my $p = shift;

    return (($p =~ s/[\w\d]//g) < 6);
}

sub _pass_is_too_short
{
    my $self = shift;

    return _too_short($self->_password);
}

sub _passwords_dont_match
{
    my $self = shift;

    return $self->_password() ne $self->param("password2");
}

sub register_submit
{
    my $self = shift;

    my $scope = $self->_new_scope;

    if ($self->_passwords_dont_match())
    {
        return $self->render_failed_reg(
            "Registration failed - passwords don't match."
        );
    }

    if ($self->_pass_is_too_short())
    {
        return $self->render_failed_reg(
             "Registration failed - password is too short.",
             <<"EOF",
<p>
The password must contain at least 6 alphanumeric (A-Z, a-z, 0-9) characters.
</p>
EOF
        );
    }

    my $email = $self->_email;

    if ($self->_find_user_by_param)
    {
        return $self->render_failed_reg(
            "Registration failed - the email was already registered",
            "The email " . CGI::escapeHTML($email) . " already exists in our database.",
        );
    }

    # Register a new user.
    $self->_register_new_user();

    return;
}

sub _register_new_user
{
    my $self = shift;

    my $scope = $self->_new_scope;

    my $new_user = InsurgentSoftware::UserAuth::User->new(
        {
            fullname => $self->param("fullname"),
            # TODO : don't store the password as plaintext.
            password => $self->_password,
            email => $self->_email,
        }
    );

    $self->_dir->store($new_user);

    $self->render_text("You registered the E-mail - " .
        CGI::escapeHTML($self->_email),
        layout => 'funky',
    );

    return;
}

sub register
{
    my $self = shift;

    return $self->render(
        template => "register",
        layout => 'funky',
        register_form => $self->register_form({}),
    );
}

sub login
{
    my $self = shift;

    return $self->render(
        template => "login",
        layout => 'funky',
        login_form => $self->login_form({}),
    );
}

sub login_submit
{
    my $self = shift;

    my $scope = $self->_new_scope;

    my $user = $self->_find_user_by_param;

    if (! ($user && $user->verify_password($self->_password)))
    {
        return $self->render_failed_login(
            "Wrong Login or Incorrect Password",
        );
    }

    # TODO : Implement the real login.
    $self->_login_user($user);

    return;
}

sub _login
{
    my $self = shift;

    return $self->session->{'login'};
}

sub _login_user
{
    my $self = shift;
    my $user = shift;

    $self->session->{'login'} = $user->email;

    $self->render_text(
          "<h1>Login successful</h1>\n"
        . "<p>You logged in using the E-mail "
        . CGI::escapeHTML($self->_email) 
        . "</p>\n",
        layout => 'funky',
    );

    return;
}

sub account_page
{
    my $self = shift;

    my $scope = $self->_new_scope;

    if (my $user = $self->_find_user_by_login)
    {
        return $self->render(
            template => "account",
            layout => 'funky',
            email => $self->_login(),
            change_user_info_form => $self->change_user_info_form(),
        );
    }
    else
    {
        return $self->render_text(
            "You are not logged in.",
            layout => 'funky',
        );
    }
}

1;
