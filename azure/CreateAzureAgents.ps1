# Login to Azure
#Login-AzureRmAccount

. .\AzureAgents.ps1

Start-Transcript -IncludeInvocationHeader -Path "\CreateAzureAgents-.log"

$MachineList = @(
'puppet-gsk06',
'puppet-gsk07',
'puppet-gsk08',
'puppet-gsk09',
'puppet-gsk10',
'puppet-gsk11',
'puppet-gsk12',
'puppet-gsk13',
'puppet-gsk14',
'puppet-gsk15'
)
$MachineList | % {

  $MachineName = $_.toLower()
  New-WinOps2017VM -MachineName $MachineName

#  Configure-WinOps2017VM -MachineName $MachineName
#  WinPatch-WinOps2017VM -MachineName $MachineName
}
