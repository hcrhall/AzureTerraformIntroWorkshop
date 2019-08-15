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