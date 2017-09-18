# Login to Azure
#Login-AzureRmAccount

. .\AzureAgents.ps1


$MachineList = @(

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
  New-WinOps2017VM -MachineName $MachineName

#  Configure-WinOps2017VM -MachineName $MachineName

}
