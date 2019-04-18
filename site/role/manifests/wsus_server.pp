# Role to demonstrate various windows modules/facilities on puppet.
#

class role::wsus_server {
  include ::profile::wsus::server::wsus_server
}
