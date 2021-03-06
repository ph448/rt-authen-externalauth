package RT::Authen::ExternalAuth::Raven;

use strict;

sub GetAuth {
    my ($service, $username, $password) = @_;
    $RT::Logger->debug( "Trying external auth service:",$service);
    # eppn set means the user has a valid session, return true
    return 1 if $ENV{'eppn'};
}


sub CanonicalizeUserInfo {
    my ($service, $key, $value) = @_;
    my $found = 0;
    my %params = (Name         => undef,
                  EmailAddress => undef,
                  RealName     => undef);

    $RT::Logger->debug( "$service;$key;$value, @_");

    if (!exists($ENV{$key}) || $ENV{$key} ne $value) {
        # if the key does not exist, we don't have a Raven session,
        # so we need to reflect the parameter back for user creation
        # if the value does not equal the eppn, we're creating a new user
        $RT::Logger->debug( "We do not have Raven info, pass user back");
        $params{'Name'} = $value;
        $params{'EmailAddress'} = $value;
    } else {
        $found = 1;
        # Load the config
        my $config = RT->Config->Get('ExternalSettings')->{$service};
        # iterate over the attribute map and get details
        while ( ($key, $value) = each %{$config->{'attr_map'}} ) {
            $params{$key} = $ENV{$value};
            $RT::Logger->debug( "Setting $key to the value of $value: $ENV{$value}");
        }
    }
    return ($found, %params);
}

sub UserExists {
    my ($username,$service) = @_;
    $RT::Logger->debug("$service checking if username $username exists");
    # eppn set means we have a Raven session, return true
    return 1 if $username eq $ENV{'eppn'};
    return 0;
}

sub UserDisabled {
    my ($username,$service) = @_;
    $RT::Logger->debug("$service checking if user $username is enabled");
    # eppn set means we have a Raven session, return false
    return 0 if $username eq $ENV{'eppn'};
    return 1;
}

1;
