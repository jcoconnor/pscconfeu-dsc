# Check for Azure Modules

Install-Module AzureRM

Get-Module -ListAvailable AzureRM

Import-Module AzureRM


# Key Vault
New-AzureRmKeyVault -VaultName "WinOps2017Vault" -ResourceGroupName "winopsrglondon" -Location "UKSouth" -EnabledForDeployment -EnabledForTemplateDeployment