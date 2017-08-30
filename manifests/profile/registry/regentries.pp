class profile::registry::regentries {

  registry::value { 'registry_test_binary':
      key   => 'HKEY_LOCAL_MACHINE\SOFTWARE\PuppetRegDemo',
      value => 'Reg_TestBinaryValue',
      data  => 'BEEF',
      type  => 'binary'
  }

  registry::value { 'registry_test_dword':
      key   => 'HKEY_LOCAL_MACHINE\SOFTWARE\PuppetRegDemo',
      value => 'Reg_TestDwordValue',
      data  => '1',
      type  => 'dword'
  }

  registry::value { 'registry_test_string':
      key   => 'HKEY_LOCAL_MACHINE\SOFTWARE\PuppetRegDemo',
      value => 'Reg_TestStringValue',
      data  => 'Dogs is cool',
      type  => 'string'
  }
}
