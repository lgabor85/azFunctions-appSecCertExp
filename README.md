# azFunctions-appSecCertExp

This repository hosts an Azure Function that checks for expiring certificates in Azure AD app registrations. The function retrieves Azure AD credentials from Azure Key Vault, obtains an access token, and queries Microsoft Graph API to find app registrations with certificates that are about to expire.

## Features

- Retrieves Azure AD credentials from Azure Key Vault.
- Obtains an access token using client credentials.
- Queries Microsoft Graph API for app registrations.
- Checks for expiring certificates within a specified threshold.
- Logs the details of app registrations with expiring certificates.

## Prerequisites

- Azure Subscription
- Azure Key Vault with stored secrets for `tenantId`, `clientId`, and `clientSecret`
- Azure AD App Registration with necessary API permissions
- Azure Functions Core Tools (for local development)

## Setup

1. **Clone the repository:**

    ```sh
    git clone https://github.com/yourusername/azFunctions-appSecCertExp.git
    cd azFunctions-appSecCertExp
    ```

2. **Configure Azure Key Vault:**

    Ensure that your Azure Key Vault contains the following secrets:
    - `tenantId`
    - `clientId`
    - `clientSecret`

3. **Deploy the Azure Function:**

    Follow the steps to deploy the Azure Function to your Azure subscription. You can use the Azure Functions Core Tools or the Azure Portal.

4. **Set the required environment variables:**

    Configure the following environment variables in your Azure Function App settings:
    - `keyvaultName`: Name of your Azure Key Vault
    - `secretName`: Name of the secret containing the client secret

## Usage

The Azure Function is triggered by an HTTP request. It performs the following steps:

1. Retrieves Azure AD credentials from Azure Key Vault.
2. Obtains an access token using client credentials.
3. Queries Microsoft Graph API for app registrations.
4. Checks for expiring certificates within a specified threshold.
5. Logs the details of app registrations with expiring certificates.

## Contributing

Contributions are welcome! Please open an issue or submit a pull request for any improvements or bug fixes.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

## Contact

For any questions or support, please open an issue in the repository or contact the repository owner.