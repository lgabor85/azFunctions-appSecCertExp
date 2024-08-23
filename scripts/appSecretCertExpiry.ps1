<#PSScriptInfo

.VERSION 1.0.0

.GUID 50e1ad30-4de5-49eb-98cc-7e2d76f15f67

.AUTHOR linkedin.com/in/lakatosgabor

#>
<#

.DESCRIPTION
This PowerShell script example exports all app registrations with secrets and certificates expiring in the next X days (and already expired if you choose so) with their owners for the specified apps from your directory in a CSV file.

#>

# Define your Azure AD credentials
$keyvaultName = 'mslearn88-Kv'
$secretName = 'appSecret'
$tenantId = (Get-AzKeyVaultSecret -VaultName $keyvaultName -Name 'tenantId' -AsPlainText)
$clientId = (Get-AzKeyVaultSecret -VaultName $keyvaultName -Name 'clientId' -AsPlainText)
$clientSecret = (Get-AzKeyVaultSecret -VaultName $keyvaultName -Name $secretName -AsPlainText)

# Construct the token endpoint URL
$tokenUrl = "https://login.microsoftonline.com/$tenantId/oauth2/v2.0/token"

# Create a hashtable with the required parameters for the token request
$tokenParams = @{
    client_id     = $clientId
    scope         = "https://graph.microsoft.com/.default"
    client_secret = $clientSecret
    grant_type    = "client_credentials"
}

# Get an access token using client credentials
$tokenResponse = Invoke-RestMethod -Uri $tokenUrl -Method POST -ContentType "application/x-www-form-urlencoded" -Body $tokenParams

# Extract the access token
$accessToken = $tokenResponse.access_token

# Construct the URL for querying app registrations
$appRegistrationsUrl = "https://graph.microsoft.com/v1.0/applications"

# Set the desired expiration threshold (e.g., 30 days)
$expirationThreshold = (Get-Date).AddDays(1)

# Get the current date and time
$Now = Get-Date

# Query app registrations with expiring certificates
$appRegistrations = Invoke-RestMethod -Uri $appRegistrationsUrl -Method GET -Headers @{ Authorization = "Bearer $accessToken" }

# Initialize an array to store the results
$logs = @()

# Iterate over the app registrations, querying app(object)Id, app(client)Id, displayName
foreach ($appRegistration in $appRegistrations.value) {
    
    $appObjId = $appRegistration.Id
    $appClId = $appRegistration.appId
    $appName = $appRegistration.displayName

    # Query the certificates associated with the app registration
    $secretsUrl = "https://graph.microsoft.com/v1.0/applications/$appObjId/passwordCredentials"
    $certificatesUrl = "https://graph.microsoft.com/v1.0/applications/$appObjId/keyCredentials"

    $secrets = Invoke-RestMethod -Uri $secretsUrl -Method GET -Headers @{ Authorization = "Bearer $accessToken" }
    $certificates = Invoke-RestMethod -Uri $certificatesUrl -Method GET -Headers @{ Authorization = "Bearer $accessToken" }

    # Iterate over the certificates if any
    foreach ($certificate in $certificates.value) {

        $certificateId = $certificate.keyId
        $certificateName = $certificate.displayName

        # Get the certificate expiration date
        $provider = [System.Globalization.CultureInfo]::InvariantCulture
        $format = "MM/dd/yyyy HH:mm:ss"
        $certificateExpiration = [datetime]::ParseExact($certificate.endDateTime, $format, $provider)


        # Calculate the number of days until the certificate expires
        $certDaysUntilExpiration = ($certificateExpiration - $Now).Days

        # Query the owners of the app registration
        $ownerUrl = "https://graph.microsoft.com/v1.0/applications/$appObjId/owners"
        $owner = Invoke-RestMethod -Uri $ownerUrl -Method GET -Headers @{ Authorization = "Bearer $accessToken" }
        $userName = $owner.value.userPrincipalName -join ';'
        $ownerID = $owner.value.id -join ';'

        if ($null -eq $owner.value.userPrincipalName) {
            $userName = @(
                $Owner.value.displayName
                '**<This is an Application>**'
            ) -join ' '
        }
        if ($null -eq $owner.value.displayName) {
            $userName = '<<No Owner>>'
        }

        # If the certificate is expiring soon, add it to the logs
        if ($certificateExpiration -lt $expirationThreshold) {

            $logs += [PSCustomObject]@{
                'AppName'                   = $appName
                'ApplicationId'             = $appClId
                'CertificateName'           = $certificateName
                'CertificateId'             = $certificateId
                'CertDaysUntilExpiration'   = $certDaysUntilExpiration
                'CertExpirationDate'        = $certificateExpiration
                'SecretName'                = $Null
                'SecretId'                  = $Null
                'SecretDaysUntilExpiration' = $Null
                'SecretExpirationDate'      = $Null
                'Owner'                     = $userName
                'Owner_ObjectID'            = $ownerID
            }

        }
    }

    # Iterate over the secrets
    foreach ($secret in $secrets.value) {

        $secretId = $secret.keyId
        $secretName = $secret.displayName

        # Get the secret expiration date
        $provider = [System.Globalization.CultureInfo]::InvariantCulture
        $format = "MM/dd/yyyy HH:mm:ss"
        $secretExpiration = [datetime]::ParseExact($secret.endDateTime, $format, $provider)

        # Calculate the number of days until the secret expires
        $secretDaysUntilExpiration = ($secretExpiration - $Now).Days

        # Query the owners of the app registration
        $ownerUrl = "https://graph.microsoft.com/v1.0/applications/$appObjId/owners"
        $owner = Invoke-RestMethod -Uri $ownerUrl -Method GET -Headers @{ Authorization = "Bearer $accessToken" }
        $userName = $owner.value.userPrincipalName -join ';'
        $ownerID = $owner.value.id -join ';'

        if ($null -eq $owner.value.userPrincipalName) {
            $userName = @(
                $Owner.value.displayName
                '**<This is an Application>**'
            ) -join ' '
        }
        if ($null -eq $owner.value.displayName) {
            $userName = '<<No Owner>>'
        }

        # If the secret is expiring soon, add it to the logs
        if ($secretExpiration -lt $expirationThreshold) {

            $logs += [PSCustomObject]@{
                'AppName'                   = $appName
                'ApplicationId'             = $appClId
                'CertificateName'           = $Null
                'CertificateId'             = $Null
                'CertDaysUntilExpiration'   = $Null
                'CertExpirationDate'        = $Null
                'SecretName'                = $secretName
                'SecretId'                  = $secretId
                'SecretDaysUntilExpiration' = $secretDaysUntilExpiration
                'SecretExpirationDate'      = $secretExpiration
                'Owner'                     = $userName
                'Owner_ObjectID'            = $ownerID
            }

        }
    }

}

# Export the logs to a CSV file
$Path = Read-Host "Enter the full path to export the CSV file"
$logs | Export-Csv -Path $Path -NoTypeInformation -Encoding UTF8

# Output results to console
Write-Output -InputObject $logs | Format-Table -AutoSize

