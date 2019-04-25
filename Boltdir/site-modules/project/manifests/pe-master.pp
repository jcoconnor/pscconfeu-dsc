
# Note - this uses puppetlabs/azure_arm (Azure Resource Management)
# 
# Prerequisites:
# 1. install azure_arm module (puppet install puppetlabs/azure_arm)
# 2. export the following environment variables with proper values for authentication:
#    azure_subscription_id
#    azure_tenant_id
#    azure_client_id
#    azure_client_secret

$role          = 'sample_website'
$master_ip     = 'XXXXXX'
$master_url    = 'https://master.inf.puppet.vm:8140/packages/current/install.bash'
$instance_name = 'awskit-demo-host'

$base_name        = 'psconfeudsc'
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
        publisher => 'puppet',
        offer     => 'puppet-enterprise-201817',
        sku       => 'puppet-enterprise-201817',
        version   => '2018.1.7'
      },
      osDisk         => {
        name         => $vm_base_name,
        createOption => 'FromImage',
        caching      => 'ReadWrite',
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
