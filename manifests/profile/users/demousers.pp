class profile::users::demousers {

 user { 'jim':
  # on Windows can use username, domain\user and SID
  name                 => 'jimijohn',
  ensure               => present,
  managehome           => true,
  password             => 'bob1A!fsafsfaswef',
  groups               => ['Administrators', 'Users']
 }

 user { 'joe':
  # on Windows can use username, domain\user and SID
  name                 => 'joesoap',
  ensure               => present,
  managehome           => true,
  password             => 'bob1A!fsafsfaswef',
  groups               => ['Administrators', 'Users']
 }

}
