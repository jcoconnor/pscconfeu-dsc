# Dervived from: https://github.com/Microsoft/WindowsServerUpdateServicesConfig/blob/master/WindowsServerUpdateServicesConfig.ps1
# UpdateServicesDSC: https://github.com/mgreenegit/UpdateServicesDsc
class profile::wsus::server::wsus_server {

  # Package installer - using:  hbuckle/powershellmodule
  pspackageprovider {'Nuget':
    ensure => 'present'
  }

  psrepository { 'PSGallery':
    ensure              => present,
    source_location     => 'https://www.powershellgallery.com/api/v2',
#   installation_policy => 'trusted',
  }

  package { 'UpdateServicesDsc':
    ensure   => latest,
    provider => 'windowspowershell',
    source   => 'PSGallery',
  }

  reboot { 'dsc_reboot' :
    message => 'DSC has requested a reboot',
    when    => 'pending',
    onlyif  => 'pending_dsc_reboot',
  }

  dsc {'UpdateServices-Feature':
    resource_name => 'WindowsFeature',
    module        => 'PSDesiredStateConfiguration',
    properties    => {
      ensure => 'present',
      name   => 'UpdateServices'
    },
  }

  dsc {'UpdateServicesRSAT-Feature':
    resource_name => 'WindowsFeature',
    module        => 'PSDesiredStateConfiguration',
    properties    => {
      ensure               => 'present',
      name                 => 'UpdateServices-RSAT',
      includeallsubfeature => true,
    },
  }

  dsc {'UpdateServices':
    resource_name => 'UpdateServicesServer',
    module        => 'UpdateServicesDsc',
    require       => Dsc['UpdateServices-Feature','UpdateServicesRSAT-Feature'],
    properties    => {
        ensure                            => 'present',
        contentdir                        => 'D:\\WSUS',
        languages                         => ['en'],
        products                          => [
            'Windows 10 LTSB',
            'Windows 10',
            'Windows 7',
            'Windows 8.1',
            'Windows 8',
            'Windows Server 2008 R2',
            'Windows Server 2008',
            'Windows Server 2012 R2',
            'Windows Server 2012',
            'Windows Server 2016',
            'Windows Server 2019'
        ],
        classifications                   => [
            'E6CF1350-C01B-414D-A61F-263D14D133B4', # CriticalUpdates
            'E0789628-CE08-4437-BE74-2495B842F43B', # DefinitionUpdates
            '0FA1201D-4330-4FA8-8AE9-B877473B6441', # SecurityUpdates
            '68C5B0A3-D1A6-4553-AE49-01D3A7827828', # ServicePacks
            '28BC880E-0592-4CBF-8F95-C79B17911D5F'  # UpdateRollUps
        ],
        synchronize                       => true,
        synchronizeautomatically          => true,
        synchronizeautomaticallytimeofday => '15:30:00',
    },
  }

  dsc {'UpdateServicesCleanup':
    resource_name => 'UpdateServicesCleanup',
    module        => 'UpdateServicesDsc',
    require       => Dsc['UpdateServices'],
    properties    => {
      ensure                      => 'present',
      declineexpiredupdates       => true,
      declinesupersededupdates    => true,
      cleanupobsoleteupdates      => true,
      cleanupunneededcontentfiles => true,
    },
  }

  dsc { 'ApprovalRules':
    resource_name => 'UpdateServicesApprovalRule',
    module        => 'UpdateServicesDsc',
    require       => Dsc['UpdateServices'],
    properties    => {
      ensure          => 'present',
      name            => 'Definition Updates, Critical Updates, Update Rollups, Service Packs, Security Updates',
      classifications => [
            'E6CF1350-C01B-414D-A61F-263D14D133B4', # CriticalUpdates
            'E0789628-CE08-4437-BE74-2495B842F43B', # DefinitionUpdates
            '0FA1201D-4330-4FA8-8AE9-B877473B6441', # SecurityUpdates
            '68C5B0A3-D1A6-4553-AE49-01D3A7827828', # ServicePacks
            '28BC880E-0592-4CBF-8F95-C79B17911D5F'  # UpdateRollUps
                        ],
      enabled         => true,
      synchronize     => true,
      runrulenow      => true,
    },
  }
}
