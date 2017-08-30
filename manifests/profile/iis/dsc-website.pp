class profile::iis::dscwebsite {

  dsc_file {'c:/inetpub':
    dsc_ensure => 'present',
    dsc_type => 'directory',
    dsc_destinationpath => 'c:/inetpub',
  }
  ->
  dsc_file {'c:/inetpub/testsite':
    dsc_ensure => 'present',
    dsc_type => 'directory',
    dsc_destinationpath => 'c:/inetpub/testsite',
  }
  ->
  dsc_file {'c:/inetpub/testsite/index.html':
    dsc_ensure => 'present',
    dsc_type => 'file',
    dsc_destinationpath => 'c:/inetpub/testsite/index.html',
    dsc_contents => '<html><h3>Hi DSC!</h3></html>'
  }
  ->
  dsc_windowsfeature {'iis':
    dsc_ensure => 'present',
    dsc_name   => 'web-server',
    # could use this
    # dsc_includeallsubfeature => 'true',
  }
  ->
  # Puppet equivalent is with another module - dism
  # dism { 'IIS-WebServer':
  #   ensure => present,
  #   all    => true,
  # }
  # or windowsfeature
  # windowsfeature { 'Web-Server':
  #   ensure             => present,
  #   installsubfeatures => true,
  # }

  dsc_windowsfeature {'iis-tools':
    dsc_ensure => 'present',
    dsc_name   => 'web-mgmt-tools',
  }
  ->
  dsc_xwebsite{'NewWebsite':
    dsc_ensure       => 'Present',
    dsc_state        => 'Started',
    dsc_name         => 'TestSite',
    dsc_physicalpath => 'C:\\inetpub\\testsite',
    dsc_bindinginfo  => [{
      'Protocol' => 'HTTP',
      'Port'     => 8089
    },
    {
        'Protocol' => 'HTTP',
        'Port'     => 8091
      }]
  }
}
