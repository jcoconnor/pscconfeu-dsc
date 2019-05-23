
# Demo script for quickly spinning up a Linux node 
# which is auto-classified with role "sample_website"
# 
# Prerequisites:
# 1. install azure_arm module (puppet install puppetlabs/azure_arm)
# 2. export the following environment variables with proper values for authentication:
#    azure_subscription_id
#    azure_tenant_id
#    azure_client_id
#    azure_client_secret

  $role          = 'sample_website'
  $master_ip     = '35.177.8.154'
  $master_url    = 'https://master.inf.puppet.vm:8140/packages/current/install.bash'
  $instance_name = 'awskit-demo-host'

  $linux_user_data = @("USERDATA"/L)
    #! /bin/bash
    echo "${master_ip} master.inf.puppet.vm master" >> /etc/hosts
    curl -k ${master_url} | bash -s agent:certname=${instance_name} extension_requests:pp_role=${role}
    | USERDATA

  $master_user_data = @("USERDATA"/L)
    #! /bin/bash
    echo "${master_ip} master.inf.puppet.vm master" >> /etc/hosts
    curl -k ${master_url} | bash -s agent:certname=${instance_name} extension_requests:pp_role=${role}
    | USERDATA
  $windows_user_data = @("USERDATA"/L)
    #! /bin/bash
    echo "${master_ip} master.inf.puppet.vm master" >> /etc/hosts
    curl -k ${master_url} | bash -s agent:certname=${instance_name} extension_requests:pp_role=${role}
    | USERDATA


$base_name        = 'devhops'
$rg               = "${base_name}-rg"
$storage_account  = "${base_name}saccount"
$nsg              = "${base_name}-nsg"
$vnet             = "${base_name}-vnet"
$subnet           = "${base_name}-subnet"
$publicip         = "${base_name}-publicip"
$location         = 'uksouth'
$subscription_id = 'c82736ee-c108-452b-8178-f548c95d18fe'

# Base names for the vm's
$nic_base_name    = "${base_name}-nic"
$vm_base_name     = "${base_name}-vm"

# Re-use basic azure resources for the VMs
azure_resource_group { $rg:
  ensure     => present,
  parameters => {},
  location   => $location
}

azure_storage_account { $storage_account:
  ensure              => present,
  parameters          => {},
  resource_group_name => $rg,
  account_name        => $storage_account,
  location            => $location,
  sku                 => {
    name => 'Standard_LRS',
    tier => 'Standard',
  }
}

azure_network_security_group { $nsg :
  ensure              => present,
  parameters          => {},
  resource_group_name => $rg,
  location            => $location,
  properties          => {
    securityRules => [
      { name       => 'http',
        properties => {
          protocol                 => 'Tcp',
          sourcePortRange          => '*',
          destinationPortRange     => '8080',
          sourceAddressPrefix      => '*',
          destinationAddressPrefix => '*',
          access                   => 'Allow',
          priority                 => 100,
          direction                => 'Inbound',
        },
      },
      { name       => 'ssh',
        properties => {
          description              => 'Allow SSH',
          protocol                 => 'Tcp',
          sourcePortRange          => '*',
          destinationPortRange     => '22',
          sourceAddressPrefix      => '*',
          destinationAddressPrefix => '*',
          access                   => 'Allow',
          priority                 => 201,
          direction                => 'Inbound',
        },
      },
      { name       => 'https',
        properties => {
          description              => 'MCollective',
          protocol                 => 'Tcp',
          sourcePortRange          => '*',
          destinationPortRange     => '443',
          sourceAddressPrefix      => '*',
          destinationAddressPrefix => '*',
          access                   => 'Allow',
          priority                 => 103,
          direction                => 'Inbound',
        },
      },
    ]
  }
}

azure_virtual_network { $vnet:
  ensure              => 'present',
  parameters          => {},
  location            => $location,
  resource_group_name => $rg,
  properties          => {
    addressSpace => {
      addressPrefixes => ['10.0.0.0/24', '10.0.2.0/24']
    },
    dhcpOptions  => {
      dnsServers => ['8.8.8.8', '8.8.4.4']
    },
    subnets      => [
      {
        name       => $subnet,
        properties => {
          addressPrefix        => '10.0.0.0/24'
        }
      }]
  }
}

azure_subnet { $subnet:
  ensure               => present,
  subnet_parameters    => {},
  virtual_network_name => $vnet,
  resource_group_name  => $rg,
  properties           => {
    addressPrefix        => '10.0.0.0/24',
    networkSecurityGroup => {
      properties => {

      },
      id         => "/subscriptions/${subscription_id}/resourceGroups/${rg}/providers/Microsoft.Network/networkSecurityGroups/${nsg}"
    }
  }
}

# Public IP Address

azure_public_ip_address { $publicip:
  location            => $location,
  resource_group_name => $rg,
  subscription_id     => $subscription_id,
  id                  => "/subscriptions/${subscription_id}/resourceGroups/${rg}/providers/Microsoft.Network/publicIPAddresses/${publicip}",
  parameters          => {
    idleTimeoutInMinutes => '10',
  },
}

