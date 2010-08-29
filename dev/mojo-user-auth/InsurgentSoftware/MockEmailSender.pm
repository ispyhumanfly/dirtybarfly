package InsurgentSoftware::MockEmailSender;

use strict;
use warnings;

package Email::Sender::Simple;

$INC{'Email/Sender/Simple.pm'} = './Email/Sender/Simple.pm';

my @sent_emails;

sub send
{
    my $class = shift;
    my $email = shift;

    push @sent_emails, $email;
}

sub shift_email
{
    return shift(@sent_emails);
}

1;

