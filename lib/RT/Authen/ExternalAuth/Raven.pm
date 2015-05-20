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

    while ( ($key, $value) = each %{$config->{'attr_map'}} ) {
        $params{$key} = $ENV{$value} if $value;
        $RT::Logger->debug( "Setting $key to the value of $value: $ENV{$value}");
    }

    return ($found, %params);
}

sub UserExists {
    my ($username,$service) = @_;
    $RT::Logger->debug("$service checking if username $username exists");

    return 1 if $username == $ENV{'REMOTE_USER'} ;
}

sub UserDisabled {

    my ($username,$service) = @_;

    $RT::Logger->debug("$service checking if user $username is enabled");

    return 0 if $username == $ENV{'REMOTE_USER'} ;
}

1;
