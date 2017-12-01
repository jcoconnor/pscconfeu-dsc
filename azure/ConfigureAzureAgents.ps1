# Login to Azure
#Login-AzureRmAccount

. .\AzureAgents.ps1
Start-Transcript -IncludeInvocationHeader -Path "\ConfigureAzureAgents.log"


$MachineList = @(
'wol-gsk1',
'wol-gsk2',
'wol-gsk3',
'wol-gsk4',
'wol-gsk5'
  )
$MachineList | % {

  $MachineName = $_.toLower()

  Configure-WinOps2017VM -MachineName $MachineName

}
