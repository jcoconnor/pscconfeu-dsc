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
  'WinopsDemo-11',
  'WinopsDemo-12',
  'WinopsDemo-13',
  'WinopsDemo-14',
  'WinopsDemo-15',
  'WinopsDemo-16',
  'WinopsDemo-17',
  'WinopsDemo-18',
  'WinopsDemo-19',
  'WinopsDemo-20',
  'WinopsDemo-21',
  'WinopsDemo-22',
  'WinopsDemo-23',
  'WinopsDemo-24',
  'WinopsDemo-25',
  'WinopsDemo-26',
  'WinopsDemo-27',
  'WinopsDemo-28',
  'WinopsDemo-29',
  'WinopsDemo-30'
  )
$MachineList | % {

  $MachineName = $_.toLower()

  Configure-WinOps2017VM -MachineName $MachineName

}
