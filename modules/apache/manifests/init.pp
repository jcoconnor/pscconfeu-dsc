class apache {

  # install apache
  package { 'httpd':
    ensure  => present,
    require => Exec['yum update']
  }

  # ensures that mode_rewrite is loaded and modifies the default configuration file
  file { '/etc/httpd/mods-enabled/rewrite.load':
    ensure  => link,
    target  => '/etc/httpd/mods-available/rewrite.load',
    require => Package['httpd']
  }

  # create directory
  file {'/etc/httpd/sites-enabled':
    ensure  => directory,
    recurse => true,
    purge   => true,
    force   => true,
    before  => File['/etc/httpd/sites-enabled/vagrant_webroot'],
    require => Package['httpd'],
  }

  # create apache config from main vagrant manifests
  file { '/etc/httpd/sites-available/vagrant_webroot':
    ensure  => present,
    source  => '/vagrant/manifests/vagrant_webroot',
    require => Package['httpd'],
  }

  # symlink apache site to the site-enabled directory
  file { '/etc/httpd/sites-enabled/vagrant_webroot':
    ensure  => link,
    target  => '/etc/httpd/sites-available/vagrant_webroot',
    require => File['/etc/httpd/sites-available/vagrant_webroot'],
    notify  => Service['httpd'],
  }

  # starts the httpd service once the packages installed, and monitors changes to its configuration files and reloads if nesessary
  service { 'httpd':
    ensure    => running,
    require   => Package['httpd'],
    subscribe => [
      File['/etc/httpd/mods-enabled/rewrite.load'],
      File['/etc/httpd/sites-available/vagrant_webroot']
    ],
  }
}
