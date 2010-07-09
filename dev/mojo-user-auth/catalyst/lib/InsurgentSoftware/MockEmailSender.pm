package InsurgentSoftware::MockEmailSender;

use strict;
use warnings;

=head1 NAME

InsurgentSoftware::MockEmailSender - mock email sender and allow us to control it.

=cut

package Email::Sender::Simple;

$INC{'Email/Sender/Simple.pm'} = './Email/Sender/Simple.pm';

my @sent_emails;

=head1 METHODS

=head2 $class->send($email)

"Send" an email but actually allow us to store it.

=cut

sub send
{
    my $class = shift;
    my $email = shift;

    push @sent_emails, $email;
}

=head2 my $email = shift_email();

Retrieves the next email.

=cut

sub shift_email
{
    return shift(@sent_emails);
}

1;

