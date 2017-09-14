# Login to Azure
#Login-AzureRmAccount

. .\AzureAgents.ps1


$MachineList = @(
  'WinopsDemo-47'
)
$MachineList | % {

  $MachineName = $_.toLower()
  New-WinOps2017VM -MachineName $MachineName

  Configure-WinOps2017VM -MachineName $MachineName

}
