# Fix for lmconfig issues
# https://github.com/puppetlabs/support-training/blob/3fed84cfced5e8ef45b85d25dc7d97d5f4b877b3/puppetlabs-dsc_lite/resource_provisioning.pp#L57
class profile::wsus::server::dsc_lcm_fix {

  $lcmconfig = @(LCMCONFIGFILE)
    [DSCLocalConfigurationManager()]
    configuration LCMConfig
    {
        Node localhost
        {
            Settings
            {
                RefreshMode = 'Disabled'
            }
        }
    }

    LCMConfig
    | LCMCONFIGFILE

  $configscript = @("SCRIPT"/$)
    \$configString = @"
    ${lcmconfig}
    "@
    Set-Location \$env:tmp

    Set-Content -PATH .\lcm_config_script.ps1 -Value \$configString -Force

    & .\lcm_config_script.ps1

    Set-DSCLocalConfigurationManager -PATH .\LCMConfig

    Remove-Item '.\lcm_config_script.ps1', '.\LCMConfig' -Recurse -Force

    | SCRIPT

  exec {'LCM_Set_Refresh':
    command  => $configscript,
    unless   => 'if((Get-DscLocalConfigurationManager).refreshmode -ne "disabled") {exit 1}',
    provider => powershell,
  }

}
