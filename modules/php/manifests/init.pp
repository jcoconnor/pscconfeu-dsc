#
class php {

  # package install list
  $packages = [
    'php'
  ]

  package { $packages:
    ensure  => present,
    require => Exec['yum update']
  }
}
