#
class php {

  # package install list
  $packages = [
    'php',
    'php-pear'
  ]

  package { $packages:
    ensure  => present,
    require => Exec['yum update']
  }
}
