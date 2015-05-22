package RT::Authen::ExternalAuth::Raven;

use strict;

sub GetAuth {

    my ($service, $username, $password) = @_;

    my $config = RT->Config->Get('ExternalSettings')->{$service};
    $RT::Logger->debug( "Trying external auth service:",$service);

    # authenticate user and return 0 if auth failed

    return 1 if $ENV{'eppn'};

}


sub CanonicalizeUserInfo {

    my ($service, $key, $value) = @_;

    $RT::Logger->debug( "$service, $key, $value" );

    my $found = 1;
    my %params = (Name         => undef,
                  EmailAddress => undef,
                  RealName     => undef);

    # Load the config
    my $config = RT->Config->Get('ExternalSettings')->{$service};

    if (!exists($ENV{$key}) && !exists($ENV{'REMOTE_USER'})) {
        $RT::Logger->debug( "$ENV{$key}; $ENV{'REMOTE_USER'}");
        return ($found,%params);
    }

    while ( ($key, $value) = each %{$config->{'attr_map'}} ) {
        $params{$key} = $ENV{$value};
        $RT::Logger->debug( "Setting $key to the value of $value: $ENV{$value}");
    }

    return ($found, %params);
}

sub UserExists {
    my ($username,$service) = @_;
    $RT::Logger->debug("$service checking if username $username exists");

    return 1 if $username eq $ENV{'eppn'} ;
}

sub UserDisabled {

    my ($username,$service) = @_;

    $RT::Logger->debug("$service checking if user $username is enabled");

    return 0 if $username eq $ENV{'eppn'} ;
}

1;
