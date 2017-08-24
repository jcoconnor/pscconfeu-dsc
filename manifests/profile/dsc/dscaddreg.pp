
class profile::dsc::dscaddreg {
  # requires registry module for Puppet
  dsc_registry { 'registry_test_binary':
    dsc_ensure    => 'Present',
    dsc_key       => 'HKEY_LOCAL_MACHINE\SOFTWARE\PuppetDSCDemo',
    dsc_valuename => 'TestBinaryValue',
    dsc_valuedata => 'BEEF',
    dsc_valuetype => 'Binary',
  }

  dsc_registry { 'registry_test_dword':
    dsc_ensure    => 'Present',
    dsc_key       => 'HKEY_LOCAL_MACHINE\SOFTWARE\PuppetDSCDemo',
    dsc_valuename => 'TestDwordValue',
    dsc_valuedata => '1',
    dsc_valuetype => 'Dword',
  }

  dsc_registry { 'registry_test_string':
    dsc_ensure    => 'Present',
    dsc_key       => 'HKEY_LOCAL_MACHINE\SOFTWARE\PuppetDSCDemo',
    dsc_valuename => 'TestStringValue',
    dsc_valuedata => 'Dogs',
    dsc_valuetype => 'String',
  }
}
