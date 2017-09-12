
#
# Resource Group Name: winopsrglondon
# Network Security Group: puppetNetworkSecurityGroup
# Virtual Network: vnet01

$NetSGName = "puppetNetworkSecurityGroup"
$ResourceGroupName = "winopsrglondon"
$VNetName = "vnet01"
$LocationName = "UKSouth"
$DomainNameSuffix = "uksouth.cloudapp.azure.com"
$SecretName = "smoker"
$VaultName = "WinOps2017Vault"

# Use Admin Plaintext password for this phase of configuration
$secpasswd = ConvertTo-SecureString "11WinOpsLondon" -AsPlainText -Force
$cred = New-Object System.Management.Automation.PSCredential ("puppet", $secpasswd)
#$secretURL = (Get-AzureKeyVaultSecret -VaultName "$VaultName" -Name "$SecretName").Id
#$sourceVaultId = (Get-AzureRmKeyVault -ResourceGroupName "$ResourceGroupName" -VaultName "$VaultName").ResourceId
#$CertificateStore = "My"

function New-WinOps2017VM {
param (
  [string]$MachineName
 )

	# Create:
	# 1. IP Address
	# 2. Network Interface
	# 3. VM
	# nsg and vnet are used from existing resources.

	$IPName = $MachineName + "-IP"
	$DomainNameLabel = $MachineName.toLower()
	Write-Host "Creating Public IP $IPName"
	# Create a public IP address and specify a DNS name
	$publicIP = New-AzureRmPublicIpAddress `
				-ResourceGroupName $ResourceGroupName `
				-DomainNameLabel "$DomainNameLabel" `
				-Location $LocationName `
				-AllocationMethod Static `
				-IdleTimeoutInMinutes 4 `
				-Name "$IPName"
	Write-Host "IP Address is: $($publicIP.IPAddress)"

	$nsg = Get-AzureRmNetworkSecurityGroup `
				-name $NetSGName `
				-ResourceGroupName $ResourceGroupName

	$vnet = Get-AzureRmVirtualNetwork `
				-name $VNetName `
				-ResourceGroupName $ResourceGroupName

	# Create a virtual network card and associate with public IP address and NSG
	$NicName = $MachineName + "-Nic"
	Write-Host "Creating NIC: $NicName"
	$nic = New-AzureRmNetworkInterface `
				-Name "$NicName" `
				-ResourceGroupName $ResourceGroupName `
				-Location $LocationName `
				-SubnetId $vnet.Subnets[0].Id `
				-PublicIpAddressId $publicIP.Id `
				-NetworkSecurityGroupId $nsg.Id

	$vmConfig = New-AzureRmVMConfig `
					-VMName "$MachineName" `
					-VMSize Standard_DS1_V2 | `
				Set-AzureRmVMOperatingSystem `
					-Windows `
					-ComputerName "$MachineName" `
					-Credential $cred `
					-WinRMHttp | `
				Set-AzureRmVMSourceImage `
					-PublisherName MicrosoftWindowsServer `
					-Offer WindowsServer `
					-Skus 2016-Datacenter `
					-Version latest | `
				Add-AzureRmVMNetworkInterface `
					-Id $nic.Id 

	Write-Host "Creating VM: $MachineName"
	New-AzureRmVM -ResourceGroupName $ResourceGroupName `
				-Location $LocationName `
				-VM $vmConfig
				
	Write-Host "Enable remote host as trusted"
	winrm set winrm/config/client "@{TrustedHosts='$MachineName'}"
	
#	mkdir c:\softwaredist
#	netsh advfirewall firewall set rule group="network discovery" new enable=yes
#	mkdir
#	robocopy C:\SoftwareDist\ \\winopsdemo-20\c$\SoftwareDist *.* /s
#	start-process -wait "msiexec" -ArgumentList "/i c:\SoftwareDist\puppet-agent-x64-latest.msi /qn /norestart PUPPET_AGENT_STARTUP_MODE=manual"
}



function Remove-WinOps2017VM {
param (
  [string]$MachineName
 )

	# Get Machine and resources.
	Write-Host "Finding $MachineName and Resources"
	$mcname = get-azureRMVM `
				-ResourceGroupName "$ResourceGroupName" `
				-Name "$MachineName"
	$OSDisk = $mcname.StorageProfile.osdisk
	$NIC = Get-AzureRmNetworkInterface | Where { $_.Id -eq $mcname.NetworkProfile.NetworkInterfaces[0].id }
	$PublicIpAddress = Get-AzureRmPublicIpAddress | Where { $_.Id -eq $NIC.IPConfigurations.PublicIpAddress.id }

	# Delete Machine
	Write-Host "Deleting VM $($mcname.Name), ID: $($mcname.id)"
	Remove-AzureRmVM `
		-Id $mcname.id `
		-name $mcname.Name `
		-Force

	# Remove Disk
	Write-Host "Deleting OS Disk $($OSDisk.Name)"
	Remove-AzureRmDisk `
      -ResourceGroupName $ResourceGroupName `
      -DiskName $OSDisk.Name `
      -Force

	# Delete Nic
	Write-Host "Deleting Network Interface $($Nic.Name)"
	Remove-AzureRmNetworkInterface `
      -Name $Nic.Name `
      -ResourceGroupName $ResourceGroupName `
      -Force

	# Delete IP Address.
	Write-Host "Deleting IP $($PublicIpAddress.Name), IP: $($PublicIpAddress.IPAddress)"
	Remove-AzureRmPublicIpAddress `
      -Name $PublicIpAddress.Name `
      -ResourceGroupName $ResourceGroupName `
      -Force
}