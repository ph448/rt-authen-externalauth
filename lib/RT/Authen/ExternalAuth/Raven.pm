package RT::Authen::ExternalAuth::Raven;

use strict;

sub GetAuth {

    my ($service, $username, $password) = @_;

    my $config = RT->Config->Get('ExternalSettings')->{$service};
    $RT::Logger->debug( "Trying external auth service:",$service);

    # authenticate user and return 0 if auth failed

    return 1 if $ENV{'REMOTE_USER'};

}


sub CanonicalizeUserInfo {

    my ($service, $key, $value) = @_;

    my $found = 0;
    my %params = (Name         => undef,
                  EmailAddress => undef,
                  RealName     => undef);

    # Load the config
    my $config = RT->Config->Get('ExternalSettings')->{$service};

    # Get the list of unique attrs we need
    my @attrs = values(%{$config->{'attr_map'}});


    return ($found, %params);
}

sub UserExists {
    my ($username,$service) = @_;
    $RT::Logger->debug("UserExists will always succeed for $service, username: $username");

    return 1;
}

sub UserDisabled {

    my ($username,$service) = @_;

    $RT::Logger->debug("Service $service does not check for disabled users, username: $username");

    return 0;
}

1;
