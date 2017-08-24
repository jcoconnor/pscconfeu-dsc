class users::users()
{
 user { 'jim':
  # on Windows can use username, domain\user and SID
  name                 => 'jim',
  ensure               => present,
  managehome           => true,
  password             => 'bob1A!fsafsfaswef',
  groups               => ['Administrators', 'Users']
 }

 user { 'joe':
  # on Windows can use username, domain\user and SID
  name                 => 'joe',
  ensure               => present,
  managehome           => true,
  password             => 'bob1A!fsafsfaswef',
  groups               => ['Administrators', 'Users']
 }

}
