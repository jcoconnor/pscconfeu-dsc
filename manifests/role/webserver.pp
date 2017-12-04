#

class role::webserver {
  if ($::osfamily == "windows" ) {
    include ::profile::iis::iisservice
    include ::profile::www::webpage
  }
  else {
    # Departing slighlyt from the roles and profiles model here 
    # and simply including the relevant modules
    Exec {
        path => ["/usr/bin", "/bin", "/usr/sbin", "/sbin", "/usr/local/bin", "/usr/local/sbin"]
      }
    include bootstrap
    include tools
    include apache
    include php
    include php::pear
    include php::pecl
    include mysql
  }
}
