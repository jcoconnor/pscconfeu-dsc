# Installs and configures NotePad Plus Plus
# with the updater (and its irritating prompt) disabled.

class profile::util::notepadplusplus()
{
  include chocolatey

  package { 'notepadplusplus':
    ensure            => installed,
    provider          => 'chocolatey',
  }
}

