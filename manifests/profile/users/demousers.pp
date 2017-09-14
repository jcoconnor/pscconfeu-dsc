class profile::users::demousers {

 user { 'winopsdemo_1':
  # on Windows can use username, domain\user and SID
  name                 => 'WinOps DemoUser 1',
  ensure               => present,
  managehome           => true,
  password             => 'GarbledPasswd!',
  groups               => ['Administrators', 'Users']
 }

 user { 'winopsdemo_2':
  # on Windows can use username, domain\user and SID
  name                 => 'WinOps DemoUser 2',
  ensure               => present,
  managehome           => true,
  password             => 'GarbledPasswd!',
  groups               => ['Administrators', 'Users']
 }

}
