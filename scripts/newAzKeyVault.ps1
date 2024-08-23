<#PSScriptInfo

.VERSION 1.0.2

.GUID 17b043b2-5b70-4844-9bc6-5caa94ced64c

.AUTHOR linkedin.com/in/lakatosgabor

#>
<#

.DESCRIPTION
Deploy Azure Key Vault from ARM

#>
    

[string]$prefix = Read-Host -Prompt "Enter a prefix"
[string]$resourceGroupName = "${prefix}" + (Get-Random -Minimum 10 -Maximum 100) + "-rg"
[string]$location = Read-Host -Prompt "Enter the location (i.e. westeurope, northeurope, etc.)"
[string]$upn = Read-Host -Prompt "Enter your user principal name (email address) used to sign in to Azure"

# Prompt the user to create a new resource group or use an existing one
$choice = Read-Host -Prompt "Do you want to create resource groupg $resourceGroupNamne or use an existing one? (create/use)"

if ($choice -eq "create") {

    New-AzResourceGroup -Name $resourceGroupName -Location $location

}

else {

    $resourceGroupName = Read-Host -Prompt "Enter the resource group name"

}



$keyVaultName = "${prefix}-Kv" + (Get-Random -Minimum 10 -Maximum 100)
$adUserId = (Get-AzADUser -UserPrincipalName $upn).Id
$templateUri = "https://raw.githubusercontent.com/Azure/azure-docs-json-samples/master/tutorials-use-key-vault/CreateKeyVault.json"

# Deploy Key Vault
New-AzResourceGroupDeployment -ResourceGroupName $resourceGroupName -TemplateUri $templateUri -keyVaultName $keyVaultName -adUserId $adUserId