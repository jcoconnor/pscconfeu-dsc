# Login to Azure
#Login-AzureRmAccount

. .\AzureAgents.ps1


$MachineList = @(

  'WinopsDemo-13',
  'WinopsDemo-14',
  'WinopsDemo-15',
  'WinopsDemo-16',
  'WinopsDemo-17'
  )
$MachineList | % {

  $MachineName = $_.toLower()

  Configure-WinOps2017VM -MachineName $MachineName

}
