# Installs Git for Windows and configures start page.
class profile::util::gitforwin()
{
  include chocolatey

  package { 'git':
    ensure            => installed,
    provider          => 'chocolatey',
  }
}
