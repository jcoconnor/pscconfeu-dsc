#
class profile::db::db {
  class { 'mysql::server':
    root_password => '8ZcJZFHsvo7fINZcAvi0' 
  }
}
