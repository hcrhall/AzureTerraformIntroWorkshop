# LAB-02: Creating Terraform Configuration

>**Note:**
>
>In order to complete the following exercise you will require an Azure AD Service Principal

The set of files used to describe infrastructure in Terraform is known as a Terraform configuration. You're going to write your first configuration now to create and configure a resource group in Azure.

---

## Providers
The provider block is used to configure the named provider, in this instance the Azure provider (azurerm). The Azure provider is responsible for creating and managing resources on Azure.

Copy the following provider configuration and save it to the [main.tf](./main.tf) file:

```
# Configure the provider
provider "azurerm" {
    version = "=1.32.1"
}
```

>Note:
>
>The version argument is optional, but recommended. It is used to constrain the provider to a specific version or a range of versions in order to prevent downloading a new provider that may possibly contain breaking changes.

## Resources
A resource block defines a resource that exists within the infrastructure. A resource block has two string parameters before opening the block: the resource type (first parameter) and the resource name (second parameter). The combination of the type and name must be unique in the configuration.

Copy the following resource configuration and save it to the [main.tf](./main.tf) file:

```
# Create a new resource group
resource "azurerm_resource_group" "rg" {
    name     = "RG-FirstName_LastName-AE"
    location = "Australia East"
}
```
> Tip:
>
> Replace the **FirstName** and **LastName** values with your first name and last name so that the resource group name is unique.
>
> Can you think of another way of randomizing resource names? Take a look at the list of built-in providers and see if you can identify a [provider](https://www.terraform.io/docs/providers/index.html) that you could use.

## Final Configuration
Once you have saved the contents of the [main.tf](./main.tf) file you should have the following configuration. We will use this configuration in the next lab where we will provision a new Azure Resource Group.

```
# Configure the AzureRM provider
provider "azurerm" {
    version = "=1.32.1"
}

# Create a new Resource Group
resource "azurerm_resource_group" "rg" {
    name     = "RG-FirstName_LastName-AE"
    location = "Australia East"
}
```
Proceed to the next [lesson](./03_Provisioning.md)

---