function Download-File {
    param (
      [string]$url,
      [string]$file
     )
      $downloader = new-object System.Net.WebClient
      $downloader.Proxy.Credentials=[System.Net.CredentialCache]::DefaultNetworkCredentials;
    
      Write-Output "Downloading $url to $file"
      $completed = $false
      $retrycount = 0
      $maxretries = 20
      $delay = 10
      while (-not $completed) {
        try {
          $downloader.DownloadFile($url, $file)
          $completed = $true
        } catch {
            if ($retrycount -ge $maxretries) {
                Write-Output "Max Attempts exceeded"
                throw "Download aborting"
            } else {
                $retrycount++
                Write-Output "Download Failed $retrycount of $maxretries - Sleeping $delay"
                Start-Sleep -Seconds $delay
            }
        }
    }
}

# Install Puppet Agent
Download-File "https://downloads.puppetlabs.com/windows/puppet5/puppet-agent-x64-latest.msi" $Env:TEMP\puppet-agent.msi
Start-Process -Wait "msiexec" -PassThru -NoNewWindow -ArgumentList "/i $Env:TEMP\puppet-agent.msi /qn /norestart PUPPET_AGENT_STARTUP_MODE=automatic PUPPET_MASTER_SERVER=winopsmasterlondon"
Write-Output "Installed Puppet Agent..."

Write-Output "Environment Refresh"
foreach($level in "Machine","User") {
    [Environment]::GetEnvironmentVariables($level)
 }