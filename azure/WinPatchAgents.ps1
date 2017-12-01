# Login to Azure
#Login-AzureRmAccount

. .\AzureAgents.ps1

$MachineList = @(
'wol-gsk11'
  )

$MachineList | % {

  $MachineName = $_.toLower()
  WinPatch-WinOps2017VM -MachineName $MachineName
}

