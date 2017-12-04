# Login to Azure
#Login-AzureRmAccount

. .\AzureAgents.ps1
Start-Transcript -IncludeInvocationHeader -Path "\ConfigureAzureAgents-04.log"


$MachineList = @(
'puppet-gsk04'
  )
$MachineList | % {

  $MachineName = $_.toLower()

  Configure-WinOps2017VM -MachineName $MachineName

}
