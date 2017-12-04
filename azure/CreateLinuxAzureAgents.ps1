# Login to Azure
#Login-AzureRmAccount

. .\AzureAgents.ps1


$MachineList = @(
'puppet-centos-gsk02'
)
$MachineList | % {

  $MachineName = $_.toLower()
  New-LinuxVM -MachineName $MachineName

}
