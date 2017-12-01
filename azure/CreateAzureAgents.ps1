# Login to Azure
#Login-AzureRmAccount

. .\AzureAgents.ps1

Start-Transcript -IncludeInvocationHeader -Path "\CreateAzureAgents-18.log"

$MachineList = @(
'wol-gsk18'
)
$MachineList | % {

  $MachineName = $_.toLower()
  New-WinOps2017VM -MachineName $MachineName

  Configure-WinOps2017VM -MachineName $MachineName
  WinPatch-WinOps2017VM -MachineName $MachineName
}
