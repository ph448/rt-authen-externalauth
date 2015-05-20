package RT::Authen::ExternalAuth::Raven;

use strict;

sub GetAuth {

    my ($service, $username, $password) = @_;

    my $config = RT->Config->Get('ExternalSettings')->{$service};
    $RT::Logger->debug( "Trying external auth service:",$service);

    # Make sure we fetch the user attribute we'll need for the group check
    push @attrs, $group_attr_val
        unless lc $group_attr_val eq 'dn';

    # authenticate user and return 0 if auth failed

    return 1;

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
   $RT::Logger->debug("UserExists params:\nusername: $username , service: $service");
    my $config              = RT->Config->Get('ExternalSettings')->{$service};

    my @attrs = values(%{$config->{'attr_map'}});

    # If we havent returned now, there must be a valid user.
    return 1;
}

sub UserDisabled {

    my ($username,$service) = @_;

    # FIRST, check that the user exists in the LDAP service
    unless(UserExists($username,$service)) {
        $RT::Logger->debug("User (",$username,") doesn't exist! - Assuming not disabled for the purposes of disable checking");
        return 0;
    }

    my $config          = RT->Config->Get('ExternalSettings')->{$service};

    if (defined($config->{'attr_map'}->{'Name'})) {
        # Construct the complex filter
    } else {
        $RT::Logger->debug("You haven't specified an LDAP attribute to match the RT \"Name\" attribute for this service (",
                            $service,
                            "), so it's impossible look up the disabled status of this user (",
                            $username,
                            ") so I'm just going to assume the user is not disabled");
        return 0;

    }

}

1;
