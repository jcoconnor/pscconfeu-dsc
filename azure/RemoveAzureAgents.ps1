# Login to Azure
#Login-AzureRmAccount

. .\AzureAgents.ps1

$MachineList = @(
'WinopsDemo-45',
  'WinopsDemo-46'
  )

$MachineList | % {

  $MachineName = $_.toLower()
  Remove-WinOps2017VM -MachineName $MachineName

}
