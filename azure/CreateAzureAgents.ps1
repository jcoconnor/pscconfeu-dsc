# Login to Azure
#Login-AzureRmAccount

. .\AzureAgents.ps1

Start-Transcript -IncludeInvocationHeader -Path "\CreateAzureAgents-1.log"

$MachineList = @(
'wol-gsk11'
)
$MachineList | % {

  $MachineName = $_.toLower()
  New-WinOps2017VM -MachineName $MachineName

  Configure-WinOps2017VM -MachineName $MachineName

}
