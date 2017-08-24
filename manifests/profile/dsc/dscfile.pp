class profile::dsc::dscfile {

  $test_file_contents = 'foo'

  dsc_file {'tmp_file':
    dsc_ensure          => 'present',
    dsc_type            => 'File',
    dsc_destinationpath => 'c:/windows/temp/dsc-test.txt',
    dsc_contents        => $test_file_contents,

    # DSC specific properties
    dsc_force           => true,
    dsc_attributes      => ['Archive', 'ReadOnly'],
    # dsc_credential => { user => 'vagrant', password => 'vagrant' }
  }

  file {'c:/windows/temp/puppet-test.txt':
    ensure => absent,
    content => $test_file_contents
  }
}
