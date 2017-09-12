# Check for Azure Modules

Install-Module AzureRM

Get-Module -ListAvailable AzureRM

Import-Module AzureRM


# Key Vault
New-AzureRmKeyVault -VaultName "WinOps2017Vault" -ResourceGroupName "winopsrglondon" -Location "UKSouth" -EnabledForDeployment -EnabledForTemplateDeployment


# Setup Certificate

$certificateName = "winops-wsus.uksouth.cloudapp.azure.com"

$thumbprint = (New-SelfSignedCertificate -DnsName $certificateName -CertStoreLocation Cert:\CurrentUser\My -KeySpec KeyExchange).Thumbprint

$cert = (Get-ChildItem -Path cert:\CurrentUser\My\$thumbprint)

$password = ConvertTo-SecureString "smoker" -AsPlainText -Force

# password is smoker
Export-PfxCertificate -Cert $cert -FilePath ".\$certificateName.pfx" -Password $password