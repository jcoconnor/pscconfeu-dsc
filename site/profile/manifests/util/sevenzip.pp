
# Downloads and extracts some of the sysinternals suite.
# Set the "License Accepted" registry key for sysinternals tools.
# Sets Path to include the utilities.
class profile::util::sevenzip()
{
   include chocolatey
   
   package { '7zip.install':
    ensure            => installed,
    provider          => 'chocolatey',
  }
}


