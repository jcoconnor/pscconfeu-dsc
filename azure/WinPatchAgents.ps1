# Login to Azure
#Login-AzureRmAccount

. .\AzureAgents.ps1

$MachineList = @(
'puppet-gsk01',
'puppet-gsk02',
'puppet-gsk03',
'puppet-gsk04',
'puppet-gsk05',
'puppet-gsk06',
'puppet-gsk07',
'puppet-gsk08',
'puppet-gsk09',
'puppet-gsk10',
'puppet-gsk11',
'puppet-gsk12',
'puppet-gsk13',
'puppet-gsk14',
'puppet-gsk15'
  )

  
WinPatch-PsWindowsUpdate -MachineList $MachineList

exit

$MachineList | % {

  $MachineName = $_.toLower()
  WinPatch-WinOps2017VM -MachineName $MachineName
}


# Alternate Patching Method

$MachineList | % {

  $MachineName = $_.toLower()
  New-WinOps2017VM -MachineName $MachineName

#  Configure-WinOps2017VM -MachineName $MachineName

}

