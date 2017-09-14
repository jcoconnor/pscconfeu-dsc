class profile::dsc::dscfile {

  $test_file_contents = 'This file is installed on Desktop for WinOps 2017 Puppet Demo'

  dsc_file {'demo_file':
    dsc_ensure          => 'present',
    dsc_type            => 'File',
    dsc_destinationpath => 'C:/Users/puppet/Desktop/WinOps2017-Demo.txt',
    dsc_contents        => $test_file_contents,

    # DSC specific properties
    dsc_force           => true,
    dsc_attributes      => ['Archive', 'ReadOnly'],
    # dsc_credential => { user => 'vagrant', password => 'vagrant' }
  }

}
