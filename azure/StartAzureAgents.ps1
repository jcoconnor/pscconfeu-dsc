# Login to Azure
#Login-AzureRmAccount

. .\AzureAgents.ps1

$MachineList = @(
  'WinopsDemo-01',
  'WinopsDemo-02',
  'WinopsDemo-03',
  'WinopsDemo-04',
  'WinopsDemo-05',
  'WinopsDemo-06',
  'WinopsDemo-07',
  'WinopsDemo-08',
  'WinopsDemo-09',
  'WinopsDemo-10',
  'WinopsDemo-11'
  )

$MachineList | % {

  $MachineName = $_.toLower()
  Start-WinOps2017VM -MachineName $MachineName

}
