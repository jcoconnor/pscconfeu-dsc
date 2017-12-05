#
class role::wordpress {
  include ::profile::db::db
  include ::profile::db::php
  include ::profile::wordpress::wordpress
}
