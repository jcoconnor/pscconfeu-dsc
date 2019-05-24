
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

$windows_init_data = @(WINDATA/L)
  powershell -ExecutionPolicy Unrestricted -Command "$size=(Get-PartitionSupportedSize -DriveLetter C); Resize-Partition -DriveLetter C -Size $size.SizeMax; [Net.ServicePointManager]::ServerCertificateValidationCallback = {$true}; $webClient = New-Object System.Net.WebClient; $webClient.DownloadFile('https://psconfeudsc.uksouth.cloudapp.azure.com:8140/packages/current/install.ps1', 'install.ps1'); .\install.ps1 -PuppetServiceEnsure stopped -PuppetServiceEnable false main:certname=$ENV:ComputerName;"
  | WINDATA

$ws_count         = '02'

$base_name        = "win-wsus-${ws_count}"
$subscription_id = 'c82736ee-c108-452b-8178-f548c95d18fe'
$location         = 'uksouth'
$rg               = 'psconfeu2'
$storage_account  = 'psconfeu2diag'
$nsg              = 'psconfeudsc-nsg'
$vnet             = 'psconfeu2-vnet'
$subnet           = 'default'
$publicip         = "${base_name}-publicip"

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
# Public IP Address

azure_public_ip_address { $publicip:
  location            => $location,
  resource_group_name => $rg,
  subscription_id     => $subscription_id,
  id                  => "/subscriptions/${subscription_id}/resourceGroups/${rg}/providers/Microsoft.Network/publicIPAddresses/${publicip}",
  parameters          => {
    idleTimeoutInMinutes => '10',
  },
  properties => {
    publicIPAllocationMethod => 'Static',
    dnsSettings => {
      domainNameLabel => $vm_base_name,
    }
  }
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
        publisher => 'MicrosoftWindowsServer',
        offer     => 'WindowsServer',
        sku       => '2019-Datacenter',
        version   => 'latest'
      },
      osDisk         => {
        name         => $vm_base_name,
        createOption => 'FromImage',
        diskSizeGB   => 500,
        caching      => 'None',
        vhd          => {
          uri => "https://${$storage_account}.blob.core.windows.net/${vm_base_name}-container/${vm_base_name}.vhd"
        }
      },
      dataDisks      => []
    },
    osProfile       => {
      computerName         => $vm_base_name,
      adminUsername        => 'puppet',
      adminPassword        => 'Asdfwro235nnsdaf',
      windowsConfiguration => {
              provisionVMAgent       => true,
              enableAutomaticUpdates => true,
      },
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
    publisher          => 'Microsoft.Compute',
    type               => 'CustomScriptExtension',
    typeHandlerVersion => '1.9',
    protectedSettings  => {
      commandToExecute   => $windows_init_data,
    },
  },
  resource_group_name  => $rg,
  subscription_id      => $subscription_id,
  vm_extension_name    => 'script',
  vm_name              => $vm_base_name,
}
