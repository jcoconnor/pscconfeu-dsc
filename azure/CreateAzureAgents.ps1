# Login to Azure
#Login-AzureRmAccount

. .\AzureAgents.ps1


$MachineList = @(
  'WinopsDemo-51',
  'WinopsDemo-52'
)
$MachineList | % {

  $MachineName = $_.toLower()
  New-WinOps2017VM -MachineName $MachineName

  Configure-WinOps2017VM -MachineName $MachineName

}
