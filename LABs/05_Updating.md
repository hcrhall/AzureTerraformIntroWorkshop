# LAB-05: Updating Infrastructure
At this stage we have provisioned an Azure Resource Group resource within our Azure Subscription which represents a day zero deployment of cloud based infrastructure. In this lab we are going to focus on the day `x` life cycle management of the Terraform workflow. 

Infrastructure is continuously evolving, and Terraform was built to help manage and enact that change. As you change Terraform configurations, Terraform builds an execution plan that only modifies what is necessary to reach your desired state. Terraform builds an execution plan by comparing your desired state (changed configuration) to the current state, saved in the terraform.tfstate file.

---

## Configuration

Let's modify the configuration of our Azure Resource Group resource by adding a few Tags which are usually used for tracking resource ownership, billing etc. Open up the [main.tf](../main.tf) in VSCode and Edit the **azurerm_resource_group** resource in your configuration and change it to the following:
```
# Create a new Resource Group
resource "azurerm_resource_group" "rg" {
    name     = "RG-FirstName_LastName-AE"
    location = "Australia East"
    
    tags     = {
        owner = "FirstName LastName"
    }
}
```
>**Tip:**
>
> Replace the **FirstName** and **LastName** values with your first name and last name so that the resource group tags will reflect that you are the owner of the resource.

## Apply Changes
After changing the configuration, run `terraform apply` in the terminal to see how Terraform will apply this change to the existing resources.

The output of the CLI should resemble the following. As before, review the changes that will be applied and when happy type `yes` and press the `Return` key.
```
$ terraform apply
azurerm_resource_group.rg: Refreshing state... [id=/subscriptions/<subscription_id>/resourceGroups/RG-Ryan_Hall-AE]

An execution plan has been generated and is shown below.
Resource actions are indicated with the following symbols:
  ~ update in-place

Terraform will perform the following actions:

  # azurerm_resource_group.rg will be updated in-place
  ~ resource "azurerm_resource_group" "rg" {
        id       = "/subscriptions/<subscription_id>/resourceGroups/RG-Ryan_Hall-AE"
        location = "australiaeast"
        name     = "RG-Ryan_Hall-AE"
      ~ tags     = {
          + "owner" = "Ryan Hall"
        }
    }

Plan: 0 to add, 1 to change, 0 to destroy.

Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: yes

azurerm_resource_group.rg: Modifying... [id=/subscriptions/<subscription_id>/resourceGroups/RG-Ryan_Hall-AE]
azurerm_resource_group.rg: Modifications complete after 4s [id=/subscriptions/<subscription_id>/resourceGroups/RG-Ryan_Hall-AE]

Apply complete! Resources: 0 added, 1 changed, 0 destroyed.
```

You can now use the `terraform show` command to see the new values associated with the Azure Resource Group:
```
$ terraform show
# azurerm_resource_group.rg:
resource "azurerm_resource_group" "rg" {
    id       = "/subscriptions/<subscription_id>/resourceGroups/RG-Ryan_Hall-AE"
    location = "australiaeast"
    name     = "RG-Ryan_Hall-AE"
    tags     = {
        "owner" = "Ryan Hall"
    }
}
```
Proceed to the next [lesson](./06_Dependencies.md)

---


