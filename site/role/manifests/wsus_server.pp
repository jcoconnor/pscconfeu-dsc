# Role to demonstrate various windows modules/facilities on puppet.
#

class role::wsus_server {
  include profile::wsus::server::wsus_server

  # Also include some useful utilities.
  include profile::util::sysinternals
  include profile::util::notepadplusplus
  include profile::util::gitforwin
  include profile::util::sevenzip
}