# Create multiple NIC's and VM's

azure_network_interface { $nic_base_name:
  ensure              => present,
  parameters          => {},
  resource_group_name => $rg,
  location            => $location,
  properties          => {
    ipConfigurations => [{
      properties => {
        privateIPAllocationMethod => 'Dynamic',
        publicIPAddress           => {
          id         => "/subscriptions/${subscription_id}/resourceGroups/${rg}/providers/Microsoft.Network/publicIPAddresses/${publicip}",
        },
        subnet                    => {
          id         => "/subscriptions/${subscription_id}/resourceGroups/${rg}/providers/Microsoft.Network/virtualNetworks/${vnet}/subnets/${subnet}", # lint:ignore:140chars
          properties => {
            addressPrefix     => '10.0.0.0/24',
            provisioningState => 'Succeeded'
          },
          name       => $subnet
        },
      },
      name       => "${base_name}-nic-ipconfig"
    }]
  }
}

azure_virtual_machine { $vm_base_name:
  ensure              => 'present',
  parameters          => {},
  location            => $location,
  resource_group_name => $rg,
  properties          => {
    hardwareProfile => {
        vmSize => 'Standard_D4s_v3'
    },
    storageProfile  => {
      imageReference => {
        publisher => 'canonical',
        offer     => 'UbuntuServer',
        sku       => '16.04.0-LTS',
        version   => 'latest'
      },
      osDisk         => {
        name         => $vm_base_name,
        createOption => 'FromImage',
        caching      => 'None',
        vhd          => {
          uri => "https://${$storage_account}.blob.core.windows.net/${vm_base_name}-container/${vm_base_name}.vhd"
        }
      },
      dataDisks      => []
    },
    osProfile       => {
      computerName       => $vm_base_name,
      adminUsername      => 'notAdmin',
      adminPassword      => 'Devops!',
      linuxConfiguration => {
        disablePasswordAuthentication => false
      }
    },
    networkProfile  => {
      networkInterfaces => [
        {
          id      => "/subscriptions/${subscription_id}/resourceGroups/${rg}/providers/Microsoft.Network/networkInterfaces/${nic_base_name}", # lint:ignore:140chars
          primary => true
        }]
    },
  },
  type                => 'Microsoft.Compute/virtualMachines',
}


$azure_os_disk = {
  caching => $azure_caching
  createOption => $azure_create_option
  diffDiskSettings => $azure_diff_disk_settings
  diskSizeGB => "1234 (optional)",
  encryptionSettings => $azure_disk_encryption_settings
  image => $azure_virtual_hard_disk
  managedDisk => $azure_managed_disk_parameters
  name => "name (optional)",
  osType => "osType (optional)",
  vhd => $azure_virtual_hard_disk
  writeAcceleratorEnabled => "writeAcceleratorEnabled (optional)",
}


# https://github.com/puppetlabs/puppetlabs-azure_arm/blob/master/azure_virtual_machine.md
$azure_data_disk = {
  caching => $azure_caching
  createOption => $azure_create_option
  diskSizeGB => "1234 (optional)",
  image => $azure_virtual_hard_disk
  lun => "1234",
  managedDisk => $azure_managed_disk_parameters
  name => "name (optional)",
  vhd => $azure_virtual_hard_disk
  writeAcceleratorEnabled => "writeAcceleratorEnabled (optional)",
}

# https://github.com/puppetlabs/puppetlabs-azure_arm/blob/master/azure_disk.md
azure_disk {
  api_version => "api_version",
  disk => "disk",
  location => "location (optional)",
  properties => $azure_disk_properties
  resource_group_name => "resource_group_name",
  sku => $azure_disk_sku
  subscription_id => "subscription_id",
  tags => "tags (optional)",
  zones => "zones (optional)",
}
$azure_disk_properties = {
  creationData => $azure_creation_data
  diskIOPSReadWrite => "1234 (optional)",
  diskMBpsReadWrite => "1234 (optional)",
  diskSizeGB => "1234 (optional)",
  encryptionSettings => $azure_encryption_settings
  osType => "osType (optional)",
}

$azure_creation_data = {
  createOption => "createOption",
  imageReference => $azure_image_disk_reference - optional
  sourceResourceId => "sourceResourceId (optional)",
  sourceUri => "sourceUri (optional)",
  storageAccountId => "storageAccountId (optional)",
}


# This extension appears to be quite picky in terms of syntax.
azure_virtual_machine_extension { 'script' :
  type                 => 'Microsoft.Compute/virtualMachines/extensions',
  extension_parameters => '',
  location             => $location,
  tags                 => {
      displayName => "${vm_base_name}/script",
  },
  properties           => {
    protectedSettings  => {
      commandToExecute   => $user_data,
    },
    publisher          => 'Microsoft.Azure.Extensions',
    type               => 'CustomScript',
    typeHandlerVersion => '2.0',
  },
  resource_group_name  => $rg,
  subscription_id      => $subscription_id,
  vm_extension_name    => 'script',
  vm_name              => $vm_base_name,
}
