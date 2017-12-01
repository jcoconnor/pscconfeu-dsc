# Login to Azure
#Login-AzureRmAccount

. .\AzureAgents.ps1

$MachineList = @(
'wol-gsk17'
  )

$MachineList | % {

  $MachineName = $_.toLower()
  WinPatch-WinOps2017VM -MachineName $MachineName
}

