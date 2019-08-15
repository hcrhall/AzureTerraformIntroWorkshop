# LAB-01: AzureRM Provider Authenticating using an Azure Service Principal

>**Note:**
>
>In order to complete the following exercise you will require access to a Microsoft Azure Subscription and Azure Active Directory tenant.

---

## Install Terraform
To install Terraform, you will need to [download](https://www.terraform.io/downloads.html) the appropriate package for your operating system and extract the contents of the compressed file into an install directory. The installation directory should be defined in the global path for your operating system of choice.

## Set up Terraform access to Azure
To enable Terraform to provision resources into Azure, [create an Azure AD service principal](https://www.terraform.io/docs/providers/azurerm/auth/service_principal_client_secret.html). The service principal grants the necessary permissions that are required to provision infrastructure defined in a Terraform template within your Azure subscription.

## Configure Terraform environment variables
To configure Terraform to use your Azure AD service principal, set the following environment variables, which are then used by the Azure Terraform Provider. 

- ARM_SUBSCRIPTION_ID
- ARM_CLIENT_ID
- ARM_CLIENT_SECRET
- ARM_TENANT_ID
- ARM_ENVIRONMENT

You can use the following sample bash script example to set these variables (non-persistent) on Linux:

```
#!/bin/sh
echo "Setting environment variables for Terraform"
export ARM_SUBSCRIPTION_ID=your_subscription_id
export ARM_CLIENT_ID=your_appId
export ARM_CLIENT_SECRET=your_password
export ARM_TENANT_ID=your_tenant_id

# Not needed for public, required for usgovernment, german, china
export ARM_ENVIRONMENT=public
```
You can use the following sample batch script example to set these variables (non-persistent) on Windows:

```
echo "Setting environment variables for Terraform"
set ARM_SUBSCRIPTION_ID=your_subscription_id
set ARM_CLIENT_ID=your_appId
set ARM_CLIENT_SECRET=your_password
set ARM_TENANT_ID=your_tenant_id

# Not needed for public, required for usgovernment, german, china
set ARM_ENVIRONMENT=public
```

Proceed to the next [lesson](./02_Configuration.md)

---