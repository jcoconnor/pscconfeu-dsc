# Downloads and extracts some of the sysinternals suite.
# Set the "License Accepted" registry key for sysinternals tools.
# Sets Path to include the utilities.
class profile::util::sysinternals()
{
  include chocolatey

  package { 'procexp':
    ensure            => installed,
    provider          => 'chocolatey',
  }

  package { 'procmon':
    ensure            => installed,
    provider          => 'chocolatey',
  }

}
