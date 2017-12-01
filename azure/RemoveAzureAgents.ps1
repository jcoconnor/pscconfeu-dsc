# Login to Azure
#Login-AzureRmAccount

. .\AzureAgents.ps1
Start-Transcript -IncludeInvocationHeader -Path "\RemoveAzureAgents.log"


$MachineList = @(
  'wol-gsk15'
  
  )

$MachineList | % {

  $MachineName = $_.toLower()
  Remove-WinOps2017VM -MachineName $MachineName

}
