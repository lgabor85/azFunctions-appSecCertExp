# azFunctions-appSecCertExp

## Overview

`azFunctions-appSecCertExp` is a PowerShell script designed to export all Azure AD app registrations with secrets and certificates that are expiring within a specified number of days (or already expired) along with their owners. The results are exported to a CSV file.

## Features

- Retrieves Azure AD app registrations.
- Checks for secrets and certificates expiring within a specified number of days.
- Option to include already expired secrets and certificates.
- Exports the results to a CSV file.

## Prerequisites

- Azure PowerShell module
- Azure Key Vault with stored credentials
- Azure AD app with the necessary permissions to read app registrations

## Installation

1. Clone the repository:
    ```sh
    git clone https://github.com/yourusername/azFunctions-appSecCertExp.git
    cd azFunctions-appSecCertExp
    ```

2. Ensure you have the Azure PowerShell module installed:
    ```sh
    Install-Module -Name Az -AllowClobber -Scope CurrentUser
    ```

## Usage

1. Open the `appSecretCertExpiry.ps1` script in your preferred editor.

2. Update the following variables with your Azure Key Vault details:
    ```powershell
    $keyvaultName = 'your-keyvault-name'
    $secretName = 'your-secret-name'
    ```

3. Run the script:
    ```sh
    pwsh appSecretCertExpiry.ps1
    ```

4. The script will generate a CSV file with the expiring secrets and certificates.

## Configuration

- **Azure Key Vault**: Store your `tenantId`, `clientId`, and `clientSecret` in your Azure Key Vault.
- **Expiration Threshold**: Modify the `$expirationThreshold` variable to set the number of days for checking expiring secrets and certificates.

## Contributing

Contributions are welcome! Please submit a pull request or open an issue to discuss your ideas.

## License

This project is licensed under the MIT License. See the `LICENSE` file for details.

## Author

- [Gabor Lakatos](https://linkedin.com/in/lakatosgabor)

## Acknowledgments

- Special thanks to the Azure community for their continuous support and contributions.
