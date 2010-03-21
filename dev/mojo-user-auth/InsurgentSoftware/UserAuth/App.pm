package InsurgentSoftware::UserAuth::App::Base1;

use Moose;

use InsurgentSoftware::UserAuth::User;
use InsurgentSoftware::UserAuth::FormSpec;

use KiokuDB;

use Email::Sender::Simple;
use Email::Simple;
use Email::Simple::Creator;
use URI::Escape;

use CGI ();

has _mojo => (
    isa => "Mojolicious::Controller",
    is => "ro",
    init_arg => "mojo",
    handles =>
    {
        "param" => "param",
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
        _store => "store",
    }
);

has _forms => (
    isa => "HashRef[InsurgentSoftware::UserAuth::FormSpec]",
    is => "rw",
    default => sub { return +{} },
);

sub render_text
{
    my ($self, $text, $args) = @_;

    return $self->_mojo->render_text(
        $text,
        { layout => 'insurgent', %{$args}, },
    );
}


sub render
{
    my ($self, $args) = @_;

    return $self->_mojo->render(
        { layout => 'insurgent', %{$args}, },
    );
}


sub _add_form
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

sub BUILD
{
    my $self = shift;

    $self->_add_form(
        {
            id => "register",
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

    $self->_add_form(
        {
            id => "login",
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

    $self->_add_form(
        {
            id => "change_user_info",
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

    $self->_add_form(
        {
            id => "password_reset",
            fields =>
            [
                InsurgentSoftware::UserAuth::FormSpec::Field->new(
                    { type => "input", id => "email", label => "Email:",},
                ),
            ],
        },
    );

    $self->_add_form(
        {
            id => "handle_password_reset",
            fields =>
            [
                InsurgentSoftware::UserAuth::FormSpec::Field->new(
                    { type => "hidden", id => "email", label => "Unseen",},
                ),
                InsurgentSoftware::UserAuth::FormSpec::Field->new(
                    { type => "hidden", id => "password_reset_code",
                        label => "Unseen",
                    },
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

sub _check_field_specs
{
    my ($self, $specs, $error_method) = @_;

    foreach my $field_spec (@$specs)
    {
        my $max_len = ($field_spec->{len} || 255);
        if (length ($self->param($field_spec->{id})) > $max_len)
        {
            $self->$error_method(
                $field_spec->{h},
                "<p>\n".$field_spec->{body}."\n</p>\n",
            );

            return 1;
        }
    }

    return;
}

sub render_failed_reg
{
    my $self = shift;

    my $header = shift;
    my $explanation = shift || "";

    $self->render_text(
        sprintf("<h1>%s</h1>\n<p class=\"error\">%s</p>%s",
            $header, $explanation, 
            $self->register_form(
                +{ map { $_ => $self->param($_) } qw(email fullname) }
            )
        ),
        {
            title => $header,
        },
    );

    return;
}

sub render_failed_handle_password_reset
{
    my $self = shift;

    my $header = shift;
    my $explanation = shift || "";

    $self->render_text(
        sprintf("<h1>%s</h1>\n<p class=\"error\">%s</p>",
            $header, $explanation, 
        ),
        {
            title => $header,
        },
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
        {
            title => $header,
        },
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

sub password_reset_form
{
    my $self = shift;
    my $values = shift;

    return $self->_render_form("password_reset", $values)
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

sub _pass_is_too_long
{
    my $self = shift;

    return length($self->_password) > 255;
}

sub _passwords_dont_match
{
    my $self = shift;

    return $self->_password() ne $self->param("password2");
}

my @register_specs = 
(
    {
        id => "email", 
        h => "Registration failed - E-mail is too long",
        body => "The E-mail is too long. It must not be over 255 characters.",
    },
    { 
        id => "password",
        h => "Registration failed - password is too long",
        body => "The password cannot exceed 255 characters.",
    },
    { 
        id => "fullname",
        h => "Registration failed - the full name is too long",
        body => "The full name cannot exceed 255 characters.",
    },
);

sub register_submit
{
    my $self = shift;

    if ($self->_passwords_dont_match())
    {
        return $self->render_failed_reg(
            "Registration failed - passwords don't match."
        );
    }

    my $email = $self->_email;

    if ($self->_check_field_specs(\@register_specs, "render_failed_reg"))
    {
        return;
    }

    if ($self->_pass_is_too_short())
    {
        return $self->render_failed_reg(
             "Registration failed - password is too short.",
             "The password must contain at least 6 alphanumeric (A-Z, a-z, 0-9) characters.",
        );
       
    }

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

sub _get_confirm_code
{
    my $self = shift;

    open my $in, "<", "/dev/urandom";
    binmode($in);
    my $bytes = "";
    read($in, $bytes, 12);
    close($in);
    return unpack("H*", $bytes);
}

sub _send_confirmation_email
{
    my $self = shift;
    my $user = shift;

    my $email_msg = Email::Simple->create(
        header => [
            To => $user->email(),
            From => 'Insurgent-Auth <auth@insurgentsoftware.com>',
            Subject => "Authentication for " . $user->email(),
        ],
        body =>
        (
            "You need to confirm your registration for Insurgent-Auth.\n\n"
            . "Go to the following URL:\n\n"
            . $self->_mojo->url_for("confirm_register")->to_abs()
                . "?email=" . uri_escape($user->email())
                . "&code=" . uri_escape($user->confirm_code())
            . "\n\n"
        ),
    );

    Email::Sender::Simple->send($email_msg);

    $user->last_confirmation_sent_at(DateTime->now());

    return;
}

sub _register_new_user
{
    my $self = shift;
   
    my $new_user = InsurgentSoftware::UserAuth::User->new(
        {
            fullname => $self->param("fullname"),
            # TODO : don't store the password as plaintext.
            password => $self->_password(),
            email => $self->_email,
            confirm_code => $self->_get_confirm_code(),
        }
    );

    $self->_send_confirmation_email($new_user);

    $self->_store($new_user);

    $self->render_text(
        ("You registered " . $self->_email()
        . " - please check your email for confirmation."),
        {
            title => "Confirmation needed for E-mail - " 
            . CGI::escapeHTML($self->_email),
        },
    );

    return;
}

sub register
{
    my $self = shift;

    return $self->render(
        {
            template => "register",
            register_form => $self->register_form({}),
            title => "Registration",
        },
    );
}

sub login
{
    my $self = shift;

    return $self->render(
        {
            template => "login",
            login_form => $self->login_form({}),
            title => "Login",
        }
    );
}

sub login_submit
{
    my $self = shift;

    my $user = $self->_find_user_by_param;

    if (! ($user && $user->verify_password($self->_password)))
    {
        return $self->render_failed_login(
            "Wrong Login or Incorrect Password",
        );
    }

    if (!$user->confirmed())
    {
        return $self->render_failed_login(
            "You need to confirm first.",
            "Your email was not confirmed yet. See your E-mail's inbox for details.",
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
        {
            title => "Login successful",
        },
    );

    return;
}

sub account_page
{
    my $self = shift;

    if (my $user = $self->_find_user_by_login)
    {
        return $self->render(
            {
                template => "account",
                title => "Account Page",
                email => $self->_login(),
                change_user_info_form => $self->change_user_info_form(
                    { 
                        fullname => $user->fullname(), 
                        bio => $user->extra_data->bio(),
                    },
                ),
            }
        );
    }
    else
    {
        return $self->render_text(
            "You are not logged in.",
            {
                title => "Inaccessible page",
            },
        );
    }
}


sub render_failed_change_user_info
{
    my $self = shift;

    my $header = shift;
    my $explanation = shift || "";

    $self->render_text(
        sprintf("<h1>%s</h1><p class=\"error\">%s</p>%s",
            $header, $explanation, 
            $self->change_user_info_form(
                +{ map { $_ => $self->param($_) } qw(fullname bio) }
            )
        ),
        {
            title => $header,
        },
    );

    return;
}

my @change_user_info_specs = 
(
    {
        id => "fullname", 
        h => "Error - the full name is too long",
        body => "The full name is too long. It must not be over 255 characters.",
    },
    {
        id => "bio", 
        h => "Error - the bio is too long",
        body => "The bio is too long. It must not be over 6000 characters.",
        len => 6_000,
    },
);

sub change_user_info_submit
{
    my $self = shift;

    if (my $user = $self->_find_user_by_login)
    {
        if ($self->_check_field_specs(
                \@change_user_info_specs, "render_failed_change_user_info"
        ))
        {
            return;
        }

        $user->fullname($self->param('fullname'));
        $user->extra_data->bio($self->param('bio'));
        $self->_store($user);

        return $self->render_text(
            (
              "<h1>Updated Your User Data</h1>\n"
            . "<p>Your user-data was updated.</p>\n"
            . qq{<p><a href="} . $self->_mojo->url_for("account") . qq{">Return to your account</a></p>\n}
            ),
            {
                title => "Data updated",
            },
        );
    }
    else
    {
        return $self->render_text(
            "You are not logged in.",
            {
                title => "Inaccessible page",
            },
        );
    }
}


sub confirm_register
{
    my $self = shift;

    my $user = $self->_find_user_by_param;

    if (! $user)
    {
        return $self->render_failed_login(
            "Wrong Login.",
        );
    }

    if ($user->confirmed())
    {
        return $self->render_text("Email already confirmed.",
            {
                title => "Already confirmed.",
            }
        );
    }

    if ($user->confirm_code() eq $self->param("code"))
    {
        $user->confirm_code("");
        $user->confirmed(1);

        $self->_store($user);

        return $self->render_text(
            "<h1>Confirmed " . CGI::escapeHTML($self->_email()) . "</h1>",
            {
                title => "Confirmed your email. You can now login.",
            },
        );  
    }
    else
    {
        return $self->render_text(
            "Incorrect confirmation.",
        );
    }
}

sub password_reset
{
    my $self = shift;

    return $self->render(
        {
            template => "password_reset",
            password_reset_form => $self->password_reset_form({}),
            title => "Password Reset",
        },
    );
}


sub _send_password_reset_email
{
    my $self = shift;
    my $user = shift;

    if (! defined($user->password_reset_code()))
    {
        $user->password_reset_code($self->_get_confirm_code());
    }

    my $email_msg = Email::Simple->create(
        header => [
            To => $user->email(),
            From => 'Insurgent-Auth <auth@insurgentsoftware.com>',
            Subject => "Password Reset for " . $user->email(),
        ],
        body =>
        (
            "You need to confirm your registration for Insurgent-Auth.\n\n"
            . "Go to the following URL:\n\n"
            . $self->_mojo->url_for("handle_password_reset")->to_abs()
                . "?email=" . uri_escape($user->email())
                . "&code=" . uri_escape($user->password_reset_code())
            . "\n\n"
        ),
    );

    Email::Sender::Simple->send($email_msg);

    $user->last_password_reset_sent_at(DateTime->now());

    return;
}

sub password_reset_submit
{
    my $self = shift;

    my $user = $self->_find_user_by_param;

    if (! $user)
    {
        return $self->render_failed_login(
            "Wrong E-mail",
        );
    }

    $self->_send_password_reset_email($user);

    $self->render_text(
        "Successfully submitted a reset",
        {
            title => "Successfully submitted a reset",
        },
    );

    $self->_store($user);

    return;
}

sub handle_password_reset_form
{
    my $self = shift;
    my $values = shift;

    return $self->_render_form("handle_password_reset", $values)
}

sub handle_password_reset
{
    my $self = shift;

    my $user = $self->_find_user_by_param;

    if (! $user)
    {
        return $self->render_failed_reg(
            "Uknown user."
        );
    }

    if ($user->password_reset_code ne $self->param("code"))
    {
        return $self->render_failed_reg(
            "Wrong reset code."
        );
    }

    return $self->render(
        {
            template => "handle_password_reset",
            handle_password_reset_form => $self->handle_password_reset_form(
                {
                    email => $self->_email(),
                    password_reset_code => $self->param("code"),
                },
            ),
            title => "Process Password Reset",
        },
    );
}

sub handle_password_reset_submit
{
    my $self = shift;

    if ($self->_passwords_dont_match())
    {
        return $self->render_failed_handle_password_reset(
            "Passwords don't match - hit back."
        );
    }

    if ($self->_pass_is_too_short())
    {
        return $self->render_failed_handle_password_reset(
             "Registration failed - password is too short.",
             "The password must contain at least 6 alphanumeric (A-Z, a-z, 0-9) characters.",
        );
       
    }

    my $user = $self->_find_user_by_param;

    my $email = $self->_email;

    if (! $user)
    {
        return $self->render_failed_handle_password_reset(
            "Registration failed - the email was already registered",
            "The email " . CGI::escapeHTML($email) . " already exists in our database.",
        );
    }

    if ($user->password_reset_code ne $self->param("password_reset_code"))
    {
        $self->render_failed_handle_password_reset(
            "The confirmation code is wrong.",
            "The email " . CGI::escapeHTML($email) . " already exists in our database.",
        );
    }

    $user->assign_password($self->param("password"));

    $self->_store($user);

    return;
}

package InsurgentSoftware::UserAuth::App;

use Moose;

extends("InsurgentSoftware::UserAuth::App::Base1");

around 'register_submit', '_register_new_user', 'login_submit', 
       'account_page', 'change_user_info_submit', 'confirm_register',
       'password_reset_submit', 'handle_password_reset',
       'handle_password_reset_submit',
=> sub {
    my $orig = shift;
    my $self = shift;

    my $scope = $self->_new_scope;

    my @ret;
    if (wantarray())
    {
        @ret = $self->$orig(@_);
    }
    else
    {
        $ret[0] = $self->$orig(@_);
    }
    
    return @ret;
};



1;
