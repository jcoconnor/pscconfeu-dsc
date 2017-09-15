# Login to Azure
#Login-AzureRmAccount

. .\AzureAgents.ps1

$MachineList = @(
  'WinopsDemo-49',
  'WinopsDemo-50'
  )

$MachineList | % {

  $MachineName = $_.toLower()
  Remove-WinOps2017VM -MachineName $MachineName

}
