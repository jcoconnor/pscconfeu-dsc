#
class bootstrap {

  # silence puppet and vagrant annoyance about the puppet group
  group { 'puppet':
    ensure => 'present'
  }

  # ensure local apt cache index is up to date before beginning
  exec { 'yum update':
    command => '/usr/bin/yum -y  update'
  }
}
