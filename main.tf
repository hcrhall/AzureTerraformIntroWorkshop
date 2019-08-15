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