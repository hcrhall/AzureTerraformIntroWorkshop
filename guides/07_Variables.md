# LAB-07: Terraform Variables
Congratulations! You now understand the Terraform workflow and you are able to deploy multiple resources in Microsoft Azure in a predictable manner. Only problem is everything in your configuration is hard-coded which means you cannot easily reuse the same configuration to deploy to different environments, subscriptions etc. 

To become truly shareable and version-controlled, we need to parameterize our configuration. In Terraform we do this using [input](https://www.terraform.io/docs/configuration/variables.html) and [output](https://www.terraform.io/docs/configuration/outputs.html) variables. This lesson introduces you to Terraform variables and outputs and how you can use them to create repeatable configurations.

---

## Defining Input Variables
In our [main.tf](../main.tf) we have embedded all required values as literals. We're now going to add a few simple variables to our configuration:

- **owner** - The name of the individual that owns the resources created by this configuration
- **location** - The name of the Azure region where the resources will be created

Open the [variables.tf](../variables.tf) file and add the following contents:
```
# Set the AzureRM Regional Data Centre Location
variable "location" {
    type = "string"
    default = "Australia East"
    description = "The name of the Azure region where the resources will be created"
}

# Set the AzureRM Regional Data Center Location
variable "owner" {
    type = "string"
    description = "The name of the individual that owns the resources created by this configuration"
}
```
### Using Input Variables in Configuration
---
Next, we need to modify the [main.tf](../main.tf) file and update the **owner** and **location** values with the following interpolation expressions:
```
# Configure the AzureRM provider
provider "azurerm" {
    version = "=1.32.1"
}

# Create a new Resource Group
resource "azurerm_resource_group" "rg" {
    name     = "RG-Ryan_Hall-AE"
    location = "${var.location}"

    tags     = {
        owner = "${var.owner}"
    }
}

# Create a virtual network
resource "azurerm_virtual_network" "vnet" {
    name                = "service-discovery-vnet"
    address_space       = ["10.0.0.0/16"]
    location            = "${var.location}"
    resource_group_name = "${azurerm_resource_group.rg.name}"
    tags                = {
        environment = "production"
        costcode    = "1714884364"
        owner       = "${var.owner}"
    }
}
```
### Apply Changes
---
After changing the configuration, run `terraform apply` in the terminal to see how Terraform will apply this change to the existing resources.

The output of the CLI should resemble the following:
```
terraform apply
var.owner
  The name of the individual that owns the resources created by this configuration

  Enter a value: Ryan Hall

azurerm_resource_group.rg: Refreshing state... [id=/subscriptions/<subscription_id>/resourceGroups/RG-Ryan_Hall-AE]
azurerm_virtual_network.vnet: Refreshing state... [id=/subscriptions/<subscription_id>/resourceGroups/RG-Ryan_Hall-AE/providers/Microsoft.Network/virtualNetworks/service-discovery-vnet]

Apply complete! Resources: 0 added, 0 changed, 0 destroyed.
```
>**Note:**
>
>You'll notice that when we apply the changes by running the `terraform apply` command that you received a prompt to provide a value for the **owner** variable however there was no need to specify the value for **location**. This is because we have set a default value for **location** in the [variables.tf](../variables.tf) which means that Terraform will treat it as optional. 
>
>You can override this behavior by providing the value as an argument on the command-line as follows:
>
>`terraform apply -var "owner=Ryan Hall"`

---
## Defining Output Variables
When building complex infrastructure, Terraform stores hundreds or thousands of attribute values for all your resources. But as a user of Terraform, you may only be interested in a few values of importance, such as a load balancer IP, VPN address, etc.

Outputs are a way to tell Terraform what data is important. This data is outputted when `terraform apply` is called, and can be queried using the `terraform output` command.

### Defining Outputs
---
Let's define an output that will show us the ID for the Azure Resource Group that we create as part of a `terraform apply`. Modify the [outputs.tf](../outputs.tf) file and add the following contents:
```
output "azurerm_resource_group_id" {
  value       = "${azurerm_resource_group.rg.id}"
  description = "The Azure Resource ID that has been assigned to the Azure Resource Group."
  sensitive   = false
}
```
### Viewing Outputs
---
Run `terraform apply` to populate the output. This only needs to be done once after the output is defined:
```
$ terraform apply -var "owner=Ryan Hall"
azurerm_resource_group.rg: Refreshing state... [id=/subscriptions/<subscription_id>/resourceGroups/RG-Ryan_Hall-AE]
azurerm_virtual_network.vnet: Refreshing state... [id=/subscriptions/<subscription_id>/resourceGroups/RG-Ryan_Hall-AE/providers/Microsoft.Network/virtualNetworks/service-discovery-vnet]

Apply complete! Resources: 0 added, 0 changed, 0 destroyed.

Outputs:

azurerm_resource_group_id = /subscriptions/<subscription_id>/resourceGroups/RG-Ryan_Hall-AE
```
>**Tip:**
>
>You can also query the outputs after apply-time running the `terraform output` command. This command is useful for scripts to extract outputs.

Proceed to the next [lesson](./08_Modules.md)

---