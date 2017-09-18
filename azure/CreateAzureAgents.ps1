# Login to Azure
#Login-AzureRmAccount

. .\AzureAgents.ps1


$MachineList = @(


  'WinopsDemo-101',
  'WinopsDemo-102',
  'WinopsDemo-103',
  'WinopsDemo-104',
  'WinopsDemo-105',
  'WinopsDemo-106',
  'WinopsDemo-107',
  'WinopsDemo-108',
  'WinopsDemo-109',
  'WinopsDemo-110',
  'WinopsDemo-111',
  'WinopsDemo-112',
  'WinopsDemo-113',
  'WinopsDemo-114',
  'WinopsDemo-115',
  'WinopsDemo-130'
  
)
$MachineList | % {

  $MachineName = $_.toLower()
  New-WinOps2017VM -MachineName $MachineName

#  Configure-WinOps2017VM -MachineName $MachineName

}
