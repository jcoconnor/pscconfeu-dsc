# Login to Azure
#Login-AzureRmAccount

. .\AzureAgents.ps1


$MachineList = @(
  'WinopsDemo-53',
  'WinopsDemo-54',
  'WinopsDemo-55'
)
$MachineList | % {

  $MachineName = $_.toLower()

  Configure-WinOps2017VM -MachineName $MachineName

}
