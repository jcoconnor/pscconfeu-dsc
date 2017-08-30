class profile::power::power (
  $scheme = 'powersaver',
) {
  $guid = $scheme ? {
    'balanced'    => '381b4222-f694-41f0-9685-ff5bb260df2e',
    'performance' => '8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c',
    'powersaver'  => 'a1841308-3541-4fab-bc81-f71556f20b4a',
  }
  # Get active scheme and return 1 if it doesn't match expected value
  $check = "if((Powercfg -GetActiveScheme).Split()[3] -ne '${guid}') { exit 1 }"

  exec { 'set power scheme':
    command   => "PowerCfg -SetActive ${guid}",
    path      => 'C:\Windows\System32;C:\Windows\System32\WindowsPowerShell\v1.0',
    unless    => $check,
    provider  => powershell,
    logoutput => true,
  }
}
