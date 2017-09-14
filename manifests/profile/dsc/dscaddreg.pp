
class profile::dsc::dscaddreg {
  # requires registry module for Puppet
  dsc_registry { 'registry_test_binary':
    dsc_ensure    => 'Present',
    dsc_key       => 'HKEY_LOCAL_MACHINE\SOFTWARE\PuppetDSCDemo',
    dsc_valuename => 'Dsc_TestBinaryValue',
    dsc_valuedata => 'BEEF',
    dsc_valuetype => 'Binary',
  }

  dsc_registry { 'registry_test_dword':
    dsc_ensure    => 'Present',
    dsc_key       => 'HKEY_LOCAL_MACHINE\SOFTWARE\PuppetDSCDemo',
    dsc_valuename => 'Dsc_TestDwordValue',
    dsc_valuedata => '42',
    dsc_valuetype => 'Dword',
  }

  dsc_registry { 'registry_test_string':
    dsc_ensure    => 'Present',
    dsc_key       => 'HKEY_LOCAL_MACHINE\SOFTWARE\PuppetDSCDemo',
    dsc_valuename => 'Dsc_TestStringValue',
    dsc_valuedata => 'WinOps 2017 Demonstration (DSC)',
    dsc_valuetype => 'String',
  }
}
