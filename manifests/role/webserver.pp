#

class role::webserver {
  if ($::osfamily == 'windows' ) {
    include ::profile::iis::iisservice
    include ::profile::www::webpage
  }
  else {
    # None
  }
}
