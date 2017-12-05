
  class profile::wsus::wsus {

    # Enforce Windows Update to run every Sunday.
    class { 'wsus_client':
            server_url             => 'http://winops-wsus:8530',
            auto_update_option     => "Scheduled",
            scheduled_install_day  => "Sunday",
            scheduled_install_hour => 2am,
            enable_status_server   => true,
    }

  }
