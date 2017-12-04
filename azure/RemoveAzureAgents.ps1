# Login to Azure
#Login-AzureRmAccount

. .\AzureAgents.ps1
Start-Transcript -IncludeInvocationHeader -Path "\RemoveAzureAgents-18.log"


$MachineList = @(
  'wol-gsk17',
  'wol-gsk18'
  
  )

$MachineList | % {

  $MachineName = $_.toLower()
  Remove-WinOps2017VM -MachineName $MachineName

}
