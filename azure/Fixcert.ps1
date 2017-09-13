$fileName = "C:\gitrepos\winops2017\azure\winops-wsus.uksouth.cloudapp.azure.com.pfx"
$fileContentBytes = Get-Content $fileName -Encoding Byte
$fileContentEncoded = [System.Convert]::ToBase64String($fileContentBytes)

$jsonObject = @"
{
  "data": "$filecontentencoded",
  "dataType" :"pfx",
  "password": "smoker"
}
"@

$jsonObjectBytes = [System.Text.Encoding]::UTF8.GetBytes($jsonObject)
$jsonEncoded = [System.Convert]::ToBase64String($jsonObjectBytes)

$secret = ConvertTo-SecureString -String $jsonEncoded -AsPlainText -Force

Set-AzureKeyVaultSecret -VaultName "WinOps2017Vault" -Name "smoker" -SecretValue $secret