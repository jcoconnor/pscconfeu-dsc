# Role to demonstrate various windows modules/facilities on puppet.
#

class role::demo {
  include ::profile::dsc::dscaddreg
  include ::profile::dsc::dscfile
  include ::profile::dsc::dscfirewall
  include ::profile::registry::regentries
  include ::profile::users::demousers
}
