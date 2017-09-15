class profile::www::webpage {
  file { 'C:/inetpub/wwwroot/iisstart.htm':
    ensure  => file,
    content => epp('win_essentials/iisstart.htm.epp'),
  }
}
