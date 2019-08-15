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