# LAB-08: Terraform Modules
we've been configuring Terraform by editing Terraform configurations directly. Building configurations one at a time works well for learning and ad hoc testing, but it does not scale. As your infrastructure grows, demand for services will quickly overwhelm the development team and create a bottleneck. Lack of consistency and reusability will lead to management problems, and complicate troubleshooting. For these reasons, it is desirable to have a way to encapsulate common configuration elements for reuse, similar to an API.

Terraform modules are self-contained packages of Terraform configurations that are managed as a group. Modules are used to create reusable components, improve organization, and to treat pieces of infrastructure as a black box. This lesson will cover the basics of using modules in your configuration.

---

## Using Modules
If you have any resources running from prior lessons, run `terraform destroy` to remove them from your Azure Subscription.

The [Terraform Registry](https://https://registry.terraform.io/) includes a directory of ready-to-use Azure RM modules for various common purposes, which can serve as larger building-blocks for your infrastructure.

In this example, we're going to use two modules:

- Azure RM Network Module to create a Virtual Network and Network Subnet.
- Azure RM Compute Module to create a Linux Virtual Machine.

Modify your [variables.tf](../variables.tf) with the following contents:
```
# Set the AzureRM Regional Data Center Location
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

# Set the name for the Environment resource tag
variable "environment" {
    type    = "string"
    default = "dev"
}

# Set the size of the virtual machine instance that will be provisioned
variable "vm_size" {
    type        = "map"
    default     = {
        "dev"   = "Standard_B2s"
        "prod"  = "Standard_D2s_v3"
    }
    description = "Specifies the size of the virtual machine."
}
```

Modify your [main.tf](../main.tf) with the following contents:
```
# Configure the AzureRM provider
provider "azurerm" {
    version = "=1.32.1"
}

# Generate random password
resource "random_password" "password" {
  length = 16
  special = true
  override_special = "/@\" "
}

# Generate random string
resource "random_string" "random" {
  length = 4
  special = false
}

# Create a new Resource Group
resource "azurerm_resource_group" "rg" {
    name     = "RG-Ryan_Hall-AE"
    location = "${var.location}"

    tags     = {
        environment = "${var.environment}"
        owner       = "${var.owner}"
    }
}

# Use the network module to create a vnet and subnet
module "network" {
    source              = "Azure/network/azurerm"
    version             = "2.0.0"
    location            = "${var.location}"
    resource_group_name = "${azurerm_resource_group.rg.name}"
    address_space       = "10.0.0.0/16"
    subnet_names        = ["${var.environment}-${random_string.random.result}-vNet"]
    subnet_prefixes     = ["10.0.1.0/24"]
    tags                = {
        environment = "${var.environment}"
        costcode    = "1714884364"
        owner       = "${var.owner}"
    }
}

# Use the compute module to create the VM
module "compute" {
    source            = "Azure/compute/azurerm"
    version           = "1.3.0"
    location          = "${var.location}"
    vnet_subnet_id    = "${element(module.network.vnet_subnets, 0)}"
    admin_username    = "UbuntuServerAdmin"
    admin_password    = "${random_password.password.result}"
    remote_port       = "22"
    vm_os_simple      = "UbuntuServer"
    vm_size           = "${lookup(var.vm_size, var.environment)}"
    tags                = {
        environment = "${var.environment}"
        costcode    = "1714884364"
        owner       = "${var.owner}"
    }
}
```

>**Note:**
>
>The **source** attribute is the only mandatory argument for modules. It tells Terraform where the module can be retrieved. Terraform automatically downloads and manages modules for you. Additionally, most modules will have at least a few required arguments.
>
>In this instance, the modules are retrieved from the official Terraform Registry. Terraform can also retrieve modules from a variety of sources, including private module registries or directly from Git, Mercurial, HTTP, and local files.

Modify your [outputs.tf](../outputs.tf) with the following contents:

```
output "azurerm_resource_group_id" {
  value       = "${azurerm_resource_group.rg.id}"
  description = "The Azure Resource ID that has been assigned to the Azure Resource Group."
  sensitive   = false
}

output "compute_admin_password" {
  value       = "${random_password.password.result}"
  description = "The administrative password for the Azure Virtual Machine resource."
  sensitive   = true
}
```
>**Note:**
>
>The configuration above provides an example of how to secure output variable by setting them as **sensitive**.

## Apply Changes
Since our new configuration now includes modules and the random provider, we will need to initialize Terraform before we can apply our changes. Run the `terraform init` command to initialize Terraform.
```
$ terraform init
Initializing modules...
Downloading Azure/compute/azurerm 1.3.0 for compute...
- compute in .terraform\modules\compute\Azure-terraform-azurerm-compute-fb014dd
- compute.os in .terraform\modules\compute\Azure-terraform-azurerm-compute-fb014dd\os
Downloading Azure/network/azurerm 2.0.0 for network...
- network in .terraform\modules\network\Azure-terraform-azurerm-network-564155f

Initializing the backend...

Initializing provider plugins...
- Checking for available provider plugins...
- Downloading plugin for provider "random" (terraform-providers/random) 2.2.0...
- Downloading plugin for provider "azurerm" (terraform-providers/azurerm) 1.32.1...

Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.
``` 

>**Tip:**
>
>Once the init process has completed, review the directory structure in the working directory. You will notice that a [.terraform](./.terraform) directory has been updated and now contains a new sub-directory called [modules](./terraform/modules).

Run the `terraform apply -var "owner=foo" -auto-approve` command and review the output that is returned by the Terraform CLI: 

>**Tip:**
>
>The `-auto-approve` option skips interactive approval of plan before applying.

```
terraform apply -var "owner=foo" -auto-approve
random_string.random: Refreshing state... [id=ns0c]
random_password.password: Refreshing state... [id=none]
module.compute.random_id.vm-sa: Refreshing state... [id=3UCRq4V_]
.....
.....
module.compute.azurerm_resource_group.vm: Refreshing state... [id=/subscriptions/<subscription_id>/resourceGroups/terraform-compute]
module.compute.azurerm_virtual_machine.vm-linux[0]: Still modifying... [id=/subscriptions/<subscription_id>...icrosoft.Compute/virtualMachines/myvm0, 1m0s elapsed]
module.compute.azurerm_virtual_machine.vm-linux[0]: Modifications complete after 1m2s [id=/subscriptions/<subscription_id>/resourceGroups/terraform-compute/providers/Microsoft.Compute/virtualMachines/myvm0]

Apply complete! Resources: 0 added, 8 changed, 0 destroyed.

Outputs:

azurerm_resource_group_id = /subscriptions/<subscription_id>/resourceGroups/RG-Ryan_Hall-AE
compute_admin_password = <sensitive>
```

>**Tip:**
>
>Run the `terraform state list` command to list resources within your Terraform state.

Proceed to the next [lesson](./09_Destroy.md)

---
