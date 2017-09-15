#

class role::webserver {
  include ::profile::iis::iisservice
  include ::profile::www::webpage
}
